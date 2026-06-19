local U = {}

local gmp_checked = false
local gmp_available = false
local gmp_error = nil
local gmp_lib = nil

local gmp_library_names = {
	"gmp",
	"libgmp.so.10",
	"libgmp.so",
	"libgmp.dylib",
	"gmp.dll",
	"libgmp-10.dll",
}

function U.load_gmp()
	if gmp_lib then
		return gmp_lib, nil
	end

	local ok_ffi, ffi = pcall(require, "ffi")
	if not ok_ffi then
		return nil, "LuaJIT FFI is not available"
	end

	local errors = {}
	for _, name in ipairs(gmp_library_names) do
		local ok_load, lib_or_err = pcall(ffi.load, name)
		if ok_load then
			gmp_lib = lib_or_err
			return gmp_lib, nil
		end
		table.insert(errors, name .. ": " .. tostring(lib_or_err))
	end

	return nil, table.concat(errors, "\n")
end

function U.check_gmp()
	if gmp_checked then
		return gmp_available, gmp_error
	end

	gmp_checked = true

	local lib, err = U.load_gmp()
	if not lib then
		gmp_error = err
		return false, gmp_error
	end

	gmp_available = true
	return true, nil
end

function U.notify_missing_gmp()
	vim.notify(
		"cptools.nvim: GMP library not found. Install GMP/libgmp to use CP tools.",
		vim.log.levels.ERROR
	)
end

function U.floating_msg(title, lines)
	if type(lines) == "string" then
		lines = vim.split(lines, "\n")
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.5)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = title,
		title_pos = "center",
	}

	local win = vim.api.nvim_open_win(buf, true, win_opts)

	local number = vim.api.nvim_get_option_value("number", { scope = "global" })
	vim.api.nvim_set_option_value("number", number, { win = win })

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

function U.is_u64_positive(s)
	if not U.is_u64_integer(s) then
		return false
	end
	return s ~= "0"
end

function U.string_lt(a, b)
	if #a ~= #b then
		return #a < #b
	else
		return a < b
	end
end

return U
