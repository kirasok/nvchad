local M = {}

---@type LazyKeymaps[]
M.hex = {
	{
		"<leader>h",
		function()
			require("hex").toggle()
		end,
		mode = "n",
		desc = "Toggle Hex",
	},
}

return M
