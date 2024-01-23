vim.cmd("syn clear markdownLinkText")

vim.api.nvim_set_hl(0, "@markup.list.markdown", {link = "Function"})
vim.api.nvim_set_hl(0, "@markup.link.label.markdown_inline", {link = "Tag"})
vim.api.nvim_set_hl(0, "@markup.link.url.markdown_inline", {link = "Conceal"})
vim.api.nvim_set_hl(0, "@markup.link.markdown_inline", {link = "Delimiter"})

vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", {link = "Error"})
vim.api.nvim_set_hl(0, "@markup.heading.1.marker.markdown", {link = "Error"})
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", {link = "Constant"})
vim.api.nvim_set_hl(0, "@markup.heading.2.marker.markdown", {link = "Constant"})
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", {link = "Type"})
vim.api.nvim_set_hl(0, "@markup.heading.3.marker.markdown", {link = "Type"})
