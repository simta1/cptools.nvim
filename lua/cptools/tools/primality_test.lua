return function(show)
	vim.ui.input({ prompt = "Enter number: " }, function(input)
		if not input then return end
		local n = tonumber(input)
		local res = require("cptools.math").is_prime(n)
		local msg = res and (n .. " is prime") or (n .. " is not prime")
		show(msg)
	end)
end
