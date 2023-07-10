---@type MappingsTable
local M = {}

M.general = {
	i = {
		-- go to  beginning and end
		["<C-b>"] = { "" },
		["<C-e>"] = { "" },

		-- navigate within insert mode
		["<C-h>"] = { "" },
		["<C-l>"] = { "<Esc>[s1z=`]a" },
		["<C-j>"] = { "" },
		["<C-k>"] = { "" },
	},

	n = {
		-- save
		["<C-s>"] = { "" },

		-- line numbers
		["<leader>n"] = { "" },
		["<leader>rn"] = { "" },

		-- new buffer
		["<leader>b"] = { "" },

		["<leader>fm"] = { "" },
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
		["<leader>ch"] = { "" },
		["<leader>ih"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },
	},
}

M.tabufline = {
	n = {
		["<S-tab>"] = { "" },
		["\\<tab>"] = {
			function()
				require("nvchad_ui.tabufline").tabuflinePrev()
			end,
			"Goto prev buffer",
		},
	},
}

M.lspconfig = {
	-- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
	n = {
		["gD"] = { "" },
		["fD"] = {
			function()
				vim.lsp.buf.declaration()
			end,
			"LSP declaration",
		},

		["gd"] = { "" },
		["fd"] = {
			function()
				vim.lsp.buf.definition()
			end,
			"LSP definition",
		},

		["K"] = { "" },
		["fk"] = {
			function()
				vim.lsp.buf.hover()
			end,
			"LSP hover",
		},

		["gi"] = { "" },
		["fi"] = {
			function()
				vim.lsp.buf.implementation()
			end,
			"LSP implementation",
		},

		["<leader>ls"] = { "" },
		["fs"] = {
			function()
				vim.lsp.buf.signature_help()
			end,
			"LSP signature help",
		},

		["<leader>D"] = { "" },
		["ft"] = {
			function()
				vim.lsp.buf.type_definition()
			end,
			"LSP definition type",
		},

		["<leader>ra"] = { "" },
		["fr"] = {
			function()
				require("nvchad_ui.renamer").open()
			end,
			"LSP rename",
		},

		["<leader>ca"] = { "" },
		["fa"] = {
			function()
				vim.lsp.buf.code_action()
			end,
			"LSP code action",
		},

		["gr"] = { "" },
		["fR"] = {
			function()
				vim.lsp.buf.references()
			end,
			"LSP references",
		},

		["ff"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"LSP formatting",
		},
	},
}

M.nvimtree = {
	n = {
		-- focus
		["<leader>e"] = { "" },
	},
}

