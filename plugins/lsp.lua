local nvchad_config = require("nvchad.configs.lspconfig")
local config = require("configs.lsp")
local mappings = require("mappings.lspconfig")

---@type NvPluginSpec[]
local plugins = {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mfussenegger/nvim-lint",
				config = function(_, opts)
					require("lint").linters_by_ft = config.linters

					vim.api.nvim_create_autocmd({ "BufWritePost" }, {
						callback = function()
							require("lint").try_lint()
						end,
					})
				end,
			},
			{
				"stevearc/conform.nvim",
				opts = config.confrom,
				config = true,
			},
		},
		event = "User FilePost",
		config = function()
			dofile(vim.g.base46_cache .. "lsp")
			local on_attach = config.on_attach
			local capabilities = nvchad_config.capabilities

			local lspconfig = require("lspconfig")

			for name, opts in pairs(config.servers) do
				opts.on_attach = on_attach
				opts.capabilities = capabilities
				opts.on_init = nvchad_config.on_init
				lspconfig[name].setup(opts)
			end
		end,
	},

	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		opts = config.lightbulb,
	},

	{
		"hedyhli/outline.nvim",
		event = "LspAttach",
		opts = config.outline,
		config = function(_, opts)
			require("outline").setup(opts)
			mappings.outline()
		end,
	},

	{
		"Wansmer/symbol-usage.nvim",
		event = "LspAttach",
		config = config.symbols,
	},

	{
		"jmbuhr/otter.nvim",
		dev = false,
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
	},

	{
		"aznhe21/actions-preview.nvim",
		event = "LspAttach",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = config.action_preview,
	},

	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000, -- needs to be loaded in first
		config = function()
			require("tiny-inline-diagnostic").setup(config.tiny_diagnostics)
			vim.diagnostic.config({ virtual_text = false })
		end,
	},
}

return plugins
