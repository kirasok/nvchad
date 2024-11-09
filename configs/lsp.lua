M = {}

M.linters = {
	javascript = { "deno" },
	javascriptreact = { "deno" },
	typescript = { "deno" },
	typescriptreact = { "deno" },
	zsh = { "zsh" },
	json = { "jsonlint" },
}

M.formatters = {
	lua = { "stylua" },
	toml = { "taplo" },
	yaml = { "yamlfmt" },
	sh = { "shfmt" },
	zsh = { "shfmt" },
	nix = { "nixfmt" },
	markdown = { "prettierd", "prettier", stop_after_first = true },
	-- Use a sub-list to run only the first available formatter
	javascript = { "prettierd", "prettier", stop_after_first = true },
}

-- if you just want default config for the servers then put them in a table
-- otherwise look into lspconfig setup
M.servers = {
	"rust_analyzer",
	"bashls",
	"taplo",
	"yamlls",
	"hls",
	"clangd",
	"html",
	"jsonls",
	"cssls",
	"ts_ls",
	"nil_ls",
	"lemminx",
	"pylsp",
}

vim.api.nvim_create_user_command("LspCapabilities", function()
	local curBuf = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_active_clients({ bufnr = curBuf })
	for _, client in pairs(clients) do
		if client.name ~= "null-ls" then
			local capAsList = {}
			for key, value in pairs(client.server_capabilities) do
				if value then
					table.insert(capAsList, "- " .. key)
				end
			end

			table.sort(capAsList) -- sorts alphabetically
			local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
			vim.notify(msg, "trace", {
				on_open = function(win)
					local buf = vim.api.nvim_win_get_buf(win)
					vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
				end,
				timeout = 14000,
			})
		end
	end
end, {})

M.on_attach = function(client, bufnr)
	-- nvchad_on_attach(client, bufnr) -- don't use, it just setups useless keymaps
	require("mappings.lspconfig").setup(client.server_capabilities)
	client.server_capabilities.documentFormattingProvider = true
	client.server_capabilities.documentRangeFormattingProvider = true
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

return M
