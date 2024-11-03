---@type NvPluginSpec[]
local plugins = {

	{
		"hrsh7th/cmp-buffer",
		enabled = false,
	},

	{
		"rafamadriz/friendly-snippets",
		enabled = false,
	},

	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFileToggle" },
		enabled = false,
		opts = require("configs.nvim-tree"),
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "nvimtree")
			require("nvim-tree").setup(opts)
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = vim.tbl_deep_extend("force", require("nvchad.configs.gitsigns") or {}, {
			on_attach = function() end,
		}),
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "git")
			require("gitsigns").setup(opts)
		end,
	},

	{ "nvim-telescope/telescope.nvim", keys = require("mappings.telescope").keys },
}

return plugins
