require("nvchad.options")

-- add yours here!

if ".ipynb" ~= string.sub(vim.fn.argv()[1], -6) then
	vim.opt.conceallevel = 2
else
	-- enable python provider
	local enable_providers = {
		"python3_provider",
	}

	for _, plugin in pairs(enable_providers) do
		vim.g["loaded_" .. plugin] = nil
		vim.cmd("runtime " .. plugin)
	end
end

vim.opt.spell = true
vim.opt.spelllang = { "en", "ru" }
vim.opt.scrolloff = 3
