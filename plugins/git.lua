local configs = require("configs.git")
local mappings = require("mappings.git")
---@type NvPluginSpec[]
local plugins = {

	{
		-- know whom to blame for this code
		"f-person/git-blame.nvim",
		event = "BufRead",
		config = function(_, _)
			require("gitblame").setup(configs.git_blame())
		end,
	},

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
