local M = {}

M.ufo = function()
	vim.o.foldcolumn = "0" -- '0' is not bad
	vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
	vim.o.foldlevelstart = 99
	vim.o.foldenable = true
	return {
		fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
			local newVirtText = {}
			local suffix = (" 󰁂 %d "):format(endLnum - lnum)
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0
			for _, chunk in ipairs(virtText) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					local hlGroup = chunk[2]
					table.insert(newVirtText, { chunkText, hlGroup })
					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					-- str width returned from truncate() may less than 2nd argument, need padding
					if curWidth + chunkWidth < targetWidth then
						suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
					end
					break
				end
				curWidth = curWidth + chunkWidth
			end
			table.insert(newVirtText, { suffix, "MoreMsg" })
			return newVirtText
		end,
		provider_selector = function(bufnr, filetype, buftype)
			return { "treesitter", "indent" }
		end,
	}
end

M.yanky = {
	highlight = {
		timer = 250,
	},
}

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

return M
