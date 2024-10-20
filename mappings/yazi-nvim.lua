return {
	{
		-- Open in the current working directory
		"<leader>e",
		function()
			require("yazi").yazi()
		end,
		desc = "yazi open",
	},
	{
		-- Open in the current working directory
		"<leader>E",
		function()
			require("yazi").yazi(nil, vim.fn.getcwd())
		end,
		desc = "yazi cwd",
	},
}
