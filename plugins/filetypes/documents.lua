local configs = require("configs.filetype.documents")
local mappings = require("mappings.filetypes.documents")
---@type NvPluginSpec[]
local plugins = {

	{
		"kirasok/render-markdown.nvim",
		ft = "markdown",
		branch = "feat_wikilink_enable",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
			"zk-org/zk-nvim",
			"jbyuki/nabla.nvim",
			"3rd/image.nvim",
		},
		config = function(_, opts)
			require("render-markdown").setup(configs.render_markdown())
		end,
	},

	{
		"SCJangra/table-nvim",
		ft = "markdown",
		opts = configs.table_nvim,
	},

	{
		"kirasok/html-table-to-markdown.nvim",
		ft = "markdown",
		config = true,
	},

	{
		-- manage zettelkasten
		"zk-org/zk-nvim",
		ft = "markdown",
		dependencies = {
			{ "fbuchlak/telescope-directory.nvim" },
		},
		opts = configs.zk_nvim,
		config = function(_, opts)
			require("zk").setup(opts)
			vim.cmd([[set backupcopy=yes]])
		end,
		keys = mappings.zk_nvim,
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
		enabled = false,
		dependencies = { "L3MON4D3/LuaSnip", "nvim-treesitter/nvim-treesitter" },
		opts = configs.latex_snippets,
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
			{ "kirasok/telescope-media-files.nvim" },
		},
		opts = configs.img_clip,
		keys = mappings.img_clip,
	},

	{
		"quarto-dev/quarto-nvim",
		ft = { "quarto" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"3rd/image.nvim",
			"jmbuhr/otter.nvim",
			{ -- directly open ipynb files as quarto docuements
				-- and convert back behind the scenes
				"GCBallesteros/jupytext.nvim",
				opts = {
					custom_language_formatting = {
						python = {
							extension = "qmd",
							style = "quarto",
							force_ft = "quarto",
						},
						r = {
							extension = "qmd",
							style = "quarto",
							force_ft = "quarto",
						},
					},
				},
			},
			{
				"benlubas/molten-nvim",
				build = ":UpdateRemotePlugins",
				init = function()
					vim.g.molten_image_provider = "image.nvim"
					vim.g.molten_output_win_max_height = 20
					vim.g.molten_auto_open_output = false
				end,
				keys = {
					{ "<leader>mi", ":MoltenInit<cr>", desc = "[m]olten [i]nit" },
					{
						"<leader>mv",
						":<C-u>MoltenEvaluateVisual<cr>",
						mode = "v",
						desc = "molten eval visual",
					},
					{ "<leader>mr", ":MoltenReevaluateCell<cr>", desc = "molten re-eval cell" },
				},
			},
		},
	},
}

return plugins
