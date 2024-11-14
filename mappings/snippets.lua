local M = {}

require("which-key").add({
	{ "<leader>s", group = "snippet" },
})

---@type LazyKeymaps[]
M.scissors = {
	{
		"<leader>sa",
		function()
			require("scissors").addNewSnippet()
		end,
		desc = "Add snippet",
		mode = { "n", "v" },
	},
	{
		"<leader>se",
		function()
			require("scissors").editSnippet()
		end,
		desc = "Edit snippet",
		mode = "n",
	},
}

return M
