local opts = { noremap=true, silent=true }

local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>jj", harpoon_mark.add_file, { noremap=true, silent=false })
vim.keymap.set("n", "<leader>jh", harpoon_ui.toggle_quick_menu, opts)

vim.keymap.set("n", "<leader>jf", function() harpoon_ui.nav_file(1) end, opts)
vim.keymap.set("n", "<leader>jd", function() harpoon_ui.nav_file(2) end, opts)
vim.keymap.set("n", "<leader>js", function() harpoon_ui.nav_file(3) end, opts)
vim.keymap.set("n", "<leader>ja", function() harpoon_ui.nav_file(4) end, opts)
