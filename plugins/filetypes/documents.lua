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
}

return plugins