local M = {}
---@module 'render-markdown'
---@type render.md.UserConfig
M.opts = {
	render_modes = { "n", "c", "i" },
	sign = { enabled = false },
	latex = { enabled = false },
	indent = { enabled = true },
	heading = {
		backgrounds = {
			"",
			"",
			"",
			"",
			"",
			"",
		},
	},
	link = {
		hyperlink = "",
		wiki = { icon = "" },
	},
	win_options = { conceallevel = { rendered = 2 } },
	on = {
		attach = function()
			require("nabla").enable_virt({ autogen = true })
		end,
	},
}

return M
