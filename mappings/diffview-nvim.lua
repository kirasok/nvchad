return {
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
			require("telescope.builtin").git_commits({
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
}
