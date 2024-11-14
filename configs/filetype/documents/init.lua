local M = {}

M.render_markdown = function()
	---@module 'render-markdown'
	---@type render.md.UserConfig
	local opts = {
		render_modes = { "n", "c", "i" },
		sign = { enabled = false },
		latex = { enabled = false },
		indent = { enabled = true },
		heading = {
			backgrounds = {
				"",
				"",
				"",
				"",
				"",
				"",
			},
		},
		link = {
			hyperlink = "",
			wiki = { icon = "" },
		},
		win_options = { conceallevel = { rendered = 2 } },
		on = {
			attach = function()
				require("nabla").enable_virt({ autogen = true })
			end,
		},
	}

	--- WARN: options from my fork
	opts.append_change_events = { "DiagnosticChanged" }
	opts.link.wiki.enabled = false
	opts.custom_handlers = {
		markdown_inline = require("configs.filetype.documents.markdown_inline"),
	}
	local base30 = require("base46").get_theme_tb("base_30")
	vim.api.nvim_set_hl(0, "@markup.heading.1", { fg = base30.red, bg = "", bold = true })
	vim.api.nvim_set_hl(0, "@markup.heading.2", { fg = base30.yellow, bg = "", bold = true })
	vim.api.nvim_set_hl(0, "@markup.heading.3", { fg = base30.cyan, bg = "", bold = true })
	vim.api.nvim_set_hl(0, "@markup.heading.4", { fg = base30.green, bg = "", bold = true })
	vim.api.nvim_set_hl(0, "@markup.heading.5", { fg = base30.blue, bg = "", bold = true })
	vim.api.nvim_set_hl(0, "@markup.heading.6", { fg = base30.purple, bg = "", bold = true })
	return opts
end

M.table_nvim = {
	padd_column_separators = true, -- Insert a space around column separators.
	mappings = { -- next and prev work in Normal and Insert mode. All other mappings work in Normal mode.
		next = "<A-TAB>", -- Go to next cell.
		prev = "<A-S-TAB>", -- Go to previous cell.
	},
}

M.zk_nvim = {
	picker = "telescope",
	lsp = {
		config = {
			on_attach = require("configs.lsp").on_attach,
		},
		auto_attach = {
			enabled = true,
			filetypes = { "markdown" },
		},
	},
}

M.img_clip = {
	default = {
		dir_path = "static",
		use_absolute_path = true,
		insert_mode_after_paste = false,
	},
	filetypes = {
		markdown = {
			template = "![$FILE_NAME_NO_EXT]($FILE_PATH)$CURSOR",
		},
	},
}

M.latex_snippets = { use_treesitter = true }

return M
