---@type NvPluginSpec[]
local plugins = {

	{
		-- manage zettelkasten
		"zk-org/zk-nvim",
		ft = "markdown",
		dependencies = {
			{
				"fbuchlak/telescope-directory.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"nvim-telescope/telescope.nvim",
				},
				-- @type telescope-directory.ExtensionConfig
				opts = {
					features = {
						{
							name = "print_directory",
							callback = function(dirs)
								require("zk.commands").get("ZkNew")({
									dir = dirs[1],
									title = vim.fn.input("Enter title: "),
								})
							end,
						},
					},
				},
				config = function(_, opts)
					require("telescope-directory").setup(opts)
				end,
				keys = {
					{
						"<Leader>fd",
						function()
							require("telescope-directory").directory({
								feature = "live_grep", -- "find_files"|"grep_string"|"live_grep"
							})
						end,
						desc = "Select directory for Live Grep",
					},
					{
						"<Leader>fe",
						"<CMD>Telescope directory find_files<CR>", -- "find_files"|"grep_string"|"live_grep"
						desc = "Select directory for Find Files",
					},
					{
						"zN",
						function()
							require("telescope-directory").directory({ feature = "print_directory" })
						end,
						desc = "zk: new note in folder",
					},
				},
			},
		},
		opts = {
			picker = "telescope",
			auto_attach = {
				enabled = true,
				filetypes = { "markdown" },
			},
		},
		config = function(_, opts)
			require("zk").setup(opts)
			vim.cmd([[set backupcopy=yes]])
		end,
		keys = {
			{
				"zi",
				function(options)
					local zk = require("zk")

					local function tbl_length(T)
						local count = 0
						for _ in pairs(T) do
							count = count + 1
						end
						return count
					end

					local function get_visual_selection()
						-- this will exit visual mode
						-- use 'gv' to reselect the text
						local _, csrow, cscol, cerow, cecol
						local mode = vim.fn.mode()
						if mode == "v" or mode == "V" or mode == "�" then
							-- if we are in visual mode use the live position
							_, csrow, cscol, _ = unpack(vim.fn.getpos("."))
							_, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
							if mode == "V" then
								-- visual line doesn't provide columns
								cscol, cecol = 0, 999
							end
							-- exit visual mode
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
						else
							-- otherwise, use the last known visual position
							_, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
							_, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
						end
						-- swap vars if needed
						if cerow < csrow then
							csrow, cerow = cerow, csrow
						end
						if cecol < cscol then
							cscol, cecol = cecol, cscol
						end
						local lines = vim.fn.getline(csrow, cerow)
						-- local n = cerow-csrow+1
						local n = tbl_length(lines)
						if n <= 0 then
							return ""
						end
						lines[n] = string.sub(lines[n], 1, cecol)
						lines[1] = string.sub(lines[1], cscol)
						return table.concat(lines, "\n")
					end

					local function yankNameReplace(options, picker_options)
						local selected = get_visual_selection()
						zk.pick_notes(options, picker_options, function(notes)
							local pos = vim.api.nvim_win_get_cursor(0)[2]
							local line = vim.api.nvim_get_current_line()

							if picker_options.multi_select == false then
								notes = { notes }
							end
							for _, note in ipairs(notes) do
								local nline = line:sub(0, pos - #selected)
									.. "[["
									.. note.path:match("/?([^/]+).md$")
									.. "|"
									.. selected
									.. "]]"
									.. line:sub(pos + 1)
								vim.api.nvim_set_current_line(nline)
							end
						end)
					end

					yankNameReplace(options, { title = "Zk Yank" })
				end,
				mode = "v",
				desc = "Insert link on VISUAL",
			},
			{
				"zp",
				function()
					require("zk").new({ title = vim.fn.input("title: "), dir = "projects" })
				end,
				desc = "zk: new project",
			},
			{
				"zn",
				function()
					require("zk").new({ title = vim.fn.input("title: ") })
				end,
				desc = "zk: new note",
			},
			{
				"zz",
				function()
					require("zk").edit({ sort = { "modified" } })
				end,
				desc = "zk: open note",
			},
			{
				"zp",
				function()
					require("zk").new({ title = vim.fn.input("title: "), dir = "projects", group = "projects" })
				end,
				desc = "zk: new project",
			},
			{ "zb", "<CMD>ZkBacklinks<CR>", desc = "zk: backlinks" },
			{ "zn", ":'<,'>ZkNewFromTitleSelection<CR>", mode = "v", desc = "zk: new title from selection" },
			{ "zl", "<CMD>ZkLinks<CR>", desc = "zk: links" },
			{ "zt", "<CMD>ZkTags<CR>", desc = "zk: tags" },
			{
				"zdd",
				function()
					require("zk").new({ dir = "projects/journal/daily", group = "daily" })
				end,
				desc = "zk: new daily note",
			},
			{
				"zdw",
				function()
					require("zk").new({ dir = "projects/journal/weekly", group = "weekly" })
				end,
				desc = "zk: new weekly note",
			},
			{
				"zdm",
				function()
					require("zk").new({ dir = "projects/journal/monthly", group = "monthly" })
				end,
				desc = "zk: new monthly note",
			},
			{
				"zdt",
				function()
					require("zk").new({ dir = "projects/journal/daily", group = "tomorrow" })
				end,
				desc = "zk: new daily note for tomorrow",
			},
		},
	},

	{
		-- conceal things for better document editing
		"KeitaNakamura/tex-conceal.vim",
		ft = "tex",
		config = function()
			vim.g["tex_conceal"] = "abdgm"
		end,
	},

	{
		"iurimateus/luasnip-latex-snippets.nvim",
		dependencies = { "L3MON4D3/LuaSnip", "nvim-treesitter/nvim-treesitter" },
		opts = { use_treesitter = true },
		config = function(_, opts)
			require("luasnip-latex-snippets").setup(opts)
			require("luasnip").config.setup({ enable_autosnippets = true })
		end,
		ft = { "tex", "markdown" },
	},

	{
		"HakonHarnes/img-clip.nvim",
		cmd = "PasteImage",
		dependencies = {
			{
				"kirasok/telescope-media-files.nvim",
				dependencies = {
					"nvim-telescope/telescope.nvim",
				},
				opts = {
					filetypes = { "png", "webp", "jpg", "jpeg", "pdf", "mp4", "mkv", "svg" },
				},
				config = function(_, opts)
					require("telescope").load_extension("media_files")
					require("telescope").setup({
						extensions = {
							media_files = opts,
						},
					})
				end,
			},
		},
		opts = {
			default = {
				dir_path = "static",
			},
		},
		keys = {
			-- suggested keymap
			{ "<leader>fp", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
			{
				"<leader>fP",
				function()
					local telescope = require("telescope")
					local actions = require("telescope.actions")
					local action_state = require("telescope.actions.state")

					-- telescope.extensions.media_files.media_files() -- TODO: doesn't work
					telescope.extensions.media_files.media_files({
						attach_mappings = function(_, map)
							local function embed_image(prompt_bufnr)
								local entry = action_state.get_selected_entry()
								local filepath = entry[1]
								actions.close(prompt_bufnr)

								local img_clip = require("img-clip")
								img_clip.paste_image(nil, filepath)
							end

							map("i", "<CR>", embed_image)
							map("n", "<CR>", embed_image)

							return true
						end,
					})
				end,
				desc = "Paste image from file",
			},
		},
	},

	{
		"hrsh7th/cmp-emoji",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		ft = "markdown",
		config = function(_, opts)
			local cmp = require("cmp")
			local config = cmp.get_config()
			table.insert(config.sources, {
				name = "emoji",
			})
			cmp.setup(config)
		end,
	},

	{
		"lukas-reineke/headlines.nvim",
		ft = { "markdown", "org", "norg" },
		opts = {
			markdown = {
				fat_headlines = false,
				bullets = { "◉", "󰻃", "○", "✿" },
			},
		},
		config = function(_, opts)
			require("headlines").setup(opts)
			vim.cmd([[hi Headline guibg=none]])
			vim.cmd([[hi CodeBlock guibg=none]])
			vim.cmd([[hi Dash guibg=none]])
			vim.cmd([[hi Quote guibg=none]])
		end,
	},

	{
		"quarto-dev/quarto-nvim",
		ft = "quarto",
		dependencies = {
			{
				"jmbuhr/otter.nvim",
				dependencies = {
					"hrsh7th/nvim-cmp",
					"neovim/nvim-lspconfig",
					"nvim-treesitter/nvim-treesitter",
				},
				config = function(_, opts)
					require("otter").setup(opts)
					local cmp = require("cmp")
					local config = cmp.get_config()
					table.insert(config.sources, {
						name = "otter",
					})
					cmp.setup(config)
				end,
			},
			{
				"benlubas/molten-nvim",
				version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
				dependencies = {
					{ "3rd/image.nvim" },
					{
						"GCBallesteros/jupytext.nvim",
						opts = { style = "quarto", output_extension = "qmd", force_ft = "quarto" },
					},
				},
				build = ":UpdateRemotePlugins",
				init = function()
					vim.g.molten_image_provider = "image.nvim"
				end,
			},
		},
		opts = {
			lspFeatures = {
				languages = { "python" },
				chunks = "all",
				diagnostics = {
					enabled = true,
					triggers = { "BufWritePost" },
				},
				completion = {
					enabled = true,
				},
			},
			keymap = false,
			codeRunner = {
				enabled = true,
				default_method = "molten",
				never_run = { "yaml" },
			},
		},
		config = function(_, opts)
			require("quarto").setup(opts)
			require("quarto").activate()
			local runner = require("quarto.runner")
			vim.keymap.set("n", "<leader>rc", runner.run_cell, { desc = "run cell" })
			vim.keymap.set("n", "<leader>ra", runner.run_above, { desc = "run cell and above" })
			vim.keymap.set("n", "<leader>rA", runner.run_all, { desc = "run all cells" })
			vim.keymap.set("n", "<leader>rl", runner.run_line, { desc = "run line" })
			vim.keymap.set("v", "<leader>r", runner.run_range, { desc = "run visual range" })
			vim.keymap.set("n", "<leader>RA", function()
				runner.run_all(true)
			end, { desc = "run all cells of all languages" })
		end,
	},
}

return plugins
