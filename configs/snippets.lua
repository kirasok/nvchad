local M = {}

M.luasnip = function()
	require("luasnip.loaders.from_vscode").lazy_load({
		paths = { vim.fn.stdpath("config") .. "/lua/snippets_vscode" },
	})
	require("luasnip.loaders.from_snipmate").lazy_load({
		paths = { vim.fn.stdpath("config") .. "/lua/snippets_snipmate" },
	})
	require("luasnip.loaders.from_lua").lazy_load({
		paths = { vim.fn.stdpath("config") .. "/lua/snippets_lua" },
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
M.scissors = { snippetDir = vim.fn.stdpath("config") .. "/lua/snippets_vscode" }

return M
