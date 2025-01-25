---@type NvPluginSpec[]
local plugins = {

	{
		"hrsh7th/nvim-cmp",
		opts = function()
			local opts = require("nvchad.configs.cmp")
			opts.sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
			}
			return opts
		end,
	},

	{ "hrsh7th/cmp-nvim-lua", enabled = false },

	{
		"rafamadriz/friendly-snippets",
		enabled = false,
	},

	{
		"nvim-tree/nvim-tree.lua",
		enabled = false,
	},

	{
		"lewis6991/gitsigns.nvim",
		---@type Gitsigns.Config
		opts = vim.tbl_deep_extend("force", require("nvchad.configs.gitsigns") or {}, {
			on_attach = function() end,
			signs = {
				untracked = { text = "┃" },
			},
			attach_to_untracked = true,
		}),
		---@param _ LazyPlugin
		---@param opts Gitsigns.Config
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "git")
			require("gitsigns").setup(opts)
		end,
	},

	{
		"folke/which-key.nvim",
		lazy = false,
	},
}

return plugins
