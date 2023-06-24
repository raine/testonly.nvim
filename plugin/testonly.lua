if vim.g.loaded_testonly then
	return
end

vim.g.loaded_testonly = true

local map = vim.keymap.set

map("n", "<Plug>(testonly-toggle-it)", '<cmd>lua require("testonly").toggle("it")<cr>')
map("n", "<Plug>(testonly-toggle-describe)", '<cmd>lua require("testonly").toggle("describe")<cr>')
map(
	"n",
	"<Plug>(testonly-reset)",
	'<cmd>lua require("plenary.reload").reload_module("testonly"); require("testonly").reset_all_exclusive()<cr>'
)
