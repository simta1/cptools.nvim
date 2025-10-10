return function(label)
	vim.ui.input({ prompt = label .. " - Enter N and MOD (space-separated): " }, function(input)
		if not input then return end

		local util = require("cptools.util")
		local msg
		local n_str, mod_str = input:match("^(%S+)%s+(%S+)$")

		if not n_str or not mod_str then
			msg = "Invalid input. Use: <N> <MOD>"
		elseif not util.is_u64_positive(n_str) or not util.is_u64_positive(mod_str) then
			msg = "Both n and MOD must be positive unsigned 64-bit integers"
		else
			local inv = require("cptools.math").mod_inverse(n_str, mod_str)
			if not inv then
				-- msg = "No modular inverse exists.\ngcd(" .. n_str .. ", " .. mod_str .. ") ≠ 1"
				msg = "No modular inverse exists.\ngcd(" .. n_str .. ", " .. mod_str .. ") != 1"
			else
				-- msg = n_str .. "⁻¹ ≡ " .. inv .. " (mod " .. mod_str .. ")"
				msg = n_str .. "^-1 === " .. inv .. " (mod " .. mod_str .. ")"
			end
		end

		util.floating_msg(label, msg)
	end)
end
