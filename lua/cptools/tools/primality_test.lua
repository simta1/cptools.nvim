return function(show)
	vim.ui.input({ prompt = "Enter number: " }, function(input)
		if not input then return end

		local util = require("cptools.util")
		if not util.is_u64_integer(input) then
			show(input .. " is not a valid unsigned 64-bit integer")
			return
		end

		local res = require("cptools.math").is_prime(input)
		local msg = res and (input .. " is prime") or (input .. " is not prime")
		show(msg)
	end)
end
