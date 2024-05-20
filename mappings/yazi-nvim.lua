return {
	{
		-- Open in the current working directory
		"<leader>e",
		function()
			require("yazi").yazi()
		end,
		desc = "yazi open",
	},
}
