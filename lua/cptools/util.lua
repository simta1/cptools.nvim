local U = {}

function U.floating_msg(lines, opts)
	opts = vim.tbl_extend("force", {
        width_ratio = 0.5,
        height_ratio = 0.3,
        border = "rounded",
    }, opts or {})

	if type(lines) == "string" then
		lines = { lines }
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

	local width = math.floor(vim.o.columns * opts.width_ratio)
	local height = math.floor(vim.o.lines * opts.height_ratio)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = opts.border,
		title = opts.title or nil,
		title_pos = "center",
	}

	local win = vim.api.nvim_open_win(buf, true, win_opts)

	vim.keymap.set("n", "q", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, { buffer = buf, nowait = true, noremap = true, silent = true })

	return win
end

return U
