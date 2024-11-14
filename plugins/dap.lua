local dap_ft = { "dap-repl", "dapui_watches", "dapui_hover" }
local mappings = require("mappings.dap")
local configs = require("configs.dap")

---@type NvPluginSpec[]
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
				config = function(_, opts)
					require("dapui").setup(opts)
				end,
			},
			{
				"theHamsta/nvim-dap-virtual-text",
				dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
				config = true,
			},
		},
		config = function(_, opts)
			mappings.dap()
			configs.dap(_, opts)
		end,
	},

	{
		"rcarriga/cmp-dap",
		dependencies = { "mfussenegger/nvim-dap", "hrsh7th/nvim-cmp" },
		ft = dap_ft,
		config = function(_, opts)
			require("cmp").setup({
				enabled = function()
					return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
				end,
			})
			require("cmp").setup.filetype(dap_ft, {
				sources = {
					{ name = "dap" },
				},
			})
		end,
	},
	{
		"LiadOz/nvim-dap-repl-highlights",
		ft = dap_ft,
		dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
		config = function(_, opts)
			require("nvim-dap-repl-highlights").setup()
		end,
	},
}
