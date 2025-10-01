return function(label)
	vim.ui.input({ prompt = label .. ": " }, function(input)
		if not input then return end

		local util = require("cptools.util")
		local msg

		if not util.is_u64_positive(input) then
			msg = input .. " is not a positive unsigned 64-bit integer"
		else
			local res = require("cptools.math").factorize(input)

			if #res == 0 then
				msg = "1 has no prime factors"
			else
				local parts = {}
				for _, pe in ipairs(res) do
					local p, e = pe[1], pe[2]
					if e == 1 then
						table.insert(parts, p)
					else
						table.insert(parts, p .. "^" .. e)
					end
				end
				msg = input .. " = " .. table.concat(parts, " * ")
			end
		end

		util.floating_msg(label, msg)
	end)
end
