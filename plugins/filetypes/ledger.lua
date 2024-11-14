return {
	{
		"kirasok/cmp-hledger",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"ledger/vim-ledger",
		},
		ft = "ledger",
		config = function()
			local cmp = require("cmp")
			local config = cmp.get_config()
			table.insert(config.sources, {
				name = "hledger",
			})
			cmp.setup(config)
		end,
	},
}
