local buf_write_pre = vim.api.nvim_create_augroup("BufWritePre", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre",{
    pattern = { "*" },
    group = buf_write_pre,
    command = [[%s/\s\+$//e]]
})
