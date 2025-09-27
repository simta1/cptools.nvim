local M = {}

function M.isqrt(n)
	if n < 0 then
		error("cptools.math.sqrt: negative input")
	end

	local x = math.floor(math.sqrt(n))

	while (x + 1) * (x + 1) <= n do
		x = x + 1
	end
	while x * x > n do
		x = x - 1
	end

	return x
end


function M.is_prime(n)
	if type(n) ~= "number" or n ~= math.floor(n) then
		error("cptools.math.is_prime: input must be an integer")
	end

	-- TODO: Miller-Rabin
	if n < 2 then
		return false
	end
	if n == 2 then
		return true
	end
	if n % 2 == 0 then
		return false
	end

	local limit = M.isqrt(n)
	for i = 3, limit, 2 do
		if n % i == 0 then
			return false
		end
	end
	return true
end

return M
