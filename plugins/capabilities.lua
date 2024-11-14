local configs = require("configs.capabilities")
---@type NvPluginSpec[]
return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufEnter",
		config = function(_, _)
			require("ufo").setup(configs.ufo())
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		config = function(_, _)
			require("luasnip").setup(configs.luasnip())
		end,
	},

	{
		"utilyre/sentiment.nvim",
		version = "*",
		event = "VeryLazy", -- keep for lazy loading
		config = true,
		init = function()
			-- `matchparen.vim` needs to be disabled manually in case of lazy loading
			vim.g.loaded_matchparen = 1
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},

	{
		"tzachar/highlight-undo.nvim",
		event = "BufRead",
	},

	{
		"gbprod/yanky.nvim",
		event = "BufRead",
		opts = configs.yanky,
	},

	{
		"m4xshen/smartcolumn.nvim",
		event = "BufRead",
		config = true,
	},

	{
		"https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
		event = "BufRead",
	},

	{
		"mcauley-penney/visual-whitespace.nvim",
		event = "ModeChanged",
		commit = "979aea2ab9c62508c086e4d91a5c821df54168a8",
	},
}
