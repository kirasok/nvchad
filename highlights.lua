-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
	Comment = {
		italic = true,
	},
	["@keyword"] = {
		bold = true,
	},
	["@string"] = {
		italic = true,
	},
	["@string.regex"] = {
		italic = true,
		bold = true,
	},
	["@string.escape"] = {
		italic = true,
	},
	["@string.special"] = {
		italic = true,
		underline = true,
	},
	NvDashAscii = {
		bg = "none",
		fg = "purple",
	},
	NvDashButtons = {
		bg = "none",
	},
}

---@type HLTable
M.add = {
	NvimTreeOpenedFolderName = { fg = "green", bold = true },
}

return M
