local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local sources = {
	formatting.stylua,
	formatting.taplo,
	formatting.yamlfmt,
	formatting.shfmt.with({ extra_filetypes = { "zsh" } }),
	formatting.deno_fmt.with({ extra_args = { "--line-width", "9999" } }),
	lint.deno_lint,
	lint.zsh,
	lint.actionlint,
}

null_ls.setup({
	sources = sources,
})
