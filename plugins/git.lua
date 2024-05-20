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
		keys = {
			{
				"<leader>gd",
				function()
					local view = require("diffview.lib").get_current_view()
					if view then
						-- Current tabpage is a Diffview; close it
						vim.cmd.DiffviewClose()
					else
						-- No open Diffview exists: open a new one
						vim.cmd.DiffviewOpen()
					end
				end,
				desc = "Diffview",
			},
		},
		opts = {
			default_args = {
				DiffviewOpen = { "--imply-local" },
			},
		},
	},

	{
		"NeogitOrg/neogit",
		cmd = { "Neogit" },
		keys = {
			{ "<leader>go", "<cmd>Neogit<cr>", desc = "Neogit" },
		},
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
