local M = {}

local map = vim.keymap.set

M.dap = function()
	require("which-key").add({
		{ "<leader>d", group = "dap" },
	})

	map("n", "<leader>dd", function()
		local dap = require("dap")
		if dap.session() then
			dap.terminate()
		else
			dap.continue()
		end
	end, { desc = "Toggle debugger" })
	map("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "Toggle breakpoint" })
	map("n", "<leader>dC", require("dap").clear_breakpoints, { desc = "Clear all breakpoints" })
	map("n", "<leader>dB", require("dap").set_exception_breakpoints, { desc = "Filter breakpoints" })
	map("n", "<leader>do", require("dap").step_over, { desc = "Step over" })
	map("n", "<leader>di", require("dap").step_into, { desc = "Step into" })
	map("n", "<leader>dO", require("dap").step_out, { desc = "Step out" })
	map("n", "<leader>du", require("dap").step_back, { desc = "Step back" })
	map("n", "<leader>dp", require("dap").pause, { desc = "Pause thread" })
	map("n", "<leader>dR", require("dap").reverse_continue, { desc = "Reverse until last breakpoint" })
	map("n", "<leader>dc", require("dap").run_to_cursor, { desc = "Execute to cursor" })
	map("n", "<leader>dr", require("dap").repl.toggle, { desc = "Toggle REPL" })
end

return M
