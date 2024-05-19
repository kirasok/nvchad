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
		enabled = false,
		opts = {
			filters = {
				dotfiles = false,
			},
			disable_netrw = true,
			hijack_netrw = true,
			hijack_cursor = true,
			hijack_unnamed_buffer_when_opening = false,
			sync_root_with_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = false,
			},
			view = {
				adaptive_size = false,
				side = "left",
				width = 30,
				preserve_window_proportions = true,
			},
			git = {
				enable = true,
				ignore = true,
			},
			filesystem_watchers = {
				enable = true,
			},
			actions = {
				open_file = {
					resize_window = true,
				},
			},
			renderer = {
				root_folder_label = false,
				highlight_git = true,
				highlight_opened_files = "none",

				indent_markers = {
					enable = true,
				},

				icons = {
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
					},

					glyphs = {
						default = "󰈚",
						symlink = "",
						folder = {
							default = "",
							empty = "",
							empty_open = "",
							open = "",
							symlink = "",
							symlink_open = "",
							arrow_open = "",
							arrow_closed = "",
						},
						git = {
							unstaged = "",
							staged = "󰱒",
							unmerged = "",
							renamed = "➜",
							untracked = "★",
							deleted = "",
							ignored = "◌",
						},
					},
				},
			},
			sort = {
				folders_first = false,
			},
		},
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "nvimtree")
			require("nvim-tree").setup(opts)
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
		"zk-org/zk-nvim",
		ft = "markdown",
		opts = require("configs.zk-nvim"),
		config = function(_, opts)
			require("zk").setup(opts)
			vim.cmd([[set backupcopy=yes]])
		end,
		keys = {
			{
				"zi",
				function(options)
					local zk = require("zk")

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
									.. note.path:match("/?([^/]+).md$")
									.. "|"
									.. selected
									.. "]]"
									.. line:sub(pos + 1)
								vim.api.nvim_set_current_line(nline)
							end
						end)
					end

					yankNameReplace(options, { title = "Zk Yank" })
				end,
				mode = "v",
				desc = "Insert link on VISUAL",
			},
			{
				"zp",
				function()
					require("zk").new({ title = vim.fn.input("title: "), dir = "projects" })
				end,
				desc = "zk: new project",
			},
			{
				"zn",
				function()
					require("zk").new({ title = vim.fn.input("title: ") })
				end,
				desc = "zk: new note",
			},
			{
				"zz",
				function()
					require("zk").edit({ sort = { "modified" } })
				end,
				desc = "zk: open note",
			},
			{
				"zp",
				function()
					require("zk").new({ title = vim.fn.input("title: "), dir = "projects", group = "projects" })
				end,
				desc = "zk: new project",
			},
			{ "zb", "<CMD>ZkBacklinks<CR>", desc = "zk: backlinks" },
			{ "zn", ":'<,'>ZkNewFromTitleSelection<CR>", mode = "v", desc = "zk: new title from selection" },
			{ "zl", "<CMD>ZkLinks<CR>", desc = "zk: links" },
			{ "zt", "<CMD>ZkTags<CR>", desc = "zk: tags" },
			{
				"zdd",
				function()
					require("zk").new({ dir = "projects/journal/daily", group = "daily" })
				end,
				desc = "zk: new daily note",
			},
			{
				"zdw",
				function()
					require("zk").new({ dir = "projects/journal/weekly", group = "weekly" })
				end,
				desc = "zk: new weekly note",
			},
			{
				"zdm",
				function()
					require("zk").new({ dir = "projects/journal/monthly", group = "monthly" })
				end,
				desc = "zk: new monthly note",
			},
			{
				"zdt",
				function()
					require("zk").new({ dir = "projects/journal/daily", group = "tomorrow" })
				end,
				desc = "zk: new daily note for tomorrow",
			},
		},
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
		"kirasok/telescope-media-files.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			filetypes = { "png", "webp", "jpg", "jpeg", "pdf", "mp4", "mkv", "svg" },
		},
		config = function(_, opts)
			require("telescope").load_extension("media_files")
			require("telescope").setup({
				extensions = {
					media_files = opts,
				},
			})
		end,
	},

	{
		"HakonHarnes/img-clip.nvim",
		cmd = "PasteImage",
		dependencies = {
			"kirasok/telescope-media-files.nvim",
		},
		opts = {
			default = {
				dir_path = "static",
			},
		},
		keys = {
			-- suggested keymap
			{ "<leader>fp", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
			{
				"<leader>fP",
				function()
					local telescope = require("telescope")
					local actions = require("telescope.actions")
					local action_state = require("telescope.actions.state")

					-- telescope.extensions.media_files.media_files() -- TODO: doesn't work
					telescope.extensions.media_files.media_files({
						attach_mappings = function(_, map)
							local function embed_image(prompt_bufnr)
								local entry = action_state.get_selected_entry()
								local filepath = entry[1]
								actions.close(prompt_bufnr)

								local img_clip = require("img-clip")
								img_clip.paste_image(nil, filepath)
							end

							map("i", "<CR>", embed_image)
							map("n", "<CR>", embed_image)

							return true
						end,
					})
				end,
				desc = "Paste image from file",
			},
		},
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
	},

	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = true,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		enabled = false,
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
		"kevinhwang91/nvim-bqf",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		ft = "qf",
	},

	{
		"gbprod/yanky.nvim",
		event = "BufRead",
		opts = require("configs.yanky"),
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
	},

	{
		"RaafatTurki/hex.nvim",
		event = "BufRead",
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
		"akinsho/flutter-tools.nvim",
		ft = "dart",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
	},

	{
		"mcauley-penney/visual-whitespace.nvim",
		event = "ModeChanged",
		commit = "979aea2ab9c62508c086e4d91a5c821df54168a8",
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
	},

	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		event = "LspAttach",
		enabled = false,
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
	},

	{
		"roobert/surround-ui.nvim",
		enabled = false,
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
	{
		"fbuchlak/telescope-directory.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"zk-org/zk-nvim",
		},
		-- @type telescope-directory.ExtensionConfig
		opts = {
			features = {
				{
					name = "print_directory",
					callback = function(dirs)
						require("zk.commands").get("ZkNew")({ dir = dirs[1], title = vim.fn.input("Enter title: ") })
					end,
				},
			},
		},
		config = function(_, opts)
			require("telescope-directory").setup(opts)
		end,
		keys = {
			{
				"<Leader>fd",
				function()
					require("telescope-directory").directory({
						feature = "live_grep", -- "find_files"|"grep_string"|"live_grep"
					})
				end,
				desc = "Select directory for Live Grep",
			},
			{
				"<Leader>fe",
				"<CMD>Telescope directory find_files<CR>", -- "find_files"|"grep_string"|"live_grep"
				desc = "Select directory for Find Files",
			},
			{
				"zN",
				function()
					require("telescope-directory").directory({ feature = "print_directory" })
				end,
				desc = "zk: new note in folder",
			},
		},
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
				-- If enabled, use telescope for menu selection rather than vim.ui.select.
				-- Allows multi-select and some things that vim.ui.select doesn't.
				telescope = true,
				-- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
				-- The diffview integration enables the diff popup.
				--
				-- Requires you to have `sindrets/diffview.nvim` installed.
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
		keys = {
			{ "<leader>z", "<cmd>ZenMode<cr>", desc = "ZenMode" },
		},
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufEnter",
		opts = {
			fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" 󰁂 %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end,
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		},
		config = function(_, opts)
			vim.o.foldcolumn = "0" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			require("ufo").setup(opts)
		end,
	},
	{
		"quarto-dev/quarto-nvim",
		ft = "quarto",
		dependencies = {
			{
				"jmbuhr/otter.nvim",
				dependencies = {
					"hrsh7th/nvim-cmp",
					"neovim/nvim-lspconfig",
					"nvim-treesitter/nvim-treesitter",
				},
				config = function(_, opts)
					require("otter").setup(opts)
					local cmp = require("cmp")
					local config = cmp.get_config()
					table.insert(config.sources, {
						name = "otter",
					})
					cmp.setup(config)
				end,
			},
			{
				"benlubas/molten-nvim",
				version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
				dependencies = {
					{ "3rd/image.nvim" },
					{
						"GCBallesteros/jupytext.nvim",
						opts = { style = "quarto", output_extension = "qmd", force_ft = "quarto" },
					},
				},
				build = ":UpdateRemotePlugins",
				init = function()
					vim.g.molten_image_provider = "image.nvim"
				end,
			},
		},
		opts = {
			lspFeatures = {
				languages = { "python" },
				chunks = "all",
				diagnostics = {
					enabled = true,
					triggers = { "BufWritePost" },
				},
				completion = {
					enabled = true,
				},
			},
			keymap = false,
			codeRunner = {
				enabled = true,
				default_method = "molten",
				never_run = { "yaml" },
			},
		},
		config = function(_, opts)
			require("quarto").setup(opts)
			require("quarto").activate()
			local runner = require("quarto.runner")
			vim.keymap.set("n", "<leader>rc", runner.run_cell, { desc = "run cell" })
			vim.keymap.set("n", "<leader>ra", runner.run_above, { desc = "run cell and above" })
			vim.keymap.set("n", "<leader>rA", runner.run_all, { desc = "run all cells" })
			vim.keymap.set("n", "<leader>rl", runner.run_line, { desc = "run line" })
			vim.keymap.set("v", "<leader>r", runner.run_range, { desc = "run visual range" })
			vim.keymap.set("n", "<leader>RA", function()
				runner.run_all(true)
			end, { desc = "run all cells of all languages" })
		end,
	},
	{
		"chrisgrieser/nvim-spider",
		keys = {
			{
				"e",
				"<cmd>lua require('spider').motion('e')<CR>",
				mode = { "n", "o", "x" },
				desc = "Spider-e",
			},
			{
				"w",
				"<cmd>lua require('spider').motion('w')<CR>",
				mode = { "n", "o", "x" },
				desc = "Spider-w",
			},
			{
				"b",
				"<cmd>lua require('spider').motion('b')<CR>",
				mode = { "n", "o", "x" },
				desc = "Spider-b",
			},
		},
	},
	{
		"cxwx/specs.nvim",
		event = "BufEnter",
		commit = "dd82496",
		opts = {
			popup = {
				inc_ms = 16,
			},
		},
		config = true,
	},
	{
		"vhyrro/luarocks.nvim",
		priority = 1001, -- this plugin needs to run before anything else
		opts = {
			rocks = { "magick" },
		},
	},
	{
		"3rd/image.nvim",
		dependencies = { "luarocks.nvim" },
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
		"mikavilpas/yazi.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		keys = {
			{
				-- Open in the current working directory
				"<leader>e",
				function()
					require("yazi").yazi(nil, vim.fn.getcwd())
				end,
				desc = "Open the file manager",
			},
		},
		opts = {
			open_for_directories = false, -- WARN: doesn't open file on selection if starting from directory
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			label = { rainbow = { enable = true } },
		},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
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
}

return plugins
