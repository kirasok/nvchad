return {
	{
		"fF",
		vim.diagnostic.open_float,
		mode = "n",
		desc = "Lsp floating diagnostics",
	},
	{
		"fD",
		function()
			vim.lsp.buf.declaration()
		end,
		mode = "n",
		desc = "LSP declaration",
	},
	{
		"fd",
		function()
			vim.lsp.buf.definition()
		end,
		mode = "n",
		desc = "LSP definition",
	},
	{
		"fk",
		function()
			vim.lsp.buf.hover()
		end,
		mode = "n",
		desc = "LSP hover",
	},
	{
		"fi",
		function()
			vim.lsp.buf.implementation()
		end,
		mode = "n",
		desc = "LSP implementation",
	},
	{
		"fs",
		function()
			vim.lsp.buf.signature_help()
		end,
		mode = "n",
		desc = "LSP signature help",
	},
	{
		"ft",
		function()
			vim.lsp.buf.type_definition()
		end,
		mode = "n",
		desc = "LSP definition type",
	},
	{
		"fa",
		function()
			vim.lsp.buf.code_action()
		end,
		mode = "n",
		desc = "LSP code action",
	},
	{
		"fR",
		function()
			vim.lsp.buf.references()
		end,
		mode = "n",
		desc = "LSP references",
	},
}
