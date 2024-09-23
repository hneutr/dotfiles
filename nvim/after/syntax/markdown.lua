vim.cmd("syn clear markdownLinkText")

Dict({
    -- lists
    ["markdownListMarker"] = {link = "Function"},
    ["@markup.list.markdown"] = {link = "Function"},

    -- links
    ["@markup.link.label.markdown_inline"] = {link = "Tag"},
    ["@markup.link.url.markdown_inline"] = {link = "Conceal"},
    ["@markup.link.markdown_inline"] = {link = "Delimiter"},

    -- quotes
    ["@markup.quote.markdown"] = {italic = true, bold = false},

    -- headings
    ["@markup.heading.1.markdown"] = {link = "Error"},
    ["@markup.heading.1.marker.markdown"] = {link = "Error"},
    ["@markup.heading.2.markdown"] = {link = "Constant"},
    ["@markup.heading.2.marker.markdown"] = {link = "Constant"},
    ["@markup.heading.3.markdown"] = {link = "Type"},
    ["@markup.heading.3.marker.markdown"] = {link = "Type"},

    -- breaks
    ["RenderMarkdownDash"] = {link = "Function"},
    ["@punctuation.special.markdown"] = {link = "Function"},
}):foreach(function(key, val)
    vim.api.nvim_set_hl(0, key, val)
end)
