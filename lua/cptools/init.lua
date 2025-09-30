local M = {}
M.config = {}

function M.setup(opts)
	opts = opts or {}

	local dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
	dir = dir .. "tools"

	local modules = {}
	local fs = vim.loop.fs_scandir(dir)
	if not fs then return modules end

	while true do
		local name, t = vim.loop.fs_scandir_next(fs)
		if not name then break end
		if t == "file" and name:match("%.lua$") then
			local modname = name:gsub("%.lua$", "")
			table.insert(modules, modname)
		end
	end

	local all = {}
	for _, m in ipairs(modules) do
		local fn = require("cptools.tools." .. m)
		all[m] = fn
	end
	M.config.all_tools = all

	M.config.tools = {}
	if opts.tools then
		for _, item in ipairs(opts.tools) do
			if type(item) == "string" then
				local fn = all[item]
				if fn then
					table.insert(M.config.tools, { label = item, run = fn })
				end
			elseif type(item) == "table" and item.use then
				-- { use=..., as=... }
				local orig, label = item.use, item.as or item.use
				local fn = all[orig]
				if fn then
					table.insert(M.config.tools, { label = label, run = fn })
				end
			end
		end
	else
		for name, fn in pairs(all) do
			table.insert(M.config.tools, { label = name, run = fn })
		end
	end

	vim.api.nvim_create_user_command("Cptools", function()
		local tools = M.config.tools or {}

		if #tools == 0 then
			vim.notify("cptools.nvim: No tools configured", vim.log.levels.WARN)
			return
		end

		local labels = {}
		for _, t in ipairs(tools) do
			table.insert(labels, t.label)
		end

		vim.ui.select(labels, { prompt = "Select a CP tool" }, function(choice)
			if not choice then return end
			for _, t in ipairs(tools) do
				if t.label == choice then
					local util = require("cptools.util")
					local ok, _ = pcall(function()
						t.run(choice)
					end)
					if not ok then
						vim.notify("cptools.nvim: tool '" .. choice .. "' failed to run", vim.log.levels.ERROR)
					end
					break
				end
			end
		end)
	end, { desc = "Open CP Tools menu" })
end

return M
