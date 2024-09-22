---@type NvPluginSpec[]
local plugins = {

	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		opts = {
			render_modes = { "n", "c", "i" },
			sign = { enabled = false },
			latex = { enabled = false },
			indent = { enabled = true },
		},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
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
			auto_attach = {
				enabled = true,
				filetypes = { "markdown" },
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

	{
		"hrsh7th/cmp-emoji",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
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
		"lukas-reineke/headlines.nvim",
		ft = { "markdown", "org", "norg" },
		enabled = false,
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
			{ "folke/which-key.nvim" },
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
			require("which-key").register({ ["<leader>"] = {
				r = {
					name = "runner",
				},
			} })
			local runner = require("quarto.runner")
			vim.keymap.set("n", "<leader>rc", runner.run_cell, { desc = "run cell" })
			vim.keymap.set("n", "<leader>ra", runner.run_above, { desc = "run cell and above" })
			vim.keymap.set("n", "<leader>rA", runner.run_all, { desc = "run all cells" })
			vim.keymap.set("n", "<leader>rl", runner.run_line, { desc = "run line" })
			vim.keymap.set("v", "<leader>r", runner.run_range, { desc = "run visual range" })
		end,
	},
}

return plugins
