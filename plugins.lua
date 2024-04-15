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

			local opts = { noremap = true, silent = true }
			local keymap = vim.api.nvim_buf_set_keymap

			local zk = require("zk")
			local commands = require("zk.commands")

			local function tbl_length(T)
				local count = 0
				for _ in pairs(T) do
					count = count + 1
				end
				return count
			end

			local function get_visual_selection()
				-- this will exit visual mode
				-- use 'gv' to reselect the text
				local _, csrow, cscol, cerow, cecol
				local mode = vim.fn.mode()
				if mode == "v" or mode == "V" or mode == "�" then
					-- if we are in visual mode use the live position
					_, csrow, cscol, _ = unpack(vim.fn.getpos("."))
					_, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
					if mode == "V" then
						-- visual line doesn't provide columns
						cscol, cecol = 0, 999
					end
					-- exit visual mode
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
				else
					-- otherwise, use the last known visual position
					_, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
					_, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
				end
				-- swap vars if needed
				if cerow < csrow then
					csrow, cerow = cerow, csrow
				end
				if cecol < cscol then
					cscol, cecol = cecol, cscol
				end
				local lines = vim.fn.getline(csrow, cerow)
				-- local n = cerow-csrow+1
				local n = tbl_length(lines)
				if n <= 0 then
					return ""
				end
				lines[n] = string.sub(lines[n], 1, cecol)
				lines[1] = string.sub(lines[1], cscol)
				return table.concat(lines, "\n")
			end

			local function yankNameReplace(options, picker_options)
				local selected = get_visual_selection()
				zk.pick_notes(options, picker_options, function(notes)
					local pos = vim.api.nvim_win_get_cursor(0)[2]
					local line = vim.api.nvim_get_current_line()

					if picker_options.multi_select == false then
						notes = { notes }
					end
					for _, note in ipairs(notes) do
						local nline = line:sub(0, pos - #selected)
							.. "[["
							.. note.path:match("^.+/(.+)$"):sub(1, -4)
							.. "|"
							.. selected
							.. "]]"
							.. line:sub(pos + 1)
						vim.api.nvim_set_current_line(nline)
					end
				end)
			end

			commands.add("ZkYankNameReplace", function(options)
				yankNameReplace(options, { title = "Zk Yank" })
			end)

			keymap(0, "v", "zi", "<Cmd>ZkYankNameReplace<CR>", opts)
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
		event = "LspAttach",
		config = true,
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

	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		opts = {
			autocmd = { enabled = true },
			ignore = {
				ft = { "dart" },
			},
		},
		config = true,
	},

	{
		"hedyhli/outline.nvim",
		cmd = { "Outline", "OutlineOpen" },
		keys = { -- Example mapping to toggle outline
			{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		opts = {
			outline_window = {
				show_cursorline = true,
				hide_cursor = true,
			},
			guides = {
				enabled = false,
			},
			preview_window = {
				auto_preview = true,
			},
			symbols = {
				icons = {
					File = { icon = "󰈔 ", hl = "Identifier" },
					Module = { icon = "󰆧 ", hl = "Include" },
					Namespace = { icon = "󰅪 ", hl = "Include" },
					Package = { icon = "󰏗 ", hl = "Include" },
					Class = { icon = " ", hl = "Type" },
					Method = { icon = "ƒ", hl = "Function" },
					Property = { icon = " ", hl = "Identifier" },
					Field = { icon = "󰆨 ", hl = "Identifier" },
					Constructor = { icon = " ", hl = "Special" },
					Enum = { icon = " ", hl = "Type" },
					Interface = { icon = "󰜰 ", hl = "Type" },
					Function = { icon = "", hl = "Function" },
					Variable = { icon = " ", hl = "Constant" },
					Constant = { icon = " ", hl = "Constant" },
					String = { icon = " ", hl = "String" },
					Number = { icon = "#", hl = "Number" },
					Boolean = { icon = "⊨", hl = "Boolean" },
					Array = { icon = "󰅪 ", hl = "Constant" },
					Object = { icon = "⦿ ", hl = "Type" },
					Key = { icon = "🔐", hl = "Type" },
					Null = { icon = "NULL", hl = "Type" },
					EnumMember = { icon = " ", hl = "Identifier" },
					Struct = { icon = " ", hl = "Structure" },
					Event = { icon = "", hl = "Type" },
					Operator = { icon = "+", hl = "Identifier" },
					TypeParameter = { icon = " ", hl = "Identifier" },
					Component = { icon = "󰅴 ", hl = "Function" },
					Fragment = { icon = "󰅴 ", hl = "Constant" },
					TypeAlias = { icon = " ", hl = "Type" },
					Parameter = { icon = " ", hl = "Identifier" },
					StaticMethod = { icon = " ", hl = "Function" },
					Macro = { icon = " ", hl = "Function" },
				},
			},
		},
	},

	{
		"Wansmer/symbol-usage.nvim",
		event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. WARN: On 0.10 use 'LspAttach'
		config = true,
	},

	{
		"lukas-reineke/headlines.nvim",
		ft = { "markdown", "org", "norg" },
		opts = {
			markdown = {
				fat_headlines = false,
				bullets = { "◉", "󰻃", "○", "✿" },
			},
		},
		config = function(_, opts)
			require("headlines").setup(opts)
			vim.cmd([[hi Headline guibg=none]])
			vim.cmd([[hi CodeBlock guibg=none]])
			vim.cmd([[hi Dash guibg=none]])
			vim.cmd([[hi Quote guibg=none]])
		end,
	},

	{
		"kylechui/nvim-surround",
		event = "BufRead",
		config = true,
	},

	{
		"roobert/surround-ui.nvim",
		event = "BufRead",
		dependencies = {
			"kylechui/nvim-surround",
			"folke/which-key.nvim",
		},
		config = function()
			require("surround-ui").setup({
				root_key = "S",
			})
		end,
	},
}

return plugins
