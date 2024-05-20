return {
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
}
