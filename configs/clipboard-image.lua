M = {
	default = {
		img_dir = { "%:p:h", "static" }, -- Relative to current file
	},
	markdown = {
		img_dir = { "%:p:h", "static" },
		img_dir_txt = "static",
		affix = "![clipboard_img](%s)",
	},
}

return M
