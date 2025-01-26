local configs = require("configs.capabilities")
local mappings = require("mappings.capabilities")
---@type NvPluginSpec[]
return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufEnter",
		config = function(_, _)
			require("ufo").setup(configs.ufo())
		end,
	},

	{
		"utilyre/sentiment.nvim",
		version = "*",
		event = "VeryLazy", -- keep for lazy loading
		config = true,
		init = function()
			-- `matchparen.vim` needs to be disabled manually in case of lazy loading
			vim.g.loaded_matchparen = 1
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},

	{
		"tzachar/highlight-undo.nvim",
		event = "BufRead",
	},

	{
		"gbprod/yanky.nvim",
		event = "BufRead",
		opts = configs.yanky,
	},

	{
		"m4xshen/smartcolumn.nvim",
		event = "BufRead",
		config = true,
	},

	{
		"https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
		event = "BufRead",
	},

	{
		"mcauley-penney/visual-whitespace.nvim",
		event = "ModeChanged",
		commit = "979aea2ab9c62508c086e4d91a5c821df54168a8",
	},

	{
		"hrsh7th/cmp-cmdline",
		dependencies = { "hrsh7th/nvim-cmp", "hrsh7th/cmp-buffer" },
		event = "CmdlineEnter",
		config = configs.cmdline,
	},

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = configs.zen,
		keys = mappings.zen,
	},

	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = mappings.undotree,
	},

	{
		"3rd/image.nvim",
		enabled = os.getenv("TERM") == "xterm-kitty",
		opts = configs.image,
	},

	{
		"godlygeek/tabular",
		cmd = "Tabularize",
	},

	{
		"kirasok/gx.nvim",
		keys = mappings.gx,
		cmd = { "Browse" },
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
		end,
		submodules = false, -- not needed, submodules are required only for tests
		config = configs.gx,
	},

	{
		"danymat/neogen",
		cmd = "Neogen",
		config = configs.neogen,
		keys = mappings.neogen,
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = true,
	},

	{
		"okuuva/auto-save.nvim",
		commit = "29f793a",
		cmd = "ASToggle",
		event = { "InsertLeave", "TextChanged" },
		opts = configs.autosave,
	},
}
