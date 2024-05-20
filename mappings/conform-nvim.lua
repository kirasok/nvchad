return {
	{
		"ff",
		function()
			require("conform").format({ async = true, lsp_fallback = true }, nil)
		end,
		mode = "n",
		desc = "LSP formatting",
	},
}
