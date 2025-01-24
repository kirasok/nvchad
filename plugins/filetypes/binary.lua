local mappings = require("mappings.filetypes.binary")
---@type NvPluginSpec[]
return {
	{
		"RaafatTurki/hex.nvim",
		keys = mappings.hex,
	},
}
