local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

local p = { "*.md" }

local function md_settings()
  vim.o.ft = 'markdown'
  vim.g.vim_markdown_no_default_key_mappings = 1
  vim.g.file_opening_prefix = "<leader>o"
end

local function md_buf_enter_settings()
  vim.wo.conceallevel = 2
  vim.bo.expandtab = true
  vim.bo.commentstring = ">%s"
  vim.bo.textwidth = 0
  vim.bo.shiftwidth = 2
  vim.bo.softtabstop = 2
end

local function if_lex(fn)
    return function()
        if vim.b.lex_config_path then
            fn()
        end
    end
end


local function if_sync(fn)
    return function()
        if vim.b.lex_config_path and not vim.b.lex_sync_ignore and not vim.g.lex_sync_ignore then
            fn()
        end
    end
end

local lex = augroup('lex_cmds', { clear = true })
local sync = augroup('lex_sync_cmds', { clear = true })

aucmd({"BufEnter"}, { pattern=p, callback=md_settings })
aucmd({"BufEnter"}, { pattern=p, group=lex, callback=require'lex.config'.set })
aucmd({"BufEnter"}, { pattern=p, group=lex, callback=if_lex(require'lex.opener'.map) })

aucmd({'BufEnter'}, { pattern=p, callback=md_buf_enter_settings })

aucmd({'BufEnter'}, { pattern=p, group=sync, callback=if_sync(require'lex.sync'.buf_enter) })
aucmd({'TextChanged', 'InsertLeave'}, { pattern=p, group=sync, callback=if_sync(require'lex.sync'.buf_change) })
aucmd({'BufLeave', 'VimLeave'}, { pattern=p, group=sync, callback=if_sync(require'lex.sync'.buf_leave) })
