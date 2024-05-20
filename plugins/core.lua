---@type NvPluginSpec[]
local plugins = {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = require("configs.nvim-treesitter"),
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		event = "BufRead",
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		event = "BufRead",
	},

	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufEnter",
		opts = require("configs.nvim-ufo"),
		config = function(_, opts)
			vim.o.foldcolumn = "0" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			require("ufo").setup(opts)
		end,
	},

	{
		"RaafatTurki/hex.nvim",
		event = "BufRead",
	},

	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = true,
	},

	{
		"chrisgrieser/nvim-spider",
		keys = require("mappings.nvim-spider"),
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = require("configs.flash-nvim"),
		keys = require("mappings.flash-nvim"),
	},

	{
		"mikavilpas/yazi.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		keys = require("mappings.yazi-nvim"),
	},
}

return plugins
