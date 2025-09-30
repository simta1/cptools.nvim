return function(label)
	vim.ui.input({ prompt = label .. ": " }, function(input)
		if not input then return end

		local util = require("cptools.util")
		local msg

		if not util.is_u64_integer(input) then
			msg = input .. " is not a valid unsigned 64-bit integer"
		else
			local res = require("cptools.math").is_prime(input)
			msg = res and (input .. " is prime") or (input .. " is not prime")
		end

		util.floating_msg(label, msg)
	end)
end
