local map = vim.keymap.set
local opts = function(desc)
	return { desc = "LSP " .. desc }
end

local open = function(mode)
	local trouble = require("trouble")
	return function()
		trouble.toggle({ mode = mode, focus = true })
	end
end

require("which-key").add({
	{ "<leader>l", group = "lsp" },
})

return {
	setup = function(server_capabilities)
		map("n", "<leader>lf", function()
			require("conform").format({ async = true, lsp_fallback = true }, nil)
		end, opts("Format"))
		map("n", "<leader>lF", vim.diagnostic.open_float, opts("Floating diagnostics"))

		if server_capabilities.declarationProvider then
			map("n", "<leader>fD", open("lsp_declarations"), opts("Declaration"))
		end
		if server_capabilities.definitionProvider then
			map("n", "<leader>ld", open("lsp_definitions"), opts("Definition"))
		end
		if server_capabilities.hoverProvider then
			map("n", "<leader>lk", vim.lsp.buf.hover, opts("Hover"))
		end
		if server_capabilities.implementationProvider then
			map("n", "<leader>li", open("lsp_implementations"), opts("Implementation"))
		end
		if server_capabilities.signatureHelpProvider then
			map("n", "<leader>ls", vim.lsp.buf.signature_help, opts("Signature help"))
		end
		if server_capabilities.typeDefinitionProvider then
			map("n", "<leader>lt", open("lsp_type_definitions"), opts("Type definition"))
		end
		if server_capabilities.referencesProvider then
			map("n", "<leader>lR", open("lsp_references"), opts("References"))
		end
		if server_capabilities.renameProvider then
			map("n", "<leader>lr", require("nvchad.lsp.renamer"), opts("Rename"))
		end
		if server_capabilities.codeActionProvider then
			vim.keymap.set({ "v", "n" }, "<leader>la", require("actions-preview").code_actions, opts("Code actions"))
		end
	end,

	outline = function()
		map("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle outline" })
	end,
}
