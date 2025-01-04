local M = {}

function M.render_markdown()
	---@module 'render-markdown'
	---@type render.md.UserConfig
	local opts = {
		render_modes = { "n", "c", "t", "i" },
		anti_conceal = {
			ignore = {
				code_background = true,
				table_border = true,
				sign = true,
			},
		},
		latex = {
			enabled = false,
		},
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
		bullet = {
			icons = { "   ● ", "   ○ ", "   ◆ ", "   ◇ " },
		},
		checkbox = {
			unchecked = { icon = "   󰄱 " },
			checked = { icon = "   󰱒 " },
			custom = {
				todo = { raw = "[-]", rendered = "   󰄱 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
				strike = {
					raw = "[~]",
					rendered = "   󰅘 ",
					highlight = "@markup.strikethrough",
					scope_highlight = "@markup.strikethrough",
				},
			},
		},
		pipe_table = { enabled = true, style = "normal" },
		link = {
			hyperlink = "",
			wiki = { icon = "" },
		},
		indent = { enabled = true },
		sign = { enabled = false },
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

---@type TableNvimConfig
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

M.jupytext = {
	custom_language_formatting = {
		python = {
			extension = "qmd",
			style = "quarto",
			force_ft = "quarto",
		},
		r = {
			extension = "qmd",
			style = "quarto",
			force_ft = "quarto",
		},
	},
}

function M.molten()
	vim.g.molten_image_provider = "image.nvim"
	vim.g.molten_copy_output = true
	vim.g.molten_auto_open_output = false
	vim.g.molten_output_win_max_height = 20
	vim.g.molten_wrap_output = true
	vim.g.molten_virt_text_output = true
end

function M.quarto(_, _)
	require("quarto").setup({
		codeRunner = {
			enabled = true,
			default_method = "molten",
		},
	})
	require("mappings.filetypes.documents").quarto()
end

return M
