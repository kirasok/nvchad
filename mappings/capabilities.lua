local M = {}

---@type LazyKeymaps[]
M.undotree = { -- load the plugin only when using it's keybinding:
	{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "undotree toggle" },
}

---@type LazyKeymaps[]
M.zen = {
	{ "<leader>z", "<cmd>ZenMode<cr>", desc = "zenmode toggle" },
}

return M
