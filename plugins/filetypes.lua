---@type NvPluginSpec[]
local plugins = {
	{
		"NvChad/nvim-colorizer.lua",
		ft = { "javascript", "css", "toml", "yaml", "scss" },
		opts = {
			user_default_options = {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = true, -- "Name" codes like Blue or blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				AARRGGBB = true, -- 0xAARRGGBB hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				-- Available modes for `mode`: foreground, background,  virtualtext
				mode = "background", -- Set the display mode.
				-- Available methods are false / true / "normal" / "lsp" / "both"
				-- True is same as normal
				tailwind = true, -- Enable tailwind colors
			},
		},
		config = function(_, opts)
			require("colorizer").setup(opts)
			-- execute colorizer as soon as possible
			vim.defer_fn(function()
				require("colorizer").attach_to_buffer(0)
			end, 0)
		end,
	},

	{
		-- autoclose and autorename html tags
		"windwp/nvim-ts-autotag",
		ft = {
			"astro",
			"glimmer",
			"handlebars",
			"html",
			"javascript",
			"jsx",
			"markdown",
			"php",
			"rescript",
			"svelte",
			"tsx",
			"typescript",
			"vue",
			"xml",
		},
		config = true,
	},

	{
		"luizribeiro/vim-cooklang",
		ft = { "cook" },
	},

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

	{
		"kirasok/vim-klog",
		ft = { "klog" },
	},

	{
		"calops/hmts.nvim",
		ft = "nix",
		version = "*",
	},

	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",
			-- optional
			"nvim-tree/nvim-web-devicons",
		},
		lazy = "leetcode.nvim" ~= vim.fn.argv()[1],
		opts = {
			lang = "python3",
		},
	},

	{
		"akinsho/flutter-tools.nvim",
		ft = "dart",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
}

return plugins
