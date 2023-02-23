local util = require('util')
local Path = require('util.path')

local aucmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_buf_create_user_command

local p = { "*.md" }

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
        vim.b.list_types = {"item", "reject", "maybe", "question", "tag"}
    end,
})})

--------------------------------------------------------------------------------
--                                  filetype                                  --
--------------------------------------------------------------------------------
aucmd({"BufEnter"}, {pattern=p, once=true, callback=function() require('list').Buffer():set_highlights() end})

--------------------------------------------------------------------------------
--                              general mappings                              --
--------------------------------------------------------------------------------
aucmd({'BufEnter'}, {pattern=p, callback=util.run_once({
    scope = 'b',
    key = 'ft_maps_applied',
    fn = function()
        vim.keymap.set("i", "<cr>", require('list').continue_list_command, {silent = true})
        require('list').Buffer():map_toggles(vim.g.mapleader .. "t")
    end,
})})

--------------------------------------------------------------------------------
--                            general lex commands                            --
--------------------------------------------------------------------------------
local lex_g = vim.api.nvim_create_augroup('lex_cmds', { clear = true })

aucmd({"BufEnter"}, {pattern=p, group=lex_g, callback=require('lex.config').set})

------------------------------------[ sync ]------------------------------------
local sync_g = vim.api.nvim_create_augroup('lex_sync_cmds', { clear = true })
local sync = require('lex.sync')

local function if_sync(fn)
    return function()
        if vim.b.lex_config_path and not vim.b.lex_sync_ignore and not vim.g.lex_sync_ignore then
            fn()
        end
    end
end

aucmd({'BufEnter'}, {pattern=p, group=sync_g, callback=if_sync(sync.buf_enter)})
aucmd({'TextChanged', 'InsertLeave'}, {pattern=p, group=sync_g, callback=if_sync(sync.buf_change)})
aucmd({'BufLeave', 'VimLeave'}, {pattern=p, group=sync_g, callback=if_sync(sync.buf_leave)})

------------------------------------[ lex ]-------------------------------------
aucmd({"BufEnter"}, {pattern=p, group=lex_g, callback=util.run_once({
    scope = 'b',
    key = 'lex_applied', 
    fn = function()
        cmd(0, "Journal", function() util.open_path(require('lex.journal').path()) end, {})

        if vim.b.lex_config_path then
            ------------------------------------[ maps ]------------------------------------
            require('lex.opener').map()

            local args = {silent = true, buffer = true}

            -- fuzzy find stuff
            vim.keymap.set("n", " df", function() require'lex.link'.fuzzy.goto() end, args)
            -- "  is <c-/> (the mapping only works if it's the literal character)
            vim.keymap.set("n", "", function() require'lex.link'.fuzzy.put() end, args)
            vim.keymap.set("i", "", function() require'lex.link'.fuzzy.insert() end, args)

            -- delete the currently selected lines and move them to the scratch file
            vim.keymap.set("n", " s", function() require'lex.scratch'.move('n') end, args)
            vim.keymap.set("v", " s", [[:'<,'>lua require'lex.scratch'.move('v')<cr>]], args)

            ----------------------------------[ commands ]----------------------------------

            cmd(0, "Push", function() require'lex.config'.push() end, {})
            cmd(0, "Goals", function() util.open_path(require'lex.goals'.path()) end, {})
            cmd(0, "Index", function() require'lex.index'.open() end, {})

            ---------------------------------[ statusline ]---------------------------------
            vim.wo.statusline = require('lex.statusline')()
        end
    end
})})