M.telescope = {
	n = {
		-- git
		["<leader>cm"] = { "" },
		["<leader>gt"] = { "" },

		-- pick a hidden term
		["<leader>pt"] = { "" },

		-- theme switcher
		["<leader>th"] = { "" },

		["<leader>ma"] = { "" },
		["<leader>fm"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
	},
}

M.nvterm = {
	n = {
		-- new
		["<leader>h"] = { "" },

		["<leader>v"] = { "" },
	},
}

M.whichkey = {
	n = {
		["<leader>wK"] = { "" },
		["<leader>wk"] = { "" },
	},
}

M.blankline = {
	n = {
		["gd"] = {
			function()
				local ok, start = require("indent_blankline.utils").get_current_context(
					vim.g.indent_blankline_context_patterns,
					vim.g.indent_blankline_use_treesitter_scope
				)

				if ok then
					vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
					vim.cmd([[normal! _]])
				end
			end,

			"Jump to current context",
		},
		["<leader>cc"] = { "" },
	},
}

M.gitsigns = {
	n = {
		-- Actions
		["<leader>rh"] = { "" },

		["<leader>ph"] = { "" },

		["<leader>gb"] = { "" },

		["<leader>td"] = { "" },
	},
}
-- more keybinds!

M.zk = {
	plugin = true,

	n = {
		["zz"] = {
			function()
				require("zk").edit({ sort = { "modified" } })
			end,
			"zk: open note",
		},
		["zn"] = {
			function()
				require("zk").new({ title = vim.fn.input("title: "), dir = "notsorted" })
			end,
			"zk: new note",
		},
		["zp"] = {
			function()
				require("zk").new({ title = vim.fn.input("title: "), dir = "projects" })
			end,
			"zk: new project",
		},
		["zb"] = {
			"<CMD>ZkBacklinks<CR>",
			"zk: backlinks",
		},
		["zl"] = {
			"<CMD>ZkLinks<CR>",
			"zk: links",
		},
		["zt"] = {
			"<CMD>ZkTags<CR>",
			"zk: tags",
		},
		["zdd"] = {
			function()
				require("zk").new({ dir = "projects/journal/daily" })
			end,
			"zk: new daily note",
		},
		["zdw"] = {
			function()
				require("zk").new({ dir = "projects/journal/weekly" })
			end,
			"zk: new weekly note",
		},
		["zdm"] = {
			function()
				require("zk").new({ dir = "projects/journal/monthly" })
			end,
			"zk: new monthly note",
		},
	},

	v = {
		["zn"] = {
			"<CMD>'<,'>ZkNewFromTitleSelection{dir = 'notsorted'}<CR>",
			"zk: new note from title",
		},
		-- TODO: imporve
		["zi"] = {
			"<CMD>'<,'>ZkInsertLinkAtSelection<CR>",
			"zk: insert link from visual",
		},
	},
}

require("core.utils").load_mappings("zk")

M.vimtablemode = {
	plugin = true,

	v = {
		["<leader>tt"] = { "" },
		["<leader>T"] = { "" },
	},

	n = {
		["<leader>tm"] = { "" },
		["<leader>tt"] = { "" },
	},
}

M.octo = {
	plugin = true,

	n = {
		-- issue
		["<leader>giC"] = { "<CMD>Octo issue close<CR>", "close" },
		["<leader>giR"] = { "<CMD>Octo issue reopen<CR>", "reopen" },
		["<leader>gic"] = { "<CMD>Octo issue create<CR>", "create" },
		["<leader>gie"] = { "<CMD>Octo issue edit<CR>", "edit" },
		["<leader>gil"] = { "<CMD>Octo issue list<CR>", "list" },
		["<leader>gis"] = { "<CMD>Octo issue search<CR>", "search" },
		["<leader>gir"] = { "<CMD>Octo issue reload<CR>", "reload" },
		["<leader>gib"] = { "<CMD>Octo issue browser<CR>", "browser" },
		["<leader>giu"] = { "<CMD>Octo issue url<CR>", "url" },

		-- pr
		["<leader>gpl"] = { "<CMD>Octo pr list<CR>", "list" },
		["<leader>gps"] = { "<CMD>Octo pr search<CR>", "search" },
		["<leader>gpe"] = { "<CMD>Octo pr edit<CR>", "edit" },
		["<leader>gpR"] = { "<CMD>Octo pr reopen<CR>", "reopen" },
		["<leader>gpc"] = { "<CMD>Octo pr create<CR>", "create" },
		["<leader>gpC"] = { "<CMD>Octo pr close<CR>", "close" },
		["<leader>gpo"] = { "<CMD>Octo pr checkout<CR>", "checkout" },
		["<leader>gpO"] = { "<CMD>Octo pr commits<CR>", "commits" },
		["<leader>gpd"] = { "<CMD>Octo pr diff<CR>", "diff" },
		["<leader>gpm"] = { "<CMD>Octo pr merge<CR>", "merge" },
		["<leader>gpi"] = { "<CMD>Octo pr ready<CR>", "ready" },
		["<leader>gpS"] = { "<CMD>Octo pr checks<CR>", "checks" },
		["<leader>gpr"] = { "<CMD>Octo pr reload<CR>", "reload" },
		["<leader>gpb"] = { "<CMD>Octo pr browser<CR>", "browser" },
		["<leader>gpu"] = { "<CMD>Octo pr url<CR>", "url" },

		-- repo
		["<leader>grl"] = { "<CMD>Octo repo list<CR>", "list" },
		["<leader>grf"] = { "<CMD>Octo repo fork<CR>", "fork" },
		["<leader>grb"] = { "<CMD>Octo repo browser<CR>", "browser" },
		["<leader>gru"] = { "<CMD>Octo repo url<CR>", "url" },
		["<leader>grv"] = { "<CMD>Octo repo view<CR>", "view" },

		-- other
		-- gists
		["<leader>gog"] = { "<CMD>Octo gist list<CR>", "list gists" },
		-- comments
		["<leader>goca"] = { "<CMD>Octo comment add<CR>", "add comment" },
		["<leader>gocd"] = { "<CMD>Octo comment delete<CR>", "delete comment" },
		-- threads
		["<leader>gotr"] = { "<CMD>Octo thread resolve<CR>", "resolve thread" },
		["<leader>gotu"] = { "<CMD>Octo thread unresolve<CR>", "unresolve thread" },
		-- labels
		["<leader>gola"] = { "<CMD>Octo label add<CR>", "add label" },
		["<leader>golr"] = { "<CMD>Octo label remove<CR>", "remove label" },
		["<leader>golc"] = { "<CMD>Octo label create<CR>", "create label" },
	},
}

M.undotree = {
	plugin = true,
	n = {
		["<leader>fu"] = {
			function()
				require("telescope").extensions.undo.undo()
			end,
			"undo tree",
		},
	},
}

M.neogen = {
	plugin = true,
	n = {
		["<leader>nn"] = {
			":Neogen func<cr>",
			"neogen function",
		},
		["<leader>nc"] = {
			":Neogen class<cr>",
			"neogen class",
		},
		["<leader>nf"] = {
			":Neogen file<cr>",
			"neogen file",
		},
		["<leader>nt"] = {
			":Neogen type<cr>",
			"neogen type",
		},
	},
}

return M
