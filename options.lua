require("nvchad.options")

-- enable python provider
local enable_providers = {
	"python3_provider",
}
for _, plugin in pairs(enable_providers) do
	vim.g["loaded_" .. plugin] = nil
	vim.cmd("runtime " .. plugin)
end

vim.opt.conceallevel = 0
vim.opt.spell = true
vim.opt.spelllang = { "en" }
vim.opt.scrolloff = 3

vim.g.editorconfig = true

vim.cmd([[au FileType markdown match WildMenu /\s\{2,\}$/]]) -- at least 2 trailing spaces
