return function(label)
	vim.ui.input({ prompt = label .. ": " }, function(input)
		if not input then return end

		local util = require("cptools.util")
		local msg

		if not util.is_u64_positive(input) then
			msg = input .. " is not a positive unsigned 64-bit integer"
		else
			local divisors = require("cptools.math").get_all_divisors(input)
			local count = #divisors

			msg = "Divisors of " .. input .. " (" .. count .. " total):\n"
				.. table.concat(divisors, ", ")
		end

		util.floating_msg(label, msg)
	end)
end
