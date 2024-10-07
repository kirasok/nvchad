return {
	-- TODO: set only keymaps that lsp supports
	{
		"fF",
		vim.diagnostic.open_float,
		mode = "n",
		desc = "LSP floating diagnostics",
	},
	{
		"fD",
		vim.lsp.buf.declaration,
		mode = "n",
		desc = "LSP declaration",
	},
	{
		"fd",
		vim.lsp.buf.definition,
		mode = "n",
		desc = "LSP definition",
	},
	{
		"fk",
		vim.lsp.buf.hover,
		mode = "n",
		desc = "LSP hover",
	},
	{
		"fi",
		vim.lsp.buf.implementation,
		mode = "n",
		desc = "LSP implementation",
	},
	{
		"fs",
		vim.lsp.buf.signature_help,
		mode = "n",
		desc = "LSP signature help",
	},
	{
		"ft",
		vim.lsp.buf.type_definition,
		mode = "n",
		desc = "LSP definition type",
	},
	{
		"fR",
		vim.lsp.buf.references,
		mode = "n",
		desc = "LSP references",
	},
	{
		"fr",
		require("nvchad.lsp.renamer"),
		mode = "n",
		desc = "LSP rename",
	},
}
