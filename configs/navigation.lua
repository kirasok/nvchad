local M = {}

---@type Flash.Config
M.flash = {
	jump = { nohlsearch = false },
	label = { rainbow = { enable = true } },
	modes = { char = { enabled = true } },
}

---@type YaziConfig
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

function M.projections()
	-- Save localoptions to session file
	vim.opt.sessionoptions:append("localoptions")
	require("projections").setup({
		workspaces = { -- Default workspaces to search for
			{ "~/Documents/", { ".git" } },
		},
	})

	-- Autostore session on VimExit
	local Session = require("projections.session")
	vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
		callback = function()
			local cwd = vim.loop.cwd()
			if cwd ~= nil then
				Session.store(cwd)
			end
		end,
	})

	-- Switch to project if vim was started in a project dir
	local switcher = require("projections.switcher")
	vim.api.nvim_create_autocmd({ "VimEnter" }, {
		callback = function()
			if vim.fn.argc() == 0 then
				local cwd = vim.loop.cwd()
				if cwd ~= nil then
					switcher.switch(cwd)
				end
			end
		end,
	})
end

return M
