local M = {}

-- Path to overriding theme and highlights files
local highlights = require("highlights")

M.ui = {
	theme = "gruvchad",
	theme_toggle = { "kanawaga", "papercolor-light" },
	transparency = true,
	lsp_semantic_tokens = true,

	extended_integrations = { "dap" },

	hl_override = highlights.override,
	hl_add = highlights.add,

	statusline = {
		theme = "vscode_colored",
	},

	nvdash = {
		load_on_startup = true,
		buttons = {
			{ "  Find File", "Spc f f", "Telescope find_files" },
			{ "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
			{ "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
			{ "  Bookmarks", "Spc f m", "Telescope marks" },
			{ "  Mappings", "Spc i h", "NvCheatsheet" },
		},
	},
}

M.plugins = "plugins"

-- check core.mappings for table structure
M.mappings = require("mappings")

return M
