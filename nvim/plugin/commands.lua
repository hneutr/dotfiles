local commands = {
    OpenVSplitTerminals = function()
        vim.cmd("silent terminal")
        vim.api.nvim_input('<esc>')
        vim.cmd("silent vsplit")
        vim.cmd("silent terminal")
        vim.api.nvim_input('<C-h>')
    end,
    Session = {
        fn = function(opts)
            local action = #opts.fargs == 0 and "save" or opts.fargs[1]

            if not vim.tbl_contains({"save", "load"}, action) then
                return
            end

            local session_name = vim.fn.environ().PWD:gsub("/", "__dir__") .. ".vim"
            local path = Conf.paths.sessions_dir / session_name

            if action == "load" and not path:exists() then
                return
            end

            local cmd = ("%s %s"):format(
                action == "save" and "mksession!" or "source",
                tostring(path)
            )

            vim.cmd(cmd)
        end,
        opts = {
            nargs = "?",
            desc = "save/load a session",
            complete = function(lead)
                return vim.tbl_filter(function(operation)
                    return vim.startswith(operation, lead)
                end, {"load", "save"})
            end,

        },
    },
}

for name, cmd in pairs(commands) do
    cmd = type(cmd) == "function" and {fn = cmd} or cmd
    vim.api.nvim_buf_create_user_command(0, name, cmd.fn, cmd.opts or {})
end
