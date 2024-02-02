local lsp = require("lspconfig")
local coq = require("coq")
local rust_tools = require("rust-tools")

vim.lsp.set_log_level "trace"
require("vim.lsp.log").set_format_func(vim.inspect)

local setup_highlight_under_cursor = function(bufnr)
  vim.cmd [[
    hi! LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
    hi! LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
    hi! LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
  ]]
  vim.api.nvim_create_augroup("lsp_document_highlight", {
    clear = false
  })
  vim.api.nvim_clear_autocmds({
    buffer = bufnr,
    group = "lsp_document_highlight",
  })
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = "lsp_document_highlight",
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = "lsp_document_highlight",
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
  -- if client.server_capabilities.document_highlight then
  if client.server_capabilities.documentHighlightProvider then
      setup_highlight_under_cursor(bufnr)
  end
end


lsp.pyright.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
    cmd = cmd,
})
rust_tools.setup{
    inlay_hints = {
        auto = false,
        only_current_line = true,
    },
    server = {
        on_attach = on_attach,
    }
}
lsp.gopls.setup{
    on_attach = on_attach,
    cmd = cmd,
}
lsp.lua_ls.setup{
    on_attach = on_attach,
    cmd = cmd,
}
