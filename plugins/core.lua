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

	{
		"johmsalas/text-case.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function(_, opts)
			require("textcase").setup(opts)
			require("telescope").load_extension("textcase")
		end,
		keys = {
			{
				"<space>fc",
				"<cmd>TextCaseOpenTelescope<CR>",
				mode = { "n", "x" },
				desc = "telescope convert text case",
			},
		},
		cmd = {
			"Subs",
			"TextCaseOpenTelescope",
			"TextCaseOpenTelescopeQuickChange",
			"TextCaseOpenTelescopeLSPChange",
			"TextCaseStartReplacingCommand",
		},
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
