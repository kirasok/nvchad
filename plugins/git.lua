local configs = require("configs.git")
local mappings = require("mappings.git")
---@type NvPluginSpec[]
local plugins = {

	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewFileHistory", "DiffviewOpen" },
		keys = mappings.diffview,
		opts = configs.diffview,
	},

	{
		"NeogitOrg/neogit",
		cmd = { "Neogit" },
		keys = mappings.neogit,
		opts = configs.neogit,
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
	},
}
return plugins
