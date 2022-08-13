-- allow removing tabs when they are uneven
vim.g["Schlepp#allowSquishingLines"] = 1
vim.g["Schlepp#allowSquishingBlocks"] = 1

-- reindent when moving
vim.g["Schlepp#reindent"] = 1

vim.keymap.set("v", "<up>", "<Plug>SchleppUp", {})
vim.keymap.set("v", "<down>", "<Plug>SchleppDown", {})
