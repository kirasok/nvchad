local M = {}

M.git_blame = function()
	vim.cmd("highlight default link gitblame SpecialComment")
	return {
		message_template = "<summary> • <date> • <author>",
		date_format = "%r",
	}
end

M.diffview = {
	default_args = {
		DiffviewOpen = { "--imply-local" },
	},
}

M.neogit = {
	integrations = {
		telescope = true,
		diffview = true,
	},
}

return M
