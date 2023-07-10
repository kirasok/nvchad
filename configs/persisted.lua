M = {
	autoload = true,
	on_autoload_no_session = function()
		vim.notify("No session to load")
	end,
	autosave = true,
	should_autosave = function()
		local ft = vim.bo.filetype
		if ft == "nvdash" or ft == "NvimTree" then
			return false
		end
		vim.notify("Session saved")
		return true
	end,
	allowed_dirs = {
		"~/Documents",
	},
}

return M
