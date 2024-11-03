---@type NvPluginSpec[]
local plugins = {
	{
		"folke/which-key.nvim",
		config = function(_, opts)
			-- default config function's stuff
			dofile(vim.g.base46_cache .. "whichkey")
			local wk = require("which-key")
			wk.setup(opts)

			-- your custom stuff
			wk.add({
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>s", group = "snippet" },
				{ "<leader>q", group = "quickfix" },
			})
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},

	{
		-- open fields in the last place you left
		"ethanholz/nvim-lastplace",
		lazy = false,
		opts = {
			lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
			lastplace_ignore_filetype = {
				"gitcommit",
				"gitrebase",
				"svn",
				"hgcommit",
			},
			lastplace_open_folds = true,
		},
	},

	{
		"tzachar/highlight-undo.nvim",
		event = "BufRead",
	},

	{
		"folke/trouble.nvim",
		-- TODO: add support for lsp methods
		opts = {}, -- WARN: don't remove
		cmd = "Trouble",
		keys = {
			{
				"<leader>qq",
				"<cmd>Trouble diagnostics toggle focus=true<cr>",
				desc = "Diagnostics",
			},
			{
				"<leader>qQ",
				"<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
				desc = "Buffer Diagnostics",
			},
			{
				"<leader>qt",
				"<cmd>Trouble todo toggle focus=true<cr>",
				desc = "Todos",
			},
		},
	},

	{
		"gbprod/yanky.nvim",
		event = "BufRead",
		opts = {
			highlight = {
				timer = 250,
			},
		},
	},

	{
		"m4xshen/smartcolumn.nvim",
		event = "BufRead",
		config = true,
	},

	{
		"gelguy/wilder.nvim",
		event = "CmdlineEnter",
		build = ":UpdateRemotePlugins",
		opts = { modes = { ":", "/", "?" } },
		config = function(_, opts)
			local wilder = require("wilder")
			wilder.setup(opts)
			wilder.set_option(
				"renderer",
				wilder.popupmenu_renderer({
					highlighter = wilder.basic_highlighter(),
					left = { " ", wilder.popupmenu_devicons() },
					right = { " ", wilder.popupmenu_scrollbar() },
				})
			)
		end,
	},

	{
		"cpea2506/relative-toggle.nvim",
		event = "BufEnter",
		opts = {
			pattern = "*",
			events = {
				on = { "BufEnter", "FocusGained", "InsertLeave", "WinEnter", "CmdlineLeave" },
				off = { "BufLeave", "FocusLost", "InsertEnter", "WinLeave", "CmdlineEnter" },
			},
		},
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
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			window = {
				width = 75,
				options = {
					number = false,
					relativenumber = false,
					cursorline = false,
				},
			},
		},
		keys = require("mappings.zen-mode-nvim"),
	},

	{ "DanilaMihailov/beacon.nvim", event = "BufEnter", commit = "098ff96" },

	{
		"3rd/image.nvim",
		enabled = false,
		ft = "markdown",
		dependencies = {
			{
				"vhyrro/luarocks.nvim",
				priority = 1001, -- this plugin needs to run before anything else
				opts = {
					rocks = { "magick" },
				},
			},
		},
		opts = {
			backend = "kitty",
			max_height = 12, -- ^
			max_width = 128,
			max_height_window_percentage = math.huge, -- this is necessary for a good experience
			max_width_window_percentage = math.huge,
			window_overlap_clear_enabled = true,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
			integrations = {
				markdown = {
					download_remote_images = false,
				},
				neorg = {
					download_remote_images = false,
				},
			},
		},
	},

	{
		"Aasim-A/scrollEOF.nvim",
		event = { "CursorMoved", "WinScrolled" },
		opts = {
			insert_mode = true,
			disabled_filetypes = { "quickfix" },
		},
	},

	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "undotree toggle" },
		},
	},
}

return plugins
