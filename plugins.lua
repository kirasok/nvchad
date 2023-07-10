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
		"nvim-treesitter/nvim-treesitter",
		opts = require("custom.configs.nvim-treesitter"),
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
		opts = require("custom.configs.zk-nvim"),
		config = function(_, opts)
			require("zk").setup(opts)
			vim.cmd([[set backupcopy=yes]])
		end,
	},

	{
		"NvChad/nvim-colorizer.lua",
		ft = { "javascript", "css", "toml", "yaml", "scss" },
		opts = require("custom.configs.nvim-colorizer"),
		config = function(_, opts)
			require("colorizer").setup(opts)
			-- execute colorizer as soon as possible
			vim.defer_fn(function()
				require("colorizer").attach_to_buffer(0)
			end, 0)
		end,
	},

	{
		-- open fields in the last place you left
		"ethanholz/nvim-lastplace",
		lazy = false,
		opts = require("custom.configs.nvim-lastplace"),
		config = true,
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
		-- removes all unnecessary views and centers text
		"folke/zen-mode.nvim",
		cmd = { "ZenMode" },
		config = true,
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
		opts = require("custom.configs.clipboard-image"),
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
		config = true,
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
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		cmd = "Neogen",
		init = function(_)
			require("core.utils").load_mappings("neogen")
		end,
		opts = require("custom.configs.neogen"),
		config = true,
	},

	{
		"olimorris/persisted.nvim",
		enabled = false,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		lazy = false,
		init = function(_)
			require("core.utils").load_mappings("persisted")
		end,
		opts = require("custom.configs.persisted"),
		config = function(_, opts)
			require("persisted").setup(opts)
			require("telescope").load_extension("persisted")
			vim.api.nvim_create_autocmd({ "VimEnter" }, {
				callback = function()
					require("persisted").load()
				end,
			})
		end,
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
		config = true,
	},

	{
		"GnikDroy/projections.nvim",
		enabled = false,
		lazy = false,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		init = function()
			require("core.utils").load_mappings("projections")
		end,
		opts = require("custom.configs.projections"),
		config = function(_, opts)
			require("projections").setup(opts)
			require("telescope").load_extension("projections")

			local Session = require("projections.session")
			-- Autostore session on VimExit
			vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
				callback = function()
					Session.store(vim.loop.cwd())
				end,
			})
			-- Switch to project if vim was started in a project dir
			local switcher = require("projections.switcher")
			vim.api.nvim_create_autocmd({ "VimEnter" }, {
				callback = function()
					if vim.fn.argc() == 0 then
						switcher.switch(vim.loop.cwd())
					end
				end,
			})

			vim.opt.sessionoptions:append("localoptions")
		end,
	},
}

return plugins
