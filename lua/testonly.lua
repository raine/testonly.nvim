local M = {}

local ts_utils = require("nvim-treesitter.ts_utils")
local ns_id = vim.api.nvim_create_namespace("TestOnlyHighlight")
local get_node_at_cursor = require("get_node_at_cursor")

-- For debugging nodes
---@diagnostic disable-next-line: unused-function, unused-local
local function highlight_node(node)
	local bufnr = vim.api.nvim_get_current_buf()
	local start_row, start_col, end_row, end_col = node:range()
	vim.api.nvim_buf_set_extmark(bufnr, ns_id, start_row, start_col, {
		end_line = end_row,
		end_col = end_col,
		hl_group = "Error",
	})
end

local function toggle_test_exclusive(node)
	local bufnr = vim.api.nvim_get_current_buf()
	local node_text = vim.treesitter.get_node_text(node, bufnr)
	local start_row, start_col, end_row, end_col = node:range()

	local replacements = {
		it = { "it.only" },
		["it.only"] = { "it" },
		describe = { "describe.only" },
		["describe.only"] = { "describe" },
	}
	local replacement = replacements[node_text]
	assert(replacement, "Replacement for '" .. node_text .. "' not found!")

	vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, replacement)
end

local function find_parent_test_block_node(block_type)
	local bufnr = vim.api.nvim_get_current_buf()
	local node = get_node_at_cursor()

	while node do
		-- Matches for example it(...) and it.only(...)
		if node:type() == "call_expression" then
			local child = node:named_child(0)

			if child then
				local text = vim.treesitter.get_node_text(child, bufnr)
				if text == block_type or text == block_type .. ".only" then
					return child
				end
			end
		end

		node = node:parent()
	end
end

local function toggle_parent_block_exclusive(type)
	local node = find_parent_test_block_node(type)
	if node then
		toggle_test_exclusive(node)
	end
end

-- Probably overkill to use treesitter for this
local function reset_all_exclusive()
	local bufnr = vim.api.nvim_get_current_buf()

	-- This query matches expressions like:
	-- it.only(() => { ... })
	local query = [[
	  (call_expression
	    function: (member_expression
	      object: (identifier)
	      property: (property_identifier))
	    arguments: (arguments (arrow_function))
	  ) @call
  ]]

	local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
	local lang = vim.treesitter.language.get_lang(filetype)
	assert(lang, "Language not found for filetype: " .. filetype)

	local parsed_query = vim.treesitter.query.parse(lang, query)
	local parser = vim.treesitter.get_parser(bufnr)
	local root = parser:parse()[1]:root()
	local start_row, _, end_row, _ = root:range()

	for id, node, _ in parsed_query:iter_captures(root, bufnr, start_row, end_row) do
		if parsed_query.captures[id] == "call" then
			local first_child = node:named_child(0)
			if first_child then
				local text = vim.treesitter.get_node_text(first_child, bufnr)

				if text == "it.only" or text == "describe.only" then
					toggle_test_exclusive(first_child)
				end
			end
		end
	end
end

function M.toggle(type)
	toggle_parent_block_exclusive(type)
end

function M.reset_all_exclusive()
	reset_all_exclusive()
end

return M
