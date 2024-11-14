---@type NvPluginSpec[]
local plugins = {
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
