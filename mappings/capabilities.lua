local M = {}

---@type LazyKeymaps[]
M.undotree = { { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "undotree toggle" } }

---@type LazyKeymaps[]
M.zen = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "zenmode toggle" } }

---@type LazyKeymaps[]
M.gx = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } }

return M
