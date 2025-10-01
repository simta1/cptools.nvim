return function(label)
	vim.ui.input({ prompt = label .. ": " }, function(input)
		if not input then return end

		local util = require("cptools.util")
		local msg

		if not util.is_u64_positive(input) then
			msg = input .. " is not a positive unsigned 64-bit integer"
		else
			local res = require("cptools.math").highly_composite_leq(input)
			msg = "Largest highly composite number ≤ " .. input .. ":\n"
			.. res.value .. " = " .. res.factorization .. "\n\n"
			.. "Number of divisors: " .. res.divisors
		end

		util.floating_msg(label, msg)
	end)
end
