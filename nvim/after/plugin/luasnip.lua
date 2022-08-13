local snip_utils = require'snips'

vim.api.nvim_create_autocmd({'BufEnter'}, {pattern="*", callback=function()
    local filetypes_with_standard_snips_loaded = vim.tbl_get(vim.g, 'filetypes_with_standard_snips_loaded') or {} 

    local filetype = vim.bo.filetype

    if not vim.tbl_get(filetypes_with_standard_snips_loaded, filetype) then
        local commentstring = string.gsub(vim.bo.commentstring, "%s?%%s$", '')
        snip_utils.load_standard_snips_for_filetype(filetype, commentstring)

        filetypes_with_standard_snips_loaded[filetype] = true
        vim.g.filetypes_with_standard_snips_loaded = filetypes_with_standard_snips_loaded
    end
end})
