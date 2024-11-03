---@type NvPluginSpec[]
local plugins = {

	{
		"kirasok/render-markdown.nvim",
		ft = "markdown",
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			render_modes = { "n", "c", "i" },
			sign = { enabled = false },
			latex = { enabled = false },
			indent = { enabled = true },
			heading = {
				backgrounds = {
					"",
					"",
					"",
					"",
					"",
					"",
				},
			},
			link = {
				hyperlink = "",
			},
		},
		config = function(_, opts)
			require("render-markdown").setup(opts)
			local base30 = require("base46").get_theme_tb("base_30")
			vim.api.nvim_set_hl(0, "@markup.heading.1", { fg = base30.red, bg = "", bold = true })
			vim.api.nvim_set_hl(0, "@markup.heading.2", { fg = base30.yellow, bg = "", bold = true })
			vim.api.nvim_set_hl(0, "@markup.heading.3", { fg = base30.cyan, bg = "", bold = true })
			vim.api.nvim_set_hl(0, "@markup.heading.4", { fg = base30.green, bg = "", bold = true })
			vim.api.nvim_set_hl(0, "@markup.heading.5", { fg = base30.blue, bg = "", bold = true })
			vim.api.nvim_set_hl(0, "@markup.heading.6", { fg = base30.purple, bg = "", bold = true })
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons", "zk-org/zk-nvim" },
	},

	{
		"SCJangra/table-nvim",
		ft = "markdown",
		opts = {
			padd_column_separators = true, -- Insert a space around column separators.
			mappings = { -- next and prev work in Normal and Insert mode. All other mappings work in Normal mode.
				next = "<A-TAB>", -- Go to next cell.
				prev = "<A-S-TAB>", -- Go to previous cell.
			},
		},
	},

	{
		-- manage zettelkasten
		"zk-org/zk-nvim",
		ft = "markdown",
		dependencies = {
			{
				"fbuchlak/telescope-directory.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"nvim-telescope/telescope.nvim",
				},
				-- @type telescope-directory.ExtensionConfig
				opts = {
					features = {
						{
							name = "print_directory",
							callback = function(dirs)
								require("zk.commands").get("ZkNew")({
									dir = dirs[1],
									title = vim.fn.input("Enter title: "),
								})
							end,
						},
					},
				},
				config = function(_, opts)
					require("telescope-directory").setup(opts)
				end,
				keys = require("mappings.telescope-directory-nvim"),
			},
		},
		opts = {
			picker = "telescope",
			lsp = {
				config = {
					on_attach = require("configs.lsp").on_attach,
				},
				auto_attach = {
					enabled = true,
					filetypes = { "markdown" },
				},
			},
		},
		config = function(_, opts)
			require("zk").setup(opts)
			vim.cmd([[set backupcopy=yes]])
		end,
		keys = require("mappings.zk-nvim"),
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
		"HakonHarnes/img-clip.nvim",
		cmd = "PasteImage",
		dependencies = {
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
		},
		opts = {
			default = {
				dir_path = "static",
			},
		},
		keys = require("mappings.img-clip-nvim"),
	},
}

return plugins
