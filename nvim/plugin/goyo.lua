vim.g.goyo_height = 90

function goyo_toggle()
    vim.cmd("Goyo")

    if vim.g.goyo_running then
        goyo_stop()
    else
        goyo_start()
    end
end

function goyo_quit()
    vim.cmd("GoyoToggle")
    vim.cmd("quit")
end

function goyo_start()
    vim.g.goyo_running = true

    vim.o.showmode = false
    vim.o.showcmd = false
    vim.wo.spell = true

    vim.keymap.set("n", " q", goyo_quit, {silent = true})
end

function goyo_stop()
    vim.g.goyo_running = false

    vim.o.showmode = true
    vim.o.showcmd = true
    vim.wo.spell = false

    vim.keymap.set("n", " q", ":q<cr>", {silent = true})
end

vim.api.nvim_create_user_command("GoyoToggle", goyo_toggle, {})
