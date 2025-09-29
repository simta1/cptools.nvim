# Cptools.nvim
![Neovim](https://img.shields.io/badge/Neovim-0.7+-%2357A143.svg?logo=neovim)   

<!-- demo -->

## Features
<!-- - Primality test -->
<!-- - Factorization -->
<!-- - Divisor count / sum -->
<!-- - Prime count up to N -->
<!-- - Combinatorics -->
<!-- - Modular Arithmetic -->
<!-- - Primitive root -->
<!-- - CRT solver -->

## Installation (LazyVim)
```lua
return {
	"simta1/cptools.nvim",
	config = function()
		require("cptools").setup()

		vim.keymap.set("n", "<leader>cp", "<cmd>Cptools<cr>", { desc = "Open CP Tools" })
	end,
}
```

## Usage
Use `:Cptools` to open the menu   
