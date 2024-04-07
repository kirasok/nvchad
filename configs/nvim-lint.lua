require("lint").linters_by_ft = {
	javascript = { "deno" },
	javascriptreact = { "deno" },
	typescript = { "deno" },
	typescriptreact = { "deno" },
	zsh = { "zsh" },
	yaml = { "actionlint" },
	json = { "jsonlint" },
	python = { "pylint", "pydocstyle", "pycodestyle" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
