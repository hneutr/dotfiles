local nvim_lsp = require('lspconfig')
local map = vim.api.nvim_buf_set_keymap

local on_attach = function(client, buf)
    vim.api.nvim_buf_set_option(buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = {noremap = true, silent = true}
    map(buf, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    map(buf, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    map(buf, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    map(buf, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    map(buf, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    map(buf, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        map(buf, "n", "<space>dlf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end

    if client.resolved_capabilities.document_range_formatting then
        map(buf, "v", "<space>dlf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
end

local servers = { "pylsp" }

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
