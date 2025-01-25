local M = {}

local config_path = vim.fn.stdpath("config")
local snippets_vscode = config_path .. "/lua/snippets_vscode"
local snippets_snipmate = config_path .. "/lua/snippets_snipmate"
local snippets_lua = config_path .. "/lua/snippets_lua"

M.luasnip = function()
	require("luasnip.loaders.from_vscode").lazy_load({
		paths = { snippets_vscode },
	})
	require("luasnip.loaders.from_snipmate").lazy_load({
		paths = { snippets_snipmate },
	})
	require("luasnip.loaders.from_lua").lazy_load({
		paths = { snippets_lua },
	})

	-- highlight luasnip nodes
	local types = require("luasnip.util.types")
	return {
		ext_opts = {
			[types.choiceNode] = {
				active = {
					virt_text = { { "●", "GruvboxOrange" } },
				},
			},
			[types.insertNode] = {
				active = {
					virt_text = { { "●", "GruvboxBlue" } },
				},
			},
		},
	}
end

---@type Scissors.Config
M.scissors = { snippetDir = snippets_vscode }

return M
