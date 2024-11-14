local mappings = require("mappings.telescope")
---@type NvPluginSpec[]
return {
	{ "nvim-telescope/telescope.nvim", keys = mappings.telescope },

	{
		"johmsalas/text-case.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function(_, opts)
			require("textcase").setup(opts)
			require("telescope").load_extension("textcase")
		end,
		keys = mappings.text_case,
		cmd = {
			"Subs",
			"TextCaseOpenTelescope",
			"TextCaseOpenTelescopeQuickChange",
			"TextCaseOpenTelescopeLSPChange",
			"TextCaseStartReplacingCommand",
		},
	},

	{
		"fbuchlak/telescope-directory.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			--- TODO: fix depending on zk
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
		keys = mappings.directory,
	},

	{
		"kirasok/telescope-media-files.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
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
}
