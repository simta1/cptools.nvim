return function(show)
	vim.ui.input({ prompt = "Enter number: " }, function(input)
		if not input then return end

		local util = require("cptools.util")
		if not util.is_integer(input) then
			show(input .. " is not integer")
			return
		end

		local res = require("cptools.math").isqrt(input)
		local msg = "isqrt(" .. input .. ") = " .. res
		show(msg)
	end)
end
