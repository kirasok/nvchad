local M = {}

---@type DiffviewConfig
M.diffview = {
	default_args = {
		DiffviewOpen = { "--imply-local" },
	},
}

---@type NeogitConfig
M.neogit = {
	graph_style = "kitty",
	integrations = {
		telescope = true,
		diffview = true,
	},
}

M.blame = {
	focus_blame = true,
	merge_consecutive = true,
	max_summary_width = 30,
}

return M
