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
			}, { prefix = "<leader>" })
		end,
	},

	{
		"hrsh7th/cmp-buffer",
		enabled = false,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"bibtex",
				"c",
				"cmake",
				"cooklang",
				"cpp",
				"css",
				"dart",
				"dockerfile",
				"git_config",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"go",
				"gomod",
				"haskell",
				"html",
				"http",
				"ini",
				"java",
				"javascript",
				"jq",
				"jsdoc",
				"json",
				"json5",
				"jsonc",
				"kotlin",
				"latex",
				"ledger",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"mermaid",
				"nix",
				"norg",
				"python",
				"query",
				"rasi",
				"regex",
				"rust",
				"sql",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("custom.configs.null-ls")
			end,
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		config = function(_, opts)
			require("plugins.configs.others").luasnip(opts)
			require("custom.configs.luasnip")
		end,
	},

	{
		-- manage zettelkasten
		"mickael-menu/zk-nvim",
		init = function()
			require("core.utils").load_mappings("zk")
		end,
		ft = "markdown",
		config = function()
			require("zk").setup({
				picker = "telescope",
				auto_attach = {
					enabled = true,
					filetypes = { "markdown" },
				},
			})
			vim.cmd([[set backupcopy=yes]])
		end,
	},

	{
		"NvChad/nvim-colorizer.lua",
		ft = { "javascript", "css", "toml", "yaml" },
		config = function(_, opts)
			require("colorizer").setup({
				user_default_options = {
					RGB = true, -- #RGB hex codes
					RRGGBB = true, -- #RRGGBB hex codes
					names = true, -- "Name" codes like Blue or blue
					RRGGBBAA = true, -- #RRGGBBAA hex codes
					AARRGGBB = true, -- 0xAARRGGBB hex codes
					rgb_fn = true, -- CSS rgb() and rgba() functions
					hsl_fn = true, -- CSS hsl() and hsla() functions
					css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
					css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
					-- Available modes for `mode`: foreground, background,  virtualtext
					mode = "background", -- Set the display mode.
					-- Available methods are false / true / "normal" / "lsp" / "both"
					-- True is same as normal
					tailwind = true, -- Enable tailwind colors
				},
			})

			-- execute colorizer as soon as possible
			vim.defer_fn(function()
				require("colorizer").attach_to_buffer(0)
			end, 0)
		end,
	},

	{
		-- open fields in the last place you left
		"ethanholz/nvim-lastplace",
		event = "BufRead",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = {
					"gitcommit",
					"gitrebase",
					"svn",
					"hgcommit",
				},
				lastplace_open_folds = true,
			})
		end,
	},

	{
		-- live js server
		"turbio/bracey.vim",
		ft = { "javascript", "typescript", "html", "css" },
		cmd = { "Bracey", "BracyStop", "BraceyReload", "BraceyEval" },
		build = "npm install --prefix server",
	},

	{
		-- autoclose and autorename html tags
		"windwp/nvim-ts-autotag",
		ft = "html",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
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
		-- removes all unnecessary views and centers text
		"folke/zen-mode.nvim",
		cmd = { "ZenMode" },
		config = function()
			require("zen-mode").setup({})
		end,
	},

	{
		-- configs texlab to sync cursor position with zathura BUG: not working
		"f3fora/nvim-texlabconfig",
		ft = { "tex", "bib" },
		config = function()
			require("texlabconfig").setup()
			local lspconfig = require("lspconfig")
			local executable = "zathura"
			local args = {
				"--synctex-editor-command",
				[[nvim-texlabconfig -file '%{input}' -line %{line}]],
				"--synctex-forward",
				"%l:1:%f",
				"%p",
			}

			lspconfig.texlab.setup({
				settings = {
					texlab = {
						build = {
							executable = "latexmk",
							args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
							onSave = true,
							forwardSearchAfter = true,
						},
						chktex = {
							onOpenAndSave = true,
						},
						forwardSearch = {
							executable = executable,
							args = args,
						},
						formatterLineLength = 0,
					},
				},
			})
		end,
		build = "go build -o ~/.local/bin/",
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
		-- preview markdown
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		ft = { "markdown" },
		cmd = { "MarkdownPreview" },
		init = function()
			vim.g.mkdp_filetypes = {
				"markdown",
			}
		end,
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
		config = function()
			require("clipboard-image").setup({
				default = {
					img_dir = { "%:p:h", "static" }, -- Relative to current file
				},
				markdown = {
					img_dir = { "%:p:h", "static" },
					img_dir_txt = "static",
					affix = "![clipboard_img](%s)",
				},
			})
		end,
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
		"dhruvasagar/vim-table-mode",
		init = function()
			require("core.utils").load_mappings("vimtablemode")
		end,
		ft = { "markdown" },
		config = function()
			vim.g.table_mode_corner = "|"
			vim.g.table_mode_disable_mappings = 1
			vim.g.table_mode_disable_tableize_mappings = 1
			vim.cmd("TableModeToggle")
		end,
	},

	{
		"pwntester/octo.nvim",
		init = function()
			require("core.utils").load_mappings("octo")
		end,
		cmd = "Octo",
		config = function(_, opts)
			require("octo").setup(opts)
		end,
	},

	{
		"elkowar/yuck.vim",
		ft = "yuck",
	},

	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		event = "LspAttach",
		config = function()
			require("lsp_lines").setup()
			-- Disable virtual_text since it's redundant due to lsp_lines.
			vim.diagnostic.config({
				virtual_text = false,
			})
		end,
	},

	{
		"debugloop/telescope-undo.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		init = function(_)
			require("core.utils").load_mappings("undotree")
		end,
		cmd = "Telescope",
		config = function()
			require("telescope").load_extension("undo")
		end,
	},
}

return plugins
