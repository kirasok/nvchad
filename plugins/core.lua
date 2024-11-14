---@type NvPluginSpec[]
local plugins = {

	{
		"RaafatTurki/hex.nvim",
		event = "BufRead",
	},

	{
		"chrisgrieser/nvim-scissors",
		dependencies = { "nvim-telescope/telescope.nvim", "L3MON4D3/LuaSnip" },
		opts = { snippetDir = vim.fn.stdpath("config") .. "/lua/snippets_vscode" },
		cmd = { "ScissorsAddNewSnippet", "ScissorsEditSnippet" },
		keys = {
			{
				"<leader>sa",
				function()
					require("scissors").addNewSnippet()
				end,
				desc = "Add snippet",
				mode = { "n", "v" },
			},
			{
				"<leader>se",
				function()
					require("scissors").editSnippet()
				end,
				desc = "Edit snippet",
				mode = "n",
			},
		},
		config = function(_, opts)
			require("scissors").setup(opts)
		end,
	},
}

return plugins
