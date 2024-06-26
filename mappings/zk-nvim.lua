return {
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
		desc = "zk new project",
	},
	{
		"zn",
		function()
			require("zk").new({ title = vim.fn.input("title: ") })
		end,
		desc = "zk new note",
	},
	{
		"zz",
		function()
			require("zk").edit({ sort = { "modified" } })
		end,
		desc = "zk open note",
	},
	{
		"zp",
		function()
			require("zk").new({ title = vim.fn.input("title: "), dir = "projects", group = "projects" })
		end,
		desc = "zk new project",
	},
	{ "zb", "<CMD>ZkBacklinks<CR>", desc = "zk backlinks" },
	{ "zn", ":'<,'>ZkNewFromTitleSelection<CR>", mode = "v", desc = "zk new title from selection" },
	{ "zl", "<CMD>ZkLinks<CR>", desc = "zk links" },
	{ "zt", "<CMD>ZkTags<CR>", desc = "zk tags" },
	{
		"zdd",
		function()
			require("zk").new({ dir = "projects/journal/daily", group = "daily" })
		end,
		desc = "zk new daily note",
	},
	{
		"zdw",
		function()
			require("zk").new({ dir = "projects/journal/weekly", group = "weekly" })
		end,
		desc = "zk new weekly note",
	},
	{
		"zdm",
		function()
			require("zk").new({ dir = "projects/journal/monthly", group = "monthly" })
		end,
		desc = "zk new monthly note",
	},
	{
		"zdt",
		function()
			require("zk").new({ dir = "projects/journal/daily", group = "tomorrow" })
		end,
		desc = "zk new daily note for tomorrow",
	},
	{
		"zN",
		function()
			require("telescope-directory").directory({ feature = "print_directory" })
		end,
		desc = "zk new note in folder",
	},
}
