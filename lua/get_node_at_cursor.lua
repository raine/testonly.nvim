local api = vim.api
local parsers = require("nvim-treesitter.parsers")
local ts = vim.treesitter
local ts_utils = require("nvim-treesitter.ts_utils")

-- This function is copy paste from
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/ts_utils.lua
-- with the only difference being that on the line where cursor_range is
-- defined, the column is set to 0.
--
-- This is because the node that the stock get_node_at_cursor returns if cursor
-- is on a comment will be of type "source" and getting its parent with
-- node:parent() will always return nil. This is a problem because
-- find_parent_test_block_node in testonly.lua uses node:parent() to find
-- closest it/describe block from cursor. Simplest workaround I found is to
-- read node at cursor so that the column is assumed to be 0. This should work
-- virtually always because inside it/describe blocks everything is indented.
--
-- Rest of the function is unchanged because I don't understand what it does.
local function get_node_at_cursor(winnr, ignore_injected_langs)
	winnr = winnr or 0
	local cursor = api.nvim_win_get_cursor(winnr)
	-- Column is 0 always
	local cursor_range = { cursor[1] - 1, 0 }

	local buf = vim.api.nvim_win_get_buf(winnr)
	local root_lang_tree = parsers.get_parser(buf)
	if not root_lang_tree then
		return
	end

	local root ---@type TSNode|nil
	if ignore_injected_langs then
		for _, tree in ipairs(root_lang_tree:trees()) do
			local tree_root = tree:root()
			if tree_root and ts.is_in_node_range(tree_root, cursor_range[1], cursor_range[2]) then
				root = tree_root
				break
			end
		end
	else
		root = ts_utils.get_root_for_position(cursor_range[1], cursor_range[2], root_lang_tree)
	end

	if not root then
		return
	end

	return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
end

return get_node_at_cursor
