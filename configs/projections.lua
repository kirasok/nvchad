M = {
	workspaces = { -- Default workspaces to search for
		"~/Documents",
	},
	store_hooks = {
		pre = function()
			-- nvim-tree
			local nvim_tree_present, api = pcall(require, "nvim-tree.api")
			if nvim_tree_present then
				api.tree.close()
			end
		end,
	},
}

return M
