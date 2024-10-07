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
			dofile(vim.g.base46_cache .. "lsp")
			local on_attach = function(client, bufnr)
				-- nvchad_on_attach(client, bufnr) -- don't use, it just setups useless keymaps
				client.server_capabilities.documentFormattingProvider = true
				client.server_capabilities.documentRangeFormattingProvider = true
				if client.supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
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
				on_attach = on_attach,
				capabilities = capabilities,
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
				on_attach = on_attach,
				capabilities = capabilities,

				settings = {
					format = {
						enable = false,
					},
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						completion = {
							callSnippet = "Replace",
						},
						workspace = {
							library = {
								vim.fn.expand("$VIMRUNTIME/lua"),
								vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
								vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
								vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
								"${3rd}/luv/library",
							},
							maxPreload = 100000,
							preloadFileSize = 10000,
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
		"utilyre/sentiment.nvim",
		version = "*",
		event = "VeryLazy", -- keep for lazy loading
		config = true,
		init = function()
			-- `matchparen.vim` needs to be disabled manually in case of lazy loading
			vim.g.loaded_matchparen = 1
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
					Object = { icon = " ", hl = "Type" },
					Key = { icon = " ", hl = "Type" },
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
		config = function(_, _)
			local function h(name)
				return vim.api.nvim_get_hl(0, { name = name })
			end

			-- hl-groups can have any name
			vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("Visual").bg, italic = true })
			vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("Visual").bg, fg = h("Visual").fg, italic = true })
			vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("@function").fg, bg = h("Visual").bg, italic = true })
			vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("@type").fg, bg = h("Visual").bg, italic = true })
			vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("Visual").bg, italic = true })

			local function text_format(symbol)
				local res = {}

				local round_start = { "", "SymbolUsageRounding" }
				local round_end = { "", "SymbolUsageRounding" }

				-- Indicator that shows if there are any other symbols in the same line
				local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count)
					or ""

				if symbol.references then
					local usage = symbol.references <= 1 and "usage" or "usages"
					local num = symbol.references == 0 and "no" or symbol.references
					table.insert(res, round_start)
					table.insert(res, { "󰌹 ", "SymbolUsageRef" })
					table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
					table.insert(res, round_end)
				end

				if symbol.definition then
					if #res > 0 then
						table.insert(res, { " ", "NonText" })
					end
					table.insert(res, round_start)
					table.insert(res, { "󰳽 ", "SymbolUsageDef" })
					table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
					table.insert(res, round_end)
				end

				if symbol.implementation then
					if #res > 0 then
						table.insert(res, { " ", "NonText" })
					end
					table.insert(res, round_start)
					table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
					table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
					table.insert(res, round_end)
				end

				if stacked_functions_content ~= "" then
					if #res > 0 then
						table.insert(res, { " ", "NonText" })
					end
					table.insert(res, round_start)
					table.insert(res, { " ", "SymbolUsageImpl" })
					table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
					table.insert(res, round_end)
				end

				return res
			end

			require("symbol-usage").setup({
				text_format = text_format,
			})
		end,
	},

	{
		"aznhe21/actions-preview.nvim",
		event = "LspAttach",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function(_, _)
			require("actions-preview").setup({
				highlight_command = {
					require("actions-preview.highlight").delta(),
				},
				backend = { "telescope" },
				telescope = {
					sorting_strategy = "ascending",
					layout_strategy = "vertical",
					layout_config = {
						width = 0.8,
						height = 0.9,
						prompt_position = "top",
						preview_cutoff = 20,
						preview_height = function(_, _, max_lines)
							return max_lines - 15
						end,
					},
				},
			})
			vim.keymap.set({ "v", "n" }, "fa", require("actions-preview").code_actions, { desc = "LSP code actions" })
		end,
	},
}

return plugins
