local aucmd = vim.api.nvim_create_autocmd

local p = { "*.md" }

vim.g.vim_markdown_no_default_key_mappings = 1

local function run_once(fn, key)
    return function()
        if not vim.b[key] then
            fn()
            vim.b[key] = true
        end
    end
end

local function ft_settings()
    vim.wo.conceallevel = 2
    vim.bo.expandtab = true
    vim.bo.commentstring = ">%s"
    vim.bo.textwidth = 0
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
end

--------------------------------------------------------------------------------
--                                  settings                                  --
--------------------------------------------------------------------------------
aucmd({'BufEnter'}, { pattern=p, callback=run_once(ft_settings, 'md_settings_applied') })

--------------------------------------------------------------------------------
--                            general lex commands                            --
--------------------------------------------------------------------------------
local lex_g = vim.api.nvim_create_augroup('lex_cmds', { clear = true })

aucmd({"BufEnter"}, { pattern=p, group=lex_g, callback=require'lex.config'.set })
aucmd({"BufEnter"}, { pattern=p, group=lex_g, callback=run_once(require'lex.opener'.map, 'lex_maps_applied') })

--------------------------------------------------------------------------------
--                                    sync                                    --
--------------------------------------------------------------------------------
local sync_g = vim.api.nvim_create_augroup('lex_sync_cmds', { clear = true })
local sync = require'lex.sync'

local function if_sync(fn)
    return function()
        if vim.b.lex_config_path and not vim.b.lex_sync_ignore and not vim.g.lex_sync_ignore then
            fn()
        end
    end
end

aucmd({'BufEnter'}, { pattern=p, group=sync_g, callback=if_sync(sync.buf_enter) })
aucmd({'TextChanged', 'InsertLeave'}, { pattern=p, group=sync_g, callback=if_sync(sync.buf_change) })
aucmd({'BufLeave', 'VimLeave'}, { pattern=p, group=sync_g, callback=if_sync(sync.buf_leave) })
