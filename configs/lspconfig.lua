local nvchad_on_attach = require("plugins.configs.lspconfig").on_attach
local nvchad_capabilities = require("plugins.configs.lspconfig").capabilities

local on_attach = function(client, bufnr)
	nvchad_on_attach(client, bufnr)
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
local capabilities = nvchad_capabilities

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = { "rust_analyzer", "bashls", "taplo", "yamlls", "jedi_language_server", "hls", "clangd" }

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
			chktex = {
				onOpenAndSave = true,
			},
			formatterLineLength = 0,
		},
	},
})
