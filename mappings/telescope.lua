require("which-key").add({
	{ "<leader>f", group = "find" },
})
return {
	telescope = {
		{ "<leader>fw", "<cmd>Telescope live_grep<CR>", desc = "live grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "find buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "help page" },
		{ "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "find oldfiles" },
		{ "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "find in current buffer" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "find files" },
		{
			"<leader>fa",
			"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
			desc = "find all files",
		},
	},
	text_case = {
		{
			"<space>fc",
			"<cmd>TextCaseOpenTelescope<CR>",
			mode = { "n", "x" },
			desc = "convert text case",
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
			desc = "select directory for Live Grep",
		},
		{
			"<Leader>fe",
			"<CMD>Telescope directory find_files<CR>", -- "find_files"|"grep_string"|"live_grep"
			desc = "select directory for Find Files",
		},
	},
}
