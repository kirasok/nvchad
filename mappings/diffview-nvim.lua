return {
	{
		"<leader>gd",
		function()
			local view = require("diffview.lib").get_current_view()
			if view then
				-- Current tabpage is a Diffview; close it
				vim.cmd.DiffviewClose()
			else
				-- No open Diffview exists: open a new one
				vim.cmd.DiffviewOpen()
			end
		end,
		desc = "Diffview",
	},
}
