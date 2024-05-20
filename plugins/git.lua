---@type NvPluginSpec[]
local plugins = {

	{
		-- know whom to blame for this code
		"f-person/git-blame.nvim",
		event = "BufRead",
		config = function()
			vim.cmd("highlight default link gitblame SpecialComment")
		end,
	},

	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewFileHistory", "DiffviewOpen" },
		keys = require("mappings.diffview-nvim"),
		opts = {
			default_args = {
				DiffviewOpen = { "--imply-local" },
			},
		},
	},

	{
		"NeogitOrg/neogit",
		cmd = { "Neogit" },
		keys = require("mappings.neogit"),
		opts = {
			integrations = {
				telescope = true,
				diffview = true,
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
	},
}
return plugins
