---@type NvPluginSpec[]

local linters = {
	javascript = { "deno" },
	javascriptreact = { "deno" },
	typescript = { "deno" },
	typescriptreact = { "deno" },
	zsh = { "zsh" },
	json = { "jsonlint" },
	python = { "pylint", "pydocstyle", "pycodestyle" },
}

local formatters = {
	lua = { "stylua" },
	toml = { "taplo" },
	yaml = { "yamlfmt" },
	sh = { "shfmt" },
	zsh = { "shfmt" },
	nix = { "nixfmt" },
	markdown = { "prettierd", "prettier", stop_after_first = true },
	-- Conform will run multiple formatters sequentially
	python = { "isort", "black" },
	-- Use a sub-list to run only the first available formatter
	javascript = { "prettierd", "prettier", stop_after_first = true },
}

-- if you just want default config for the servers then put them in a table
-- otherwise look into lspconfig setup
local servers = {
	"rust_analyzer",
	"bashls",
	"taplo",
	"yamlls",
	"jedi_language_server",
	"hls",
	"clangd",
	"html",
	"jsonls",
	"cssls",
	"ts_ls",
	"nil_ls",
}

local plugins = {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mfussenegger/nvim-lint",
				config = function(_, opts)
					require("lint").linters_by_ft = linters

					vim.api.nvim_create_autocmd({ "BufWritePost" }, {
						callback = function()
							require("lint").try_lint()
						end,
					})
				end,
			},
			{
				"stevearc/conform.nvim",
				opts = {
					formatters_by_ft = formatters,
					format_on_save = {
						-- These options will be passed to conform.format()
						timeout_ms = 500,
						lsp_fallback = true,
					},
				},
				keys = require("mappings.conform-nvim"),
				config = true,
			},
		},
		keys = require("mappings.lspconfig"),
		config = function()
			require("nvchad.configs.lspconfig")
			local on_attach = function(client, bufnr)
				-- nvchad_on_attach(client, bufnr) -- don't use, it just setups useless keymaps
				client.server_capabilities.documentFormattingProvider = true
				client.server_capabilities.documentRangeFormattingProvider = true
				local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end
			local capabilities = require("nvchad.configs.lspconfig").capabilities

			local lspconfig = require("lspconfig")

			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end

			lspconfig.gopls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					gopls = {
						gofumpt = true,
					},
				},
			})

			lspconfig.texlab.setup({
				settings = {
					texlab = {
						build = {
							executable = "latexmk",
							args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
							onSave = true,
							forwardSearchAfter = true,
						},
						forwardSearch = {
							executable = "zathura",
							args = { "--synctex-forward", "%l:1:%f", "%p" },
						},
						chktex = {
							onOpenAndSave = true,
						},
						formatterLineLength = 0,
					},
				},
			})

			lspconfig.lua_ls.setup({
				settings = {
					format = {
						enable = false,
					},
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		config = function(_, opts)
			-- highlight luasnip nodes
			local types = require("luasnip.util.types")
			require("luasnip").config.setup({
				ext_opts = {
					[types.choiceNode] = {
						active = {
							virt_text = { { "●", "GruvboxOrange" } },
						},
					},
					[types.insertNode] = {
						active = {
							virt_text = { { "●", "GruvboxBlue" } },
						},
					},
				},
			})
			require("nvchad.configs.luasnip")
		end,
	},

	{
		-- Print function signature in popup window
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
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
		keys = require("mappings.outline-nvim"),
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
		event = "LspAttach",
	},
}

return plugins
