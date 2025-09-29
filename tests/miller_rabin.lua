package.path = "./lua/?.lua;" .. package.path
local M = require("cptools.math")

math.randomseed(os.time())
local function rand_ll()
    return math.random(0, 1e9)
end

for t = 1, 1e4 do
    local n = rand_ll()

    local sqrt = M.is_prime_sqrt(n)
    local millerRabin = M.is_prime(n)

    if sqrt ~= millerRabin then
        print("Mismatch at n = " .. n ..
              " | sqrt=" .. tostring(sqrt) ..
              " millerRabin=" .. tostring(millerRabin))
        os.exit(1)
    end

    if t % 100 == 0 then
        print("Checked " .. t .. " random numbers")
    end
end

print("Success")
