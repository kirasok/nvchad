M = {}

require("which-key").add({
	{ "<leader>g", group = "git" },
})

local previewers = require("telescope.previewers")
local builtin = require("telescope.builtin")
local git_diff = previewers.new_termopen_previewer({
	get_command = function(entry)
		return {
			"git",
			"diff",
			entry.value .. "^!",
			"--",
			entry.current_file,
		}
	end,
})

local previewer = {
	git_diff,
	previewers.git_commit_message.new({}),
	previewers.git_commit_diff_as_was.new({}),
}

local git_command = {
	"git",
	"log",
	"--pretty=%h %>(14,trunc)%ad %s", -- <abbr_commti> <date> <message>
}

local function git_bcommits(opts)
	opts = opts or {}
	opts.previewer = previewer
	opts.git_command = git_command
	builtin.git_bcommits(opts)
end

local function git_commits(opts)
	opts = opts or {}
	opts.previewer = previewer
	opts.git_command = git_command
	builtin.git_commits(opts)
end

---@type LazyKeymaps[]
M.diffview = {
	{ "<leader>gb", git_bcommits, desc = "File history" },
	{ "<leader>gc", git_commits, desc = "Checkout commit" },
	{
		"<leader>gd",
		function()
			local view = require("diffview.lib").get_current_view()
			if view then
				-- Current tabpage is a Diffview; close it
				vim.cmd.DiffviewClose()
			else
				-- No open Diffview exists: open a new one
				vim.cmd.DiffviewOpen()
			end
		end,
		desc = "Diff HEAD",
	},
	{
		"<leader>gD",
		function()
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			git_commits({
				attach_mappings = function(prompt_bufnr, _)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()
						if selection == nil then
							return
						end
						actions.close(prompt_bufnr)
						vim.cmd.DiffviewOpen(selection.value)
					end)
					return true
				end,
			})
		end,
		desc = "Diff commit",
	},
	{
		"<leader>gl",
		function()
			local view = require("diffview.lib").get_current_view()
			if view then
				vim.cmd.DiffviewClose()
			else
				vim.cmd.DiffviewFileHistory()
			end
		end,
		desc = "History diff",
	},
}

---@type LazyKeymaps[]
M.neogit = {
	{ "<leader>go", "<cmd>Neogit<cr>", desc = "Neogit" },
}

---@type LazyKeymaps[]
M.blame = {
	{ "<leader>gB", "<cmd>BlameToggle<cr>", desc = "Blame" },
}

return M
