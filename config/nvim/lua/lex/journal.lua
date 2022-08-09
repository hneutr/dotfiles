local M = {}

function M.path(args)
    args = args or {}
    if args.set_config then
        require'lex.config'.set(vim.env.PWD)
    end

    if not args.journal and vim.b.lex_config_path then
        args.journal = require'lex.config'.get().name
    end

    local this_month = vim.fn.strftime("%Y%m")
    local path = this_month .. ".md"

    if args.journal and args.journal ~= 'catch all' then
        args.journal = args.journal:gsub("%s", "-")
        path = _G.joinpath(args.journal, path)
    end

    return _G.joinpath(require'lex.constants'.journals_directory, path)
end

return M
