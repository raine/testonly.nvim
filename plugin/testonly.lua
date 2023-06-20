if vim.g.loaded_testonly then
	return
end

vim.g.loaded_testonly = true

local map = vim.keymap.set

map("n", "<plug>(testonly-toggle-it)", '<cmd>lua require("testonly").toggle("it")<cr>')
map("n", "<plug>(testonly-toggle-describe)", '<cmd>lua require("testonly").toggle("describe")<cr>')
map(
	"n",
	"<plug>(testonly-reset)",
	'<cmd>lua require("plenary.reload").reload_module("testonly"); require("testonly").reset_all_exclusive()<cr>'
)
