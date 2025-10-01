local M = {}

local ffi = require("ffi")
local util = require("cptools.util")

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
	char* __gmpz_get_str(char *str, int base, const mpz_t op);
	void __gmpz_set(mpz_t rop, const mpz_t op);

	void __gmpz_add(mpz_t rop, const mpz_t op1, const mpz_t op2);
	void __gmpz_sub(mpz_t rop, const mpz_t op1, const mpz_t op2);
	void __gmpz_mul(mpz_t rop, const mpz_t op1, const mpz_t op2);
	void __gmpz_mod(mpz_t r, const mpz_t n, const mpz_t d);
	void __gmpz_tdiv_q(mpz_t q, const mpz_t n, const mpz_t d);
	void __gmpz_tdiv_q_2exp(mpz_t q, const mpz_t n, unsigned long int b);
	int  __gmpz_cmp(const mpz_t op1, const mpz_t op2);
	void __gmpz_sqrt(mpz_t rop, const mpz_t op);
	void __gmpz_gcd(mpz_t rop, const mpz_t op1, const mpz_t op2);

	void __gmpz_powm(mpz_t rop, const mpz_t base, const mpz_t exp, const mpz_t mod);

	void free(void *ptr);
]]
local gmp = ffi.load("gmp")

local function new_mpz(val)
	local x = ffi.new("mpz_t")
	gmp.__gmpz_init(x)

	ffi.gc(x, gmp.__gmpz_clear)

	if type(val) == "number" then
		gmp.__gmpz_set_ui(x, val)
	elseif type(val) == "string" then
		gmp.__gmpz_set_str(x, val, 10)
	end
	return x
end

local function mpz_to_string(x)
	local cstr = gmp.__gmpz_get_str(nil, 10, x)
	local str = ffi.string(cstr)
	ffi.C.free(cstr)
	return str
end

function M.isqrt(n_str)
	local n = new_mpz(n_str)

	if gmp.__gmpz_cmp(n, new_mpz(0)) < 0 then
		error("cptools.math.isqrt: negative input")
	end

	local root = new_mpz(0)
	gmp.__gmpz_sqrt(root, n)

	return mpz_to_string(root)
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

local hcn = require("cptools.data.highly_composite_numbers")
function M.highly_composite_leq(n_str)
	local n = new_mpz(n_str)

	local lo, hi = 1, #hcn + 1
	while lo + 1 < hi do
		local mid = math.floor((lo + hi) / 2)

		local cur = new_mpz(hcn[mid][1])
		if gmp.__gmpz_cmp(cur, n) <= 0 then
			lo = mid
		else
			hi = mid - 1
		end
	end
	return {
		value = hcn[lo][1],
		divisors = hcn[lo][2],
		factorization = hcn[lo][3],
	}
end

local function mpz_abs_sub(a, b)
	local t = new_mpz(0)
	gmp.__gmpz_sub(t, a, b)
	if gmp.__gmpz_cmp(t, new_mpz(0)) < 0 then
		gmp.__gmpz_sub(t, b, a)
	end
	return t
end

local function random_mpz_below(n)
	-- NOTE: I avoid using __gmpz_urandomm with a GMP randstate because managing
	-- the randstate safely via LuaJIT FFI is tricky and error-prone (layout/GC issues).
	-- Instead, I synthesize a big random mpz using math.random 31-bit chunks and
	-- reduce modulo n. This is good enough for Pollard–Rho’s randomness needs.
	local acc = new_mpz(0)
	local base = new_mpz(2147483648) -- 2^31

	for _ = 1, 4 do
		local chunk = new_mpz(math.random(0, 2147483647))
		gmp.__gmpz_mul(acc, acc, base)
		gmp.__gmpz_add(acc, acc, chunk)
	end
	gmp.__gmpz_mod(acc, acc, n)
	return acc
end

local function f(x, c, n)
	local xx = new_mpz(0)
	gmp.__gmpz_mul(xx, x, x)
	gmp.__gmpz_add(xx, xx, c)
	gmp.__gmpz_mod(xx, xx, n)
	return xx
end

local function pollard_rho(n)
	local rem = new_mpz(0)
	local two = new_mpz(2)
	gmp.__gmpz_mod(rem, n, two)
	if gmp.__gmpz_cmp(rem, new_mpz(0)) == 0 then
		return two
	end

	if M.is_prime(mpz_to_string(n)) then
		return new_mpz(mpz_to_string(n))
	end

	local g = new_mpz(0)

	repeat
		local nm2 = new_mpz(0)
		gmp.__gmpz_sub(nm2, n, new_mpz(2))
		local a = random_mpz_below(nm2)
		gmp.__gmpz_add(a, a, new_mpz(2)) -- 2 <= a <= n-1
		local b = new_mpz(0)
		gmp.__gmpz_set(b, a)
		local c = new_mpz(tostring(math.random(1, 10)))

		repeat
			a = f(a, c, n)
			b = f(f(b, c, n), c, n)
			local diff = mpz_abs_sub(a, b)
			gmp.__gmpz_gcd(g, diff, n)
		until gmp.__gmpz_cmp(g, new_mpz(1)) ~= 0
	until gmp.__gmpz_cmp(g, n) ~= 0

	return pollard_rho(g)
end

function M.factorize(n_str)
	local n = new_mpz(n_str)
	local factors = {}

	if gmp.__gmpz_cmp(n, new_mpz(1)) > 0 then
		while gmp.__gmpz_cmp(n, new_mpz(1)) > 0 do
			local prime = pollard_rho(n)
			local cnt = 0

			local rem = new_mpz(0)
			gmp.__gmpz_mod(rem, n, prime)
			while gmp.__gmpz_cmp(rem, new_mpz(0)) == 0 do
				gmp.__gmpz_tdiv_q(n, n, prime)
				cnt = cnt + 1

				gmp.__gmpz_mod(rem, n, prime)
			end

			table.insert(factors, { mpz_to_string(prime), cnt })
		end
	end
	table.sort(factors, function(a, b) return util.string_lt(a[1], b[1]) end)
	return factors
end

function M.get_all_divisors(n_str)
	local facs = M.factorize(n_str)

	local res = { "1" }
	for _, pe in ipairs(facs) do
		local p, e = pe[1], pe[2]
		local sz = #res
		local curP = new_mpz(p)

		for _ = 1, e do
			local new_vals = {}
			for i = 1, sz do
				local val = new_mpz(res[i])
				gmp.__gmpz_mul(val, val, curP)
				table.insert(new_vals, mpz_to_string(val))
			end
			for _, v in ipairs(new_vals) do
				table.insert(res, v)
			end
			gmp.__gmpz_mul(curP, curP, new_mpz(p))
		end
	end

	table.sort(res, util.string_lt)

	return res
end

return M
