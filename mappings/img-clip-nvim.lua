return {
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
}
