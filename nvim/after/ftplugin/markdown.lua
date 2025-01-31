vim.opt_local.autoindent = false
vim.opt_local.cindent = false

vim.opt_local.commentstring = "> %s"
vim.opt_local.linebreak = true

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2

vim.opt_local.textwidth = 0

vim.opt_local.smoothscroll = true

vim.cmd("syn clear markdownLinkText")
vim.cmd([[highlight clear SpellLocal]])
vim.cmd([[highlight clear SpellCap]])

local syntax = {
    -- bold
    ["@markup.strong.markdown_inline"] = {bold = true},

    -- italic
    ["@markup.italic.markdown_inline"] = {italic = true},

    -- lists
    ["markdownListMarker"] = {link = "Function"},
    ["@markup.list.markdown"] = {link = "Function"},

    -- links
    ["@markup.link.label.markdown_inline"] = {link = "Tag"},
    ["@markup.link.url.markdown_inline"] = {link = "Conceal"},
    ["@markup.link.markdown_inline"] = {link = "Delimiter"},

    -- quotes
    ["@markup.quote.markdown"] = {bold = false, link = "FloatTitle"},

    -- breaks
    ["RenderMarkdownDash"] = {link = "Function"},
    ["@punctuation.special.markdown"] = {link = "Function"},

    -- don't add highlights for "indented" code
    ["@markup.raw.block.markdown"] = {link = "@spell"},
}

for key, val in pairs(syntax) do
    vim.api.nvim_set_hl(0, key, val)
end
