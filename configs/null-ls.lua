local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local sources = {
	formatting.stylua,
	formatting.taplo,
	formatting.yamlfmt,
	formatting.ruff,
	formatting.shfmt.with({ extra_filetypes = { "zsh" } }),
	formatting.deno_fmt.with({ extra_args = { "--line-width", "9999" } }),
	formatting.stylish_haskell,
	lint.deno_lint,
	lint.zsh,
	lint.actionlint,
	lint.ruff,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	debug = true,
	sources = sources,
	-- you can reuse a shared lspconfig on_attach callback here
	on_attach = function(client, bufnr)
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
	end,
})
