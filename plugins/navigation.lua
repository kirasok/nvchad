local configs = require("configs.navigation")
local mappings = require("mappings.navigation")
---@type NvPluginSpec
return {
	{
		"chrisgrieser/nvim-spider",
		keys = mappings.nvim_spider,
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = configs.flash,
		keys = mappings.flash,
	},

	{
		"mikavilpas/yazi.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		opts = configs.yazi,
		keys = mappings.yazi,
	},

	{
		"Aasim-A/scrollEOF.nvim",
		event = { "CursorMoved", "WinScrolled" },
		opts = M.scrollEOF,
	},

	{ "DanilaMihailov/beacon.nvim", event = "BufEnter", commit = "098ff96" },

	{
		"cpea2506/relative-toggle.nvim",
		event = "BufEnter",
		opts = configs.relative_toggle,
	},

	{
		-- open fields in the last place you left
		"ethanholz/nvim-lastplace",
		lazy = false,
		opts = configs.lastplace,
	},
}
