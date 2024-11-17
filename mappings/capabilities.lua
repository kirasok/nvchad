local M = {}

---@type LazyKeymaps[]
M.undotree = { { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "undotree toggle" } }

---@type LazyKeymaps[]
M.zen = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "zenmode toggle" } }

---@type LazyKeymaps[]
M.gx = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } }

---@type LazyKeymaps[]
M.neogen = {
	{ "<leader>aa", ":Neogen<CR>", desc = "closest" },
	{ "<leader>ac", ":Neogen class<CR>", desc = "class" },
	{ "<leader>am", ":Neogen func<CR>", desc = "method" },
	{ "<leader>af", ":Neogen file<CR>", desc = "file" },
}

return M
