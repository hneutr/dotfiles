local util = require('util')
local aucmd = vim.api.nvim_create_autocmd

local p = { "*.md" }

--------------------------------------------------------------------------------
--                                  filetype                                  --
--------------------------------------------------------------------------------
aucmd({"BufEnter"}, {pattern = p, once = true, callback = require('lex.list').highlight_items})

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

----------------------------------[ mappings ]----------------------------------
aucmd({"BufEnter"}, {pattern=p, group=lex_g, callback=util.run_once({
    scope = 'b',
    key = 'lex_maps_applied', 
    fn = function()
        if vim.b.lex_config_path then
            require('lex.opener').map()
            require('lex.list').map_item_toggles(vim.g.mapleader .. "t")
            vim.b.list_types = {"question", "maybe"}

            local args = {silent = true, buffer = true}

            -- fuzzy find stuff
            vim.keymap.set("n", " df", function() require'lex.link'.fuzzy.goto() end, args)
            -- "  is <c-/> (the mapping only works if it's the literal character)
            vim.keymap.set("n", "", function() require'lex.link'.fuzzy.put() end, args)
            vim.keymap.set("i", "", function() require'lex.link'.fuzzy.insert() end, args)

            -- delete the currently selected lines and move them to the scratch file
            vim.keymap.set("n", " s", function() require'lex.scratch'.move('n') end, args)
            vim.keymap.set("v", " s", [[:'<,'>lua require'lex.scratch'.move('v')<cr>]], args)
        end

        vim.keymap.set("i", "<cr>", [[<cr><cmd>lua require('list').autolist()<cr>]], {buffer = true})
    end
})})

----------------------------------[ commands ]----------------------------------
aucmd({"BufEnter"}, {pattern=p, group=lex_g, callback=util.run_once({
    scope = 'b',
    key = 'lex_cmds_applied', 
    fn = function()
        local cmd = vim.api.nvim_buf_create_user_command
        local journal = require('lex.journal')

        cmd(0, "Push", function() require'lex.config'.push() end, {})
        cmd(0, "Journal", function() util.open_path(journal.path{journal = 'catch all'}) end, {})
        cmd(0, "PJournal", function() util.open_path(journal.path()) end, {})
        cmd(0, "WJournal", function() util.open_path(journal.path{journal = 'on writing'}) end, {})
        cmd(0, "Goals", function() util.open_path(require'lex.goals'.path()) end, {})
        cmd(0, "Index", function() require'lex.index'.open() end, {})
    end
})})
