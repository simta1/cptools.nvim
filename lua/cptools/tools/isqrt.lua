return function(label)
	vim.ui.input({ prompt = label .. ": " }, function(input)
		if not input then return end

		local util = require("cptools.util")
		local msg

		if not util.is_integer(input) then
			msg = input .. " is not a integer"
		elseif input:sub(1, 1) == "-" then
			msg = input .. " is not a non-negative integer"
		else
			local res = require("cptools.math").isqrt(input)
			msg = "isqrt(" .. input .. ") = " .. res
		end

		util.floating_msg(label, msg)
	end)
end
