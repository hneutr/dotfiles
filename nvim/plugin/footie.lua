--[[

Okay. What I want is:
- when I change a header, references to the header get updated
    - ideally this includes references in other documents, but that's for later
- this should work when I do a normal mode command (eg diw) and in insert mode
    - I also want this change to be atomic, because I want it to be:
        - undoable
        - maintain cursor position
    - this implies undoing the change, and then making the change last?

- on init I want to also refs, to update then whenever headers change
- process would be:
    - on init, parse:
        - defs
        - refs
    - on new def:
        - store location
    - on new ref:
        - associate with def, if any

- refs: {`def str`: [loc 1, loc 2, ...]
- defs: {loc: str}

possibly: follow patterns [here](https://gist.github.com/JoosepAlviste/43e03d931db2d273f3a6ad21134b3806):
--]]


local ui = require("htn.ui")

local M = {
    queries = {
        defs = vim.treesitter.query.parse(
            "markdown",
            [[
                (link_reference_definition (link_label)) @footnote
                (atx_heading) @heading
                ]]
        ),
        refs = vim.treesitter.query.parse(
            "markdown_inline",
            [[
                (shortcut_link) @shortcut
                (full_reference_link) @reference
                ]]

        ),
    },
    data = {},
}

function M.print_node(node)
    vim.print({
        text = vim.treesitter.get_node_text(node, 0),
        range = node:range(),
        type = node:type(),
    })
end

function M.get_defs(root)
    local defs = {}
    for id, node in M.queries.defs:iter_captures(root) do
        defs[node:range()] = M.get_def_text(node)
    end

    return defs
end

function M.get_def_text(node)
    local def_type = node:type()

    if def_type == "link_reference_definition" then
        return vim.treesitter.get_node_text(node:child(0), 0)
    elseif def_type == "atx_heading" then
        local text = vim.treesitter.get_node_text(node, 0)

        -- remove metadata notes
        local stop = text:find("[", 1, true) or #text + 1
        text = text:sub(1, stop - 1):strip()

        -- surround with `[]` for updating purposes
        return ("[%s]"):format(text)
    end
end

function M.init(tbl)
    local trees = {
        markdown = vim.treesitter.get_parser(tbl.buf, "markdown"):parse()[1]:root(),
        inline = vim.treesitter.get_parser(tbl.buf, "markdown_inline"):parse()[1]:root(),
    }

    M.data[tbl.buf] = {
        trees = trees,
        defs = M.get_defs(trees.markdown),
        updates = {},
    }
end

function M.onchange(tbl)
    local data = M.data[tbl.buf]

    if not data then return end

    -- only doing single line changes
    local row = vim.api.nvim_buf_get_mark(0, '[')[1] - 1

    local new_def = M.get_def_text(vim.treesitter.get_node({pos = {row, 0}}):parent())

    if not new_def then
        return
    end

    data.updates[new_def] = nil

    local old_def = data.defs[row]

    while old_def and old_def ~= new_def do
        data.updates[old_def], old_def = new_def, data.updates[old_def]
    end

    data.defs[row] = new_def
end

-- TODO: check if there are updates to make!
function M.update_refs()
    local buf = vim.api.nvim_get_current_buf()
    local data = M.data[buf]

    if not data then return end

    local updates = {}
    for id, node in M.queries.refs:iter_captures(data.trees.inline) do
        node = M.queries.refs.captures[id] == "reference" and node:named_child(1) or node

        local new_text = data.updates[vim.treesitter.get_node_text(node, 0)]
        if new_text then
            table.insert(updates, {node = node, text = new_text})
        end
    end

    if #updates > 0 then
        local cursor = ui.get_cursor({buffer = buf})

        -- only call undojoin if in an undo
        local undotree = vim.fn.undotree(buf)
        if undotree.seq_last == undotree.seq_cur then
            vim.cmd("undojoin")
        end

        vim.tbl_map(function(update)
            local start_row, start_col, stop_row, stop_col = update.node:range()
            vim.api.nvim_buf_set_text(0, start_row, start_col, stop_row, stop_col, {update.text})
        end, updates)

        ui.set_cursor({row = cursor.row, col = cursor.col, center = false})
    end

    data.updates = {}
end

-- handle both `shortcut_link` and `full_reference_link`
function M.goto_def()
    local buf = vim.api.nvim_get_current_buf()

    local c = ui.get_cursor({buffer = buf})

    local ref = vim.treesitter.get_node({pos = {c.row - 1, c.col}})
    M.print_node(ref)

    local data = M.data[buf]
end

--[[
update on:
- goto definition
- goto reference (use M.data.defs for the row)
- quit/bufclose etc
--]]

-- todo: call update on quit/bufclose etc
local autocmds = {
    {events = {"BufRead"}, callback = M.init},
    {events = {"TextChanged", "InsertLeave"}, callback = M.onchange},
}

function M.test_fn()
    local buf = vim.api.nvim_get_current_buf()
    vim.print({
        defs = M.data[buf].defs,
        updates = M.data[buf].updates,
    })
end

local keymaps = {
    {mode = {"n"}, lhs = "<leader>u", rhs = M.update_refs, opts = {silent = true, buffer = true}},
    {mode = {"n"}, lhs = "gd", rhs = M.goto_def, opts = {silent = true, buffer = true}},
}

local test = false

if test then
    vim.tbl_map(function(cmd)
        vim.api.nvim_create_autocmd(cmd.events, {pattern = {"*.md"}, callback = cmd.callback})
    end, autocmds)

    vim.tbl_map(function(keymap)
        vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, keymap.opts or {})
    end, keymaps)
end

return M
