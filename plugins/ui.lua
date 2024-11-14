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
				{ "<leader>l", group = "lsp" },
				{ "<leader>d", group = "dap" },
			})
		end,
	},

	{
		"folke/trouble.nvim",
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
