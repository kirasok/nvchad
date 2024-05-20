return {
	{
		"<Leader>fd",
		function()
			require("telescope-directory").directory({
				feature = "live_grep", -- "find_files"|"grep_string"|"live_grep"
			})
		end,
		desc = "telescope select directory for Live Grep",
	},
	{
		"<Leader>fe",
		"<CMD>Telescope directory find_files<CR>", -- "find_files"|"grep_string"|"live_grep"
		desc = "telescope select directory for Find Files",
	},
}
