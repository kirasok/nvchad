local Context = require("render-markdown.core.context")
local List = require("render-markdown.lib.list")
local state = require("render-markdown.state")
local treesitter = require("render-markdown.core.treesitter")

local Base = require("render-markdown.render.base")
local Str = require("render-markdown.lib.str")

---@class render.md.render.Shortcut: render.md.Renderer
local Render = setmetatable({}, Base)
Render.__index = Render

---@return boolean
function Render:setup()
	return true
end

function Render:render()
	local line = self.node:line("first", 0)
	if line ~= nil and line:find("[" .. self.node.text .. "]", 1, true) ~= nil then
		self:wiki_link()
		return
	end
end

---@private
function Render:wiki_link()
	---@return string? message
	-- Matches node and diagnostic
	local function get_from_diagnostics()
		local buf = self.node.buf
		local col = self.node.start_col - 1
		local row = self.node.start_row
		local diagnostic = vim.diagnostic.get(buf)
		for _, value in pairs(diagnostic) do
			if value["severity"] == vim.diagnostic.severity.HINT and value["col"] == col and value["lnum"] == row then
				return value["message"]
			end
		end
		return nil
	end

	local parts = Str.split(self.node.text:sub(2, -2), "|")
	local link_component = self:link_component(parts[1])
	local icon, highlight = self.config.link.wiki.icon, self.config.link.wiki.highlight
	if link_component ~= nil then
		icon, highlight = link_component.icon, link_component.highlight
	end
	local link_text = icon
	if #parts == 1 then -- #parts > 1 indicate that there is custom title
		link_text = link_text .. (get_from_diagnostics() or parts[#parts])
	else
		link_text = link_text .. parts[#parts]
	end
	local added = self.marks:add("link", self.node.start_row, self.node.start_col - 1, {
		end_row = self.node.end_row,
		end_col = self.node.end_col + 1,
		virt_text = { { link_text, highlight } },
		virt_text_pos = "inline",
		conceal = "",
	})

	if added then
		self.context:add_offset(self.node, Str.width(link_text) - Str.width(self.node.text))
	end
end

local Handler = {}
Handler.__index = Handler

function Handler.new(buf)
	local self = setmetatable({}, Handler)
	self.config = state.get(buf)
	self.context = Context.get(buf)
	self.marks = List.new_marks(self.context.mode, self.config.anti_conceal.ignore)
	self.query = treesitter.parse("markdown_inline", "(shortcut_link) @shortcut")
	self.renderers = {
		shortcut = Render,
	}
	return self
end

function Handler:parse(root)
	self.context:query(root, self.query, function(capture, node)
		local renderer = self.renderers[capture]
		assert(renderer ~= nil, "Unhandled inline capture: " .. capture)
		local render = renderer:new(self.marks, self.config, self.context, node)
		if render:setup() then
			render:render()
		end
	end)
	return self.marks:get()
end

local M = {}

M.extends = true
function M.parse(root, buf)
	return Handler.new(buf):parse(root)
end

return M
