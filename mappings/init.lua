require("nvchad.mappings")

local map = vim.keymap.set
local nomap = vim.keymap.del

map("i", "<C-l>", "<Esc>[s1z=`]a", { desc = "spell fix last mistake" })
map("n", ";", ":", { desc = "CMD enter command mode" })

-- lspconfig
nomap("n", "<leader>fm")
nomap("n", "<leader>ds")
map("n", "<leader>ca", "<ESC>") -- code action
nomap("n", "<leader>ca") -- code action
map("n", "<leader>ra", "<ESC>") -- NvRenamer
nomap("n", "<leader>ra") -- NvRenamer
map("n", "<leader>sh", "<ESC>") -- show signature help
nomap("n", "<leader>sh") -- show signature help
map("n", "<leader>wa", "<ESC>") -- add workspace
nomap("n", "<leader>wa") -- add workspace
map("n", "<leader>wr", "<ESC>") -- remove workspace
nomap("n", "<leader>wr") -- remove workspace
map("n", "<leader>wl", "<ESC>") -- list workspaces
nomap("n", "<leader>wl") -- list workspaces

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
nomap("n", "<C-n>")
nomap("n", "<leader>n")
