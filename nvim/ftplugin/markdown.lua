local util = require('util')

local aucmd = vim.api.nvim_create_autocmd

local p = {"*.md"}

--------------------------------------------------------------------------------
--                                  settings                                  --
--------------------------------------------------------------------------------
aucmd({'BufEnter'}, {pattern=p, callback=util.run_once({
    scope = 'b',
    key = 'ft_opts_applied',
    fn = function()
        vim.wo.conceallevel = 2
        vim.wo.linebreak = true
        vim.bo.expandtab = true
        vim.bo.commentstring = ">%s"
        vim.bo.textwidth = 0
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
    end,
})})

--------------------------------------------------------------------------------
--                            general lex commands                            --
--------------------------------------------------------------------------------
------------------------------------[ sync ]------------------------------------
local sync_g = vim.api.nvim_create_augroup('lex_sync_cmds', { clear = true })
local sync = require('lex.sync')

local function if_sync(fn)
    return function()
        if vim.b.hnetxt_project_root and not vim.b.lex_sync_ignore and not vim.g.lex_sync_ignore then
            fn()
        end
    end
end

aucmd({'BufEnter'}, {pattern=p, group=sync_g, callback=if_sync(sync.buf_enter)})
aucmd({'TextChanged', 'InsertLeave'}, {pattern=p, group=sync_g, callback=if_sync(sync.buf_change)})
aucmd({'BufLeave', 'VimLeave'}, {pattern=p, group=sync_g, callback=if_sync(sync.buf_leave)})
