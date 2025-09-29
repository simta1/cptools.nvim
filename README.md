# Cptools.nvim

<!-- demo -->

<!-- ## Features -->
<!-- - Primality test -->
<!-- - Factorization -->
<!-- - Divisor count / sum -->
<!-- - Prime count up to N -->
<!-- - Combinatorics -->
<!-- - Modular Arithmetic -->
<!-- - Primitive root -->
<!-- - CRT solver -->

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

## Installation
Install the plugin with your plugin manager of choice, then call `require("cptools").setup()` in your config.

### [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
	"simta1/cptools.nvim",
	config = function()
		require("cptools").setup()
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
