-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	{
	--Plugin to copy text to the system clipboard using the ANSI OSC52 sequence.
		"ojroques/nvim-osc52"
	},
	{
	-- Additionnal colorscheme.
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
	-- Additionnal colorscheme.
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000
	},
	{
	-- Additionnal colorscheme.
		"rebelot/kanagawa.nvim",
		priority = 1000
	},
	{
	-- For previewing markdown file using web browser with live update and reload.
		"iamcco/markdown-preview.nvim",
	},
	{
	-- Remove all background colors to make nvim transparent (e.g for terminal backgroud image).
		"xiyaowong/transparent.nvim"
	},
	{
	-- A super powerful autopair plugin for Neovim that supports multiple characters.
		"jiangmiao/auto-pairs"
	},
	{
	-- WhichKey is a useful plugin for Neovim 0.5 that displays a popup with possible key bindings 
	-- of the command you started typing.
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
		end,
		opts = {
    			-- your configuration comes here
    			-- or leave it empty to use the default settings
    			-- refer to the configuration section below
		}
	}
}
