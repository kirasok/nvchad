local M = {}

---@type Flash.Config
M.flash = {
	label = { rainbow = { enable = true } },
	modes = { char = { enabled = true } },
}

M.yazi = {
	open_for_directories = true,
}

M.scrollEOF = {
	insert_mode = true,
	disabled_filetypes = { "quickfix" },
}

M.relative_toggle = {
	pattern = "*",
	events = {
		on = { "BufEnter", "FocusGained", "InsertLeave", "WinEnter", "CmdlineLeave" },
		off = { "BufLeave", "FocusLost", "InsertEnter", "WinLeave", "CmdlineEnter" },
	},
}

M.lastplace = {
	lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
	lastplace_ignore_filetype = {
		"gitcommit",
		"gitrebase",
		"svn",
		"hgcommit",
	},
	lastplace_open_folds = true,
}

return M
