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


local ffi = require("ffi")

ffi.cdef[[
	typedef struct __mpz_struct {
		int _mp_alloc;
		int _mp_size;
		void *_mp_d;
	} __mpz_struct;

	typedef __mpz_struct mpz_t[1];

	void __gmpz_init(mpz_t x);
	void __gmpz_clear(mpz_t x);
	void __gmpz_set_ui(mpz_t rop, unsigned long int op);
	void __gmpz_set_str(mpz_t rop, const char *str, int base);
	void __gmpz_get_str(char *str, int base, const mpz_t op);

	void __gmpz_add(mpz_t rop, const mpz_t op1, const mpz_t op2);
	void __gmpz_sub(mpz_t rop, const mpz_t op1, const mpz_t op2);
	void __gmpz_mul(mpz_t rop, const mpz_t op1, const mpz_t op2);
	void __gmpz_mod(mpz_t r, const mpz_t n, const mpz_t d);
	void __gmpz_tdiv_q_2exp(mpz_t q, const mpz_t n, unsigned long int b);
	int  __gmpz_cmp(const mpz_t op1, const mpz_t op2);
	void __gmpz_sqrt(mpz_t rop, const mpz_t op);

	void __gmpz_powm(mpz_t rop, const mpz_t base, const mpz_t exp, const mpz_t mod);
]]
local gmp = ffi.load("gmp")

local function new_mpz(val)
	local x = ffi.new("mpz_t")
	gmp.__gmpz_init(x)
	if type(val) == "number" then
		gmp.__gmpz_set_ui(x, val)
	elseif type(val) == "string" then
		gmp.__gmpz_set_str(x, val, 10)
	end
	return x
end

function M.is_prime(n_str)
	local n = new_mpz(n_str)

	-- n < 2
	if gmp.__gmpz_cmp(n, new_mpz(2)) < 0 then return false end

	-- n-1 = d * 2^r
	local d = new_mpz(0)
	gmp.__gmpz_sub(d, n, new_mpz(1))
	local r = 0
	while true do
		local tmp = new_mpz(0)
		gmp.__gmpz_mod(tmp, d, new_mpz(2))
		if gmp.__gmpz_cmp(tmp, new_mpz(0)) ~= 0 then break end
		gmp.__gmpz_tdiv_q_2exp(d, d, 1) -- d >>= 1
		r = r + 1
	end

	-- witness check
	local function check(a_num)
		local a = new_mpz(a_num)
		local x = new_mpz(0)

		local n_minus_1 = new_mpz(0)
		gmp.__gmpz_sub(n_minus_1, n, new_mpz(1))

		gmp.__gmpz_powm(x, a, d, n) -- x = a^d mod n
		if gmp.__gmpz_cmp(x, new_mpz(1)) == 0 or gmp.__gmpz_cmp(x, n_minus_1) == 0 then
			return true
		end
		for _ = 1, r - 1 do
			gmp.__gmpz_mul(x, x, x)
			gmp.__gmpz_mod(x, x, n)
			if gmp.__gmpz_cmp(x, n_minus_1) == 0 then
				return true
			end
		end
		return false
	end

	-- deterministic bases for 64-bit
	local bases = {2, 325, 9375, 28178, 450775, 9780504, 1795265022}
	for _, base in ipairs(bases) do
		local rem = new_mpz(0)
		gmp.__gmpz_mod(rem, new_mpz(base), n)
		if gmp.__gmpz_cmp(rem, new_mpz(0)) ~= 0 and not check(base) then
			return false
		end
	end
	return true
end

function M.is_prime_sqrt(n_str)
    local n = new_mpz(n_str)

    if gmp.__gmpz_cmp(n, new_mpz(2)) < 0 then return false end
    if gmp.__gmpz_cmp(n, new_mpz(2)) == 0 then return true end

    local rem = new_mpz(0)
    gmp.__gmpz_mod(rem, n, new_mpz(2))
    if gmp.__gmpz_cmp(rem, new_mpz(0)) == 0 then return false end

    -- limit = floor(sqrt(n))
    local limit = new_mpz(0)
    gmp.__gmpz_sqrt(limit, n)

    local i = new_mpz(3)
    while gmp.__gmpz_cmp(i, limit) <= 0 do
        gmp.__gmpz_mod(rem, n, i)
        if gmp.__gmpz_cmp(rem, new_mpz(0)) == 0 then
            return false
        end
        gmp.__gmpz_add(i, i, new_mpz(2))
    end

    return true
end

return M
