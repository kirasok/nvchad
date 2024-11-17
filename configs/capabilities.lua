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

M.wilder = function(_, _)
	local wilder = require("wilder")
	wilder.setup({ modes = { ":", "/", "?" } })
	wilder.set_option(
		"renderer",
		wilder.popupmenu_renderer({
			highlighter = wilder.basic_highlighter(),
			left = { " ", wilder.popupmenu_devicons() },
			right = { " ", wilder.popupmenu_scrollbar() },
		})
	)
end

M.zen = {
	window = {
		width = 75,
		options = {
			number = false,
			relativenumber = false,
			cursorline = false,
		},
	},
}

M.image = {
	integrations = {
		markdown = {
			enabled = true,
			download_remote_images = false,
			filetypes = { "markdown", "vimwiki", "quarto" },
		},
	},
	max_width = 100, -- tweak to preference
	max_height = 12, -- ^
	max_height_window_percentage = math.huge, -- this is necessary for a good experience
	max_width_window_percentage = math.huge,
	window_overlap_clear_enabled = true,
}

return M
