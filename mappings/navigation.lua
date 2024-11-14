local M = {}

---@type LazyKeymaps[]
M.nvim_spider = {
	{
		"e",
		"<cmd>lua require('spider').motion('e')<CR>",
		mode = { "n", "o", "x" },
		desc = "Spider-e",
	},
	{
		"w",
		"<cmd>lua require('spider').motion('w')<CR>",
		mode = { "n", "o", "x" },
		desc = "Spider-w",
	},
	{
		"b",
		"<cmd>lua require('spider').motion('b')<CR>",
		mode = { "n", "o", "x" },
		desc = "Spider-b",
	},
}

---@type LazyKeymaps[]
M.flash = {
	{
		"s",
		mode = { "n", "x", "o" },
		function()
			require("flash").jump()
		end,
		desc = "Flash",
	},
	{
		"S",
		mode = { "n", "x", "o" },
		function()
			require("flash").treesitter()
		end,
		desc = "Flash Treesitter",
	},
	{
		"r",
		mode = "o",
		function()
			require("flash").remote()
		end,
		desc = "Remote Flash",
	},
	{
		"R",
		mode = { "o", "x" },
		function()
			require("flash").treesitter_search()
		end,
		desc = "Treesitter Search",
	},
	{
		"<c-s>",
		mode = { "c" },
		function()
			require("flash").toggle()
		end,
		desc = "Toggle Flash Search",
	},
}

---@type LazyKeymaps[]
M.yazi = {
	{
		-- Open in the current working directory
		"<leader>e",
		function()
			require("yazi").yazi()
		end,
		desc = "yazi open",
	},
	{
		-- Open in the current working directory
		"<leader>E",
		function()
			require("yazi").yazi(nil, vim.fn.getcwd())
		end,
		desc = "yazi cwd",
	},
}

return M
