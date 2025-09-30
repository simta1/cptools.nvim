local U = {}

function U.floating_msg(lines, opts)
	opts = vim.tbl_extend("force", {
        width_ratio = 0.8,
        height_ratio = 0.5,
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

function U.is_integer(s)
	return type(s) == "string" and s:match("^[-]?%d+$") ~= nil
end

function U.is_u64_integer(s)
	if not U.is_integer(s) then
		return false
	end

	if s:sub(1,1) == "-" then
		return false
	end

	local max_u64 = "18446744073709551615" -- 2^64 - 1

	if #s < #max_u64 then
		return true
	elseif #s > #max_u64 then
		return false
	else
		return s <= max_u64
	end
end

return U
