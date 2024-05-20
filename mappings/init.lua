require("nvchad.mappings")

local map = vim.keymap.set
local nomap = vim.keymap.del

map("i", "<C-l>", "<Esc>[s1z=`]a", { desc = "Fix spell" })
map("n", ";", ":", { desc = "CMD enter command mode" })

-- lspconfig
nomap("n", "<leader>fm")
nomap("n", "<leader>ds")

-- telescope
nomap("n", "<leader>cm")
nomap("n", "<leader>gt")
nomap("n", "<leader>pt")
nomap("n", "<leader>th")

nomap("n", "<leader>cc")
nomap("n", "<leader>rn")
nomap("n", "<leader>wk")
nomap("n", "<leader>wK")
nomap("n", "<leader>ch")
nomap("n", "<leader>ma")
