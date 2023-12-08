local M = {
	formatters_by_ft = {
		lua = { "stylua" },
		toml = { "taplo" },
		yaml = { "yamlfmt" },
		sh = { "shfmt" },
		zsh = { "shfmt" },
		markdown = { {"prettierd", "prettier"} },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- Use a sub-list to run only the first available formatter
		javascript = { { "prettierd", "prettier" } },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

return M
