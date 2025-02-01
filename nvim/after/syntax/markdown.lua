-- vim.cmd("syn clear markdownLinkText")

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

    -- these annoy me
    SpellLocal = {},
    SpellCap = {},
}

for key, val in pairs(syntax) do
    vim.api.nvim_set_hl(0, key, val)
end
