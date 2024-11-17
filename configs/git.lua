local M = {}

M.diffview = {
	default_args = {
		DiffviewOpen = { "--imply-local" },
	},
}

M.neogit = {
	graph_style = "kitty",
	integrations = {
		telescope = true,
		diffview = true,
	},
}

return M
