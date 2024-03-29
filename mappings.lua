require("nvchad.mappings")

local map = vim.keymap.set
local nomap = vim.keymap.del

map("i", "<C-l>", "<Esc>[s1z=`]a", { desc = "Fix spell" })
map("n", ";", ":", { desc = "CMD enter command mode" })

-- lspconfig
nomap("n", "<leader>fm")
map("n", "ff", function()
	require("conform").format({ async = true, lsp_fallback = true }, nil)
end, { desc = "conform formatting" })
nomap("n", "<leader>lf")
map("n", "fF", vim.diagnostic.open_float, { desc = "Lsp floating diagnostics" })
map("n", "fD", function()
	vim.lsp.buf.declaration()
end, { desc = "LSP declaration" })
map("n", "fd", function()
	vim.lsp.buf.definition()
end, { desc = "LSP definition" })
map("n", "fk", function()
	vim.lsp.buf.hover()
end, { desc = "LSP hover" })
map("n", "fi", function()
	vim.lsp.buf.implementation()
end, { desc = "LSP implementation" })
map("n", "fs", function()
	vim.lsp.buf.signature_help()
end, { desc = "LSP signature help" })
map("n", "ft", function()
	vim.lsp.buf.type_definition()
end, { desc = "LSP definition type" })
map("n", "fr", ":IncRename <C-R><C-W>", { desc = "LSP rename" })
map("n", "fa", function()
	vim.lsp.buf.code_action()
end, { desc = "LSP code action" })
map("n", "fR", function()
	vim.lsp.buf.references()
end, { desc = "LSP references" })

-- nvimtree
map("n", "<leader>e", "<cmd> NvimTreeFocus <CR>", { desc = "Focus NvimTree" })
map("n", "<C-n>", "<cmd> NvimTreeFindFileToggle <CR>", { desc = "Toggle NvimTree" })

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

-- more keybinds!

-- zk
map("n", "zz", function()
	require("zk").edit({ sort = { "modified" } })
end, { desc = "zk: open note" })
map("n", "zn", function()
	require("zk").new({ title = vim.fn.input("title: "), dir = "notsorted" })
end, { desc = "zk: new note" })
map("n", "zp", function()
	require("zk").new({ title = vim.fn.input("title: "), dir = "projects" })
end, { desc = "zk: new project" })
map("n", "zb", "<CMD>ZkBacklinks<CR>", { desc = "zk: backlinks" })
map("n", "zl", "<CMD>ZkLinks<CR>", { desc = "zk: links" })
map("n", "zt", "<CMD>ZkTags<CR>", { desc = "zk: tags" })
map("n", "zdd", function()
	require("zk").new({ dir = "projects/journal/daily" })
end, { desc = "zk: new daily note" })
map("n", "zdw", function()
	require("zk").new({ dir = "projects/journal/weekly" })
end, { desc = "zk: new weekly note" })
map("n", "zdm", function()
	require("zk").new({ dir = "projects/journal/monthly" })
end, { desc = "zk: new monthly note" })
