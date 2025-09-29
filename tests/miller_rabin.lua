package.path = "./lua/?.lua;" .. package.path
local M = require("cptools.math")

math.randomseed(os.time())
local function rand_ll()
    local hi = math.random(0, 2^31 - 1)
    local lo = math.random(0, 2^31 - 1)
    return hi * 2^31 + lo
end

for t = 1, 1e6 do
    local n = rand_ll()

    local sqrt = M.is_prime_sqrt(n)
    local millerRabin = M.is_prime(n)

    if sqrt ~= millerRabin then
        print("Mismatch at n = " .. n ..
              " | sqrt=" .. tostring(sqrt) ..
              " millerRabin=" .. tostring(millerRabin))
        os.exit(1)
    end

    if t % 10000 == 0 then
        print("Checked " .. t .. " random numbers")
    end
end

print("All results match up to 1e7")

