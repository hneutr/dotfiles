local ls = require"luasnip"

ls.config.set_config({
    -- ensure tab behaves normally outside snips
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave',
})

local snips_dir = _G.joinpath(vim.g.vim_config, 'snips')

--------------------------------------------------------------------------------
--                            loading ft snips                                --
--------------------------------------------------------------------------------
function load_ft_snips()
    for i, path in ipairs(vim.fn.readdir(snips_dir)) do
        path = _G.joinpath(snips_dir, path)
        if vim.fn.filereadable(path) > 0 then
            vim.cmd("source " .. path)
        end
    end
end

load_ft_snips()
