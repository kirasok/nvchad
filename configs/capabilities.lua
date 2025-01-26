local M = {}

---@return UfoConfig
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

function M.cmdline()
	local cmp = require("cmp")
	-- `/` cmdline setup.
	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})
	-- `:` cmdline setup.
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{
				name = "cmdline",
				option = {
					ignore_cmds = { "Man", "!" },
				},
			},
		}),
	})
end

---@type ZenOptions
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

function M.gx()
	---@type GxOptions
	local opts = {
		handlers = {
			markdown = true,
			commit = true,
			plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
			github = true, -- open github issues
			brewfile = true, -- open Homebrew formulaes and casks
			package_json = true, -- open dependencies from package.json
			search = true, -- search the web/selection on the web if nothing else is found
			go = true, -- open pkg.go.dev from an import statement (uses treesitter)
			rust = { -- custom handler to open rust's cargo packages
				name = "rust", -- set name of handler
				filetype = { "toml" }, -- you can also set the required filetype for this handler
				filename = "Cargo.toml", -- or the necessary filename
				handle = function(mode, line, _)
					local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")
					if crate then
						return "https://crates.io/crates/" .. crate
					end
				end,
			},
		},
		handler_options = {
			search_engine = "google", -- you can select between google, bing, duckduckgo, ecosia and yandex
		},
	}
	require("gx").setup(opts)
end

--- Generate config for neogen
require("which-key").add({
	{ "<leader>a", group = "annotation" },
})
function M.neogen()
	---@type neogen.Configuration
	local opts = { snippet_engine = "luasnip" }
	require("neogen").setup(opts)
end

M.autosave = {
	noautocmd = true, -- do not execute autocmds when saving
}

return M
