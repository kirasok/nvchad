local previewers = require("telescope.previewers")
local builtin = require("telescope.builtin")
local git_diff = previewers.new_termopen_previewer({
	get_command = function(entry)
		return {
			"git",
			"diff",
			entry.value .. "^!",
			"--",
			entry.current_file,
		}
	end,
})
local previewer = {
	git_diff,
	previewers.git_commit_message.new({}),
	previewers.git_commit_diff_as_was.new({}),
}

local my_git_bcommits = function(opts)
	opts = opts or {}
	opts.previewer = previewer
	builtin.git_bcommits(opts)
end

local my_git_commits = function(opts)
	opts = opts or {}
	opts.previewer = previewer
	builtin.git_commits(opts)
end

return {
	git_commits = my_git_commits,
	git_bcommits = my_git_bcommits,
	keys = { {
		"<leader>gb",
		my_git_bcommits,
		desc = "File history",
	} },
}
