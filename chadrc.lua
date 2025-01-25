-- Path to overriding theme and highlights files
local highlights = require("highlights")

local options = {
	base46 = {
		hl_override = highlights.override,
		hl_add = highlights.add,
		integrations = {},
		changed_themes = {},
		transparency = true,
		theme = "rosepine",
		theme_toggle = { "rosepine", "ayu_light" },
	},
	ui = {
		cmp = {
			style = "atom", -- default/flat_light/flat_dark/atom/atom_colored
		},

		statusline = {
			theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
		},
	},

	nvdash = {
		load_on_startup = true,
	},

	lsp = { signature = true },

	colorify = { enabled = false },
}

local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})
