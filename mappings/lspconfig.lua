local map = vim.keymap.set
local opts = function(desc)
	return { desc = "LSP " .. desc }
end

return {
	setup = function(server_capabilities)
		map("n", "<leader>lf", function()
			require("conform").format({ async = true, lsp_fallback = true }, nil)
		end, opts("Format"))
		map("n", "<leader>lF", vim.diagnostic.open_float, opts("Floating diagnostics"))

		vim.notify(table.concat(server_capabilities, "\n"), "trace", {
			on_open = function(win)
				local buf = vim.api.nvim_win_get_buf(win)
				vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
			end,
			timeout = 14000,
		})
		if server_capabilities.declarationProvider then
			map("n", "<leader>fD", vim.lsp.buf.declaration, opts("Declaration"))
		end
		if server_capabilities.declarationProvider then
			map("n", "<leader>ld", vim.lsp.buf.definition, opts("Definition"))
		end
		if server_capabilities.hoverProvider then
			map("n", "<leader>lk", vim.lsp.buf.hover, opts("Hover"))
		end
		if server_capabilities.implementationProvider then
			map("n", "<leader>li", vim.lsp.buf.implementation, opts("Implementation"))
		end
		if server_capabilities.signatureHelpProvider then
			map("n", "<leader>ls", vim.lsp.buf.signature_help, opts("Signature help"))
		end
		if server_capabilities.typeDefinitionProvider then
			map("n", "<leader>lt", vim.lsp.buf.type_definition, opts("Type definition"))
		end
		if server_capabilities.referencesProvider then
			map("n", "<leader>lR", vim.lsp.buf.references, opts("References"))
		end
		if server_capabilities.renameProvider then
			map("n", "<leader>lr", require("nvchad.lsp.renamer"), opts("Rename"))
		end
		if server_capabilities.codeActionProvider then
			vim.keymap.set({ "v", "n" }, "<leader>la", require("actions-preview").code_actions, opts("Code actions"))
		end
	end,
}
