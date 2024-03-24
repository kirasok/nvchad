---@type NvPluginSpec[]
local plugins = {

	{
		"folke/which-key.nvim",
		config = function(_, opts)
			-- default config function's stuff
			dofile(vim.g.base46_cache .. "whichkey")
			require("which-key").setup(opts)

			-- your custom stuff
			require("which-key").register({
				f = { name = "find" },
				g = { name = "git" },
				i = { name = "info" },
				w = { name = "workspace" },
				n = { name = "neogen" },
			}, { prefix = "<leader>" })
		end,
	},

	{
		"hrsh7th/cmp-buffer",
		enabled = false,
	},

	{
		"rafamadriz/friendly-snippets",
		enabled = false,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = require("configs.nvim-treesitter"),
	},

	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFileToggle" },
		opts = function()
			return require("nvchad.configs.nvimtree")
		end,
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "nvimtree")
			require("nvim-tree").setup(opts)
			require("nvim-tree").setup({
				sort = {
					folders_first = false,
				},
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mfussenegger/nvim-lint",
				config = function(_, opts)
					require("configs.nvim-lint")
				end,
			},
			{
				"stevearc/conform.nvim",
				opts = require("configs.conform"),
				config = true,
			},
		},
		config = function()
			require("nvchad.configs.lspconfig")
			require("configs.lspconfig")
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		config = function(_, opts)
			require("nvchad.configs.luasnip")
			require("configs.luasnip")
		end,
	},

	{
		-- manage zettelkasten
		"mickael-menu/zk-nvim",
		ft = "markdown",
		opts = require("configs.zk-nvim"),
		config = function(_, opts)
			require("zk").setup(opts)
			vim.cmd([[set backupcopy=yes]])
		end,
	},

	{
		"NvChad/nvim-colorizer.lua",
		ft = { "javascript", "css", "toml", "yaml", "scss" },
		opts = require("configs.nvim-colorizer"),
		config = function(_, opts)
			require("colorizer").setup(opts)
			-- execute colorizer as soon as possible
			vim.defer_fn(function()
				require("colorizer").attach_to_buffer(0)
			end, 0)
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
		opts = require("configs.nvim-lastplace"),
		config = true,
	},

	{
		-- autoclose and autorename html tags
		"windwp/nvim-ts-autotag",
		ft = {
			"astro",
			"glimmer",
			"handlebars",
			"html",
			"javascript",
			"jsx",
			"markdown",
			"php",
			"rescript",
			"svelte",
			"tsx",
			"typescript",
			"vue",
			"xml",
		},
		config = true,
	},

	{
		-- know whom to blame for this code
		"f-person/git-blame.nvim",
		event = "BufRead",
		config = function()
			vim.cmd("highlight default link gitblame SpecialComment")
		end,
	},

	{
		-- Print function signature in popup window
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").on_attach()
		end,
	},

	{
		-- conceal things for better document editing
		"KeitaNakamura/tex-conceal.vim",
		ft = "tex",
		config = function()
			vim.g["tex_conceal"] = "abdgm"
		end,
	},

	{
		"iurimateus/luasnip-latex-snippets.nvim",
		dependencies = { "L3MON4D3/LuaSnip", "nvim-treesitter/nvim-treesitter" },
		opts = { use_treesitter = true },
		config = function(_, opts)
			require("luasnip-latex-snippets").setup(opts)
			require("luasnip").config.setup({ enable_autosnippets = true })
		end,
		ft = { "tex", "markdown" },
	},

	{
		-- ledger plugin for (neo)vim
		"ledger/vim-ledger",
		ft = { "ledger" },
	},

	{
		-- paste image from clipboard
		-- WARN: use of fork until upstream fixes health
		"kirasok/clipboard-image.nvim",
		ft = { "markdown" },
		cmd = { "PasteImg" },
		opts = require("configs.clipboard-image"),
		config = true,
	},

	{
		"luizribeiro/vim-cooklang",
		ft = { "cook" },
	},

	{
		"kirasok/cmp-hledger",
		ft = "ledger",
		config = function()
			local cmp = require("cmp")
			local config = cmp.get_config()
			table.insert(config.sources, {
				name = "hledger",
			})
			cmp.setup(config)
		end,
	},

	{
		"kirasok/vim-klog",
		ft = { "klog" },
	},

	{
		"tzachar/highlight-undo.nvim",
		event = "BufRead",
		config = true,
	},

	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = true,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		event = "BufRead",
		config = true,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		event = "BufRead",
	},

	{
		"kevinhwang91/nvim-bqf",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		ft = "qf",
		config = true,
	},

	{
		"gbprod/yanky.nvim",
		event = "BufRead",
		opts = require("configs.yanky"),
		config = true,
	},

	{
		"hrsh7th/cmp-emoji",
		ft = "markdown",
		config = function(_, opts)
			local cmp = require("cmp")
			local config = cmp.get_config()
			table.insert(config.sources, {
				name = "emoji",
			})
			cmp.setup(config)
		end,
	},

	{
		"m4xshen/smartcolumn.nvim",
		event = "BufRead",
		config = true,
	},

	{
		"RaafatTurki/hex.nvim",
		event = "BufRead",
		config = true,
	},

	{
		"gelguy/wilder.nvim",
		event = "CmdlineEnter",
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
		"calops/hmts.nvim",
		ft = "nix",
		version = "*",
		config = true,
	},

	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",

			-- optional
			"rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = "leetcode.nvim" ~= vim.fn.argv()[1],
		opts = {
			lang = "python3",
		},
		config = true,
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
		config = true,
	},

	{
		"https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
		event = "BufRead",
	},

	{
		"akinsho/flutter-tools.nvim",
		ft = "dart",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		config = true,
	},

	{
		"mcauley-penney/visual-whitespace.nvim",
		event = "ModeChanged",
		commit = "979aea2ab9c62508c086e4d91a5c821df54168a8",
		config = true,
	},

	{
		"utilyre/sentiment.nvim",
		version = "*",
		event = "LspAttach", -- keep for lazy loading
		config = true,
		init = function()
			-- `matchparen.vim` needs to be disabled manually in case of lazy loading
			vim.g.loaded_matchparen = 1
		end,
	},

	{
		"luckasRanarison/clear-action.nvim",
		event = "LspAttach",
		opts = {
			signs = {
				icons = {
					quickfix = "🔧",
					refactor = "💡",
					source = "🔗",
					combined = "💡", -- used when combine is set to true or as a fallback when there is no action kind
				},
			},
			popup = {
				hide_cursor = true,
			},
			mappings = {
				code_action = "fa",
			},
		},
	},

	{
		"smjonas/inc-rename.nvim",
		dependencies = {
			{
				"stevearc/dressing.nvim",
				opts = {
					input = {
						override = function(conf)
							conf.col = 1
							conf.row = 4
							return conf
						end,
					},
				},
			}, -- optional for vim.ui.select
		},
		event = "LspAttach",
		opts = {
			input_buffer_type = "dressing",
		},
		config = true,
	},

	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		event = "LspAttach",
		config = function(_, opts)
			require("lsp_lines").setup()
			vim.diagnostic.config({
				virtual_text = false,
			})
		end,
	},
}

return plugins
