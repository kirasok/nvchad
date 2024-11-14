return {
	telescope = {
		{ "<leader>fw", "<cmd>Telescope live_grep<CR>", desc = "telescope live grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "telescope find buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "telescope help page" },
		{ "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "telescope find oldfiles" },
		{ "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "telescope find in current buffer" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "telescope find files" },
		{
			"<leader>fa",
			"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
			desc = "telescope find all files",
		},
	},
	text_case = {
		{
			"<space>fc",
			"<cmd>TextCaseOpenTelescope<CR>",
			mode = { "n", "x" },
			desc = "telescope convert text case",
		},
	},
	direcotory = {
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
	},
}
