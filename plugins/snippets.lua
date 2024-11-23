local configs = require("configs.snippets")
local mappings = require("mappings.snippets")
---@type NvPluginSpec[]
return {
	{
		"L3MON4D3/LuaSnip",
		config = function(_, _)
			require("luasnip").setup(configs.luasnip())
		end,
	},

	{
		"chrisgrieser/nvim-scissors",
		dependencies = { "nvim-telescope/telescope.nvim", "L3MON4D3/LuaSnip" },
		opts = configs.scissors,
		cmd = { "ScissorsAddNewSnippet", "ScissorsEditSnippet" },
		keys = mappings.scissors,
		config = function(_, opts)
			require("scissors").setup(opts)
		end,
	},
}
