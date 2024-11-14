return {
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
		config = function(_, opts)
			require("dap-python").setup("python3")
		end,
	},
}
