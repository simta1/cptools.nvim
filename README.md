# Cptools.nvim

<!-- demo -->

## Features
- **Primality test:** Check if a 64-bit unsigned integer is prime
- **Integer square root:** Exact `floor(sqrt(N))` for big integers.
- **Highly composite number ≤ N:** Find the largest highly composite number ≤ N (64-bit unsigned), with divisor count and prime factorization
- **Prime factorization:** Factorize a 64-bit unsigned integer into primes

> **Project status:** Early in development. Interfaces and behavior may change, and performance/edge cases are still being tuned. Feedback and issues are very welcome!

## Planned Features (not implemented yet)
- **Divisors list**
- **Divisor count / sum**
- **Prime count up to N**
- **Combinatorics**
- **Modular Arithmetic**
- **Primitive root**
- **CRT solver**
- **Base conversion**

## Requirements
- [Neovim](https://neovim.io/) 0.7+   
- [GMP](https://gmplib.org/) (GNU Multiple Precision Arithmetic Library)   

If GMP is not installed on your system, install it first:
```bash
# Arch Linux
sudo pacman -S gmp

# Ubuntu/Debian
sudo apt install libgmp-dev
```

## Installation ([lazy.nvim](https://github.com/folke/lazy.nvim))
Install the plugin with your preferred plugin manager, and add `require("cptools").setup()` to your Neovim configuration.

<!-- ### [lazy.nvim](https://github.com/folke/lazy.nvim) -->
```lua
{
	"simta1/cptools.nvim",
	config = function()
		require("cptools").setup()
		vim.keymap.set("n", "<leader>cp", "<cmd>Cptools<cr>", { desc = "Open CP Tools" })
	end,
}
```
By default, all available [tools](/lua/cptools/tools/) are automatically registered, and they appear in the `:Cptools` menu in **alphabetical order**.   
If you want to customize which tools appear (and in which order), you can explicitly list them.   
When you define `tools` in the config, the menu will show them **in the same order you specify**:   
```lua
{
	"simta1/cptools.nvim",
	config = function()
		require("cptools").setup({
			tools = {
				-- 'use' is the filename under 'lua/cptools/tools/'
				-- 'as' is the display name shown in the :Cptools menu
				{ use = "primality_test", as = "prime check" },
				{ use = "prime_factorization", as = "prime factorization" },
				{ use = "isqrt", as = "isqrt" },
				{ use = "highly_composite_number", as = "highly composite number" },
			}
		})

		vim.keymap.set("n", "<leader>cp", "<cmd>Cptools<cr>", { desc = "Open CP Tools" })
	end,
}
```

<!-- ### [packer.nvim](https://github.com/wbthomason/packer.nvim) -->
<!-- ```lua -->
<!-- use { -->
<!-- 	"simta1/cptools.nvim", -->
<!-- 	config = function() -->
<!-- 		require("cptools").setup() -->
<!-- 		vim.keymap.set("n", "<leader>cp", "<cmd>Cptools<cr>", { desc = "Open CP Tools" }) -->
<!-- 	end, -->
<!-- } -->
<!-- ``` -->
<!---->
<!-- ### [vim-plug](https://github.com/junegunn/vim-plug) -->
<!-- ```vim -->
<!-- Plug 'simta1/cptools.nvim' -->
<!---->
<!-- lua << EOF -->
<!-- require("cptools").setup() -->
<!-- vim.keymap.set("n", "<leader>cp", "<cmd>Cptools<cr>", { desc = "Open CP Tools" }) -->
<!-- EOF -->
<!-- ``` -->
<!---->
<!-- ### [dein.vim](https://github.com/Shougo/dein.vim) -->
<!-- ```vim -->
<!-- call dein#add('simta1/cptools.nvim') -->
<!---->
<!-- lua << EOF -->
<!-- require("cptools").setup() -->
<!-- vim.keymap.set("n", "<leader>cp", "<cmd>Cptools<cr>", { desc = "Open CP Tools" }) -->
<!-- EOF -->
<!-- ``` -->
<!---->
<!-- ### [paq-nvim](https://github.com/savq/paq-nvim) -->
<!-- ```lua -->
<!-- require "paq" { -->
<!--     "simta1/cptools.nvim"; -->
<!-- } -->
<!---->
<!-- require("cptools").setup() -->
<!-- vim.keymap.set("n", "<leader>cp", "<cmd>Cptools<cr>", { desc = "Open CP Tools" }) -->
<!-- ``` -->

## Usage
This plugin does not define any default key mappings. You can create your own mappings, for example:   
```lua
vim.keymap.set("n", "<leader>cp", "<cmd>Cptools<cr>", { desc = "Open CP Tools" })
```

Or simply run the command:   
```vim
:Cptools
```
