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
vim.opt.spelllang = { "en", "ru" }
vim.opt.scrolloff = 3

vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
local base30 = require("base46").get_theme_tb("base_30")
vim.api.nvim_set_hl(0, "CursorLine", { bg = base30.black2 })
vim.api.nvim_set_hl(0, "CursorLineNr", { link = "CursorLine" })

vim.g.editorconfig = true

vim.cmd([[au FileType markdown match WildMenu /\s\{2,\}$/]]) -- at least 2 trailing spaces

local function get_num_wraps() -- second function removed
	local winid = vim.api.nvim_get_current_win()

	local winwidth = vim.api.nvim_win_get_width(winid)
	local numberwidth = vim.wo.number and vim.wo.numberwidth or 0
	local signwidth = vim.fn.exists("*sign_define") == 1 and vim.fn.sign_getdefined() and 2 or 0
	local foldcolumn = vim.wo.foldcolumn
	local foldwidth = tonumber(foldcolumn) or 0 -- Dealing with foldcolumn string in case you have as auto

	local bufferwidth = winwidth - numberwidth - signwidth - foldwidth

	local line = vim.fn.getline(vim.v.lnum)
	local line_length = vim.fn.strdisplaywidth(line)

	return math.floor(line_length / bufferwidth)
end

function CheckSymbolOrNumber(current)
	if vim.v.virtnum < 0 then
		return "-"
	end

	if vim.v.virtnum > 0 and (vim.wo.number or vim.wo.relativenumber) then
		local num_wraps = get_num_wraps()
		if vim.v.virtnum == num_wraps then
			return "╰" -- Rounded border
		else
			return "│"
		end
	end

	return current
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	callback = function()
		-- WARN: doesn't actually disable it
		if vim.bo.filetype == "nvdash" or vim.bo.filetype == "TelescopePrompt" then -- List of buffers where you don't want to show the statuscolumn
			vim.opt_local.statuscolumn = ""
		else
			vim.opt.statuscolumn = '%s%C%=%#CursorLineNr#%{(v:relnum == 0)?v:lua.CheckSymbolOrNumber(v:lnum)."'
				.. "  "
				.. '":""}'
				.. '%#LineNr#%{(v:relnum != 0)?v:lua.CheckSymbolOrNumber(v:relnum)."'
				.. " "
				.. '":""}'
		end
	end,
})
