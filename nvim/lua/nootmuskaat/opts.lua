vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- vim.opt.expandtab = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.cmd("filetype plugin indent on")

vim.g.mapleader = " "

vim.opt.mouse = ""

vim.g.coq_settings = { auto_start = "shut-up" }  -- must preceed require

vim.opt.swapfile = false
vim.opt.updatetime = 500  -- ms

vim.opt.cursorline = true
