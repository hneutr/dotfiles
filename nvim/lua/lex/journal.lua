local path = require('util.path')

local M = {}

function M.path(args)
    args = args or {}
    local set_config = args.set_config

    local journal_name = args.journal_name
    local journals_dir = require('lex.constants').journals_directory

    local this_month = vim.fn.strftime("%Y%m")
    local journal_file = this_month .. ".md"

    require('lex.config').set(vim.env.PWD)

    if vim.b.lex_config_path then
        journals_dir = path.join(require('lex.config').get().root, '.journal')
    end

    return path.join(journals_dir, journal_file)
end

return M
