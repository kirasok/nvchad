require("nvchad.options")

local enable_providers = {
	"python3_provider",
}
for _, plugin in pairs(enable_providers) do
	vim.g["loaded_" .. plugin] = nil
	vim.cmd("runtime " .. plugin)
end

vim.opt.conceallevel = 0
vim.opt.spell = true
vim.opt.spelllang = { "en", "ru" }
vim.opt.scrolloff = 3

vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
local base30 = require("base46").get_theme_tb("base_30")
vim.api.nvim_set_hl(0, "CursorLine", { bg = base30.black2 })
vim.api.nvim_set_hl(0, "CursorLineNr", { link = "CursorLine" })

vim.g.editorconfig = true

vim.cmd([[au FileType markdown match WildMenu /\s\{2,\}$/]]) -- at least 2 trailing spaces
