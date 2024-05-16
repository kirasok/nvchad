require("nvchad.options")

if vim.bo.filetype == "quarto" then
	-- enable python provider
	local enable_providers = {
		"python3_provider",
	}
	for _, plugin in pairs(enable_providers) do
		vim.g["loaded_" .. plugin] = nil
		vim.cmd("runtime " .. plugin)
	end
end

vim.opt.conceallevel = 0
vim.opt.spell = true
vim.opt.spelllang = { "en", "ru" }
vim.opt.scrolloff = 3
