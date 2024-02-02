local telescope = require("telescope.builtin")
local opts = { noremap=true, silent=true }

local live_grep_current_word = function()
    telescope.grep_string({search = vim.fn.expand("<cword>")})
end
local live_grep_current_WORD = function()
    telescope.grep_string({search = vim.fn.expand("<cWORD>")})
end

vim.keymap.set("n", "<leader>rg", telescope.live_grep, opts)
vim.keymap.set("n", "<leader>fw", live_grep_current_word, opts)
vim.keymap.set("n", "<leader>fW", live_grep_current_WORD, opts)
vim.keymap.set("n", "<leader>ff", telescope.find_files, opts)
vim.keymap.set("n", "<leader>bb", telescope.buffers, opts)
vim.keymap.set("n", "<leader>ft", telescope.help_tags, opts)
vim.keymap.set("n", "<leader>E", telescope.diagnostics, opts)
