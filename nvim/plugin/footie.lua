local M = {}

local queries = {
    locations = vim.treesitter.query.parse(
        "markdown",
        [[
            (link_reference_definition (link_label)) @footnote
            (atx_heading) @heading
        ]]
    ),
    references = vim.treesitter.query.parse(
        "markdown_inline",
        [[
            (shortcut_link) @shortcut
            (full_reference_link) @reference
        ]]

    ),
}

local data = {}

function print_node(node)
    vim.print({
        id = node:id(),
        text = vim.treesitter.get_node_text(node, 0),
        symbol = node:symbol(),
        range = {node:range()},
        type = node:type(),
    })
end

function M.get_locations()
    local root = vim.treesitter.get_parser():trees()[1]:root()

    local locations = {}
    for id, node in queries.locations:iter_captures(root) do
        locations[node:range()] = M.get_location_text(node, queries.locations.captures[id])
    end

    return locations
end

function M.get_location_text(node, capture)
    if capture == "footnote" then
        return vim.treesitter.get_node_text(node:child(0), 0)
    elseif capture == "heading" then
        local text = vim.treesitter.get_node_text(node, 0)

        -- remove metadata notes
        local stop = text:find("[", 1, true) or #text + 1
        text = text:sub(1, stop - 1):strip()

        -- add surrounding `[]` for easy of replacement
        return ("[%s]"):format(text)
    end

    return vim.treesitter.get_node_text(node, 0)
end

function M.update_location_references(old, new)
    local root = vim.treesitter.get_parser(0, "markdown_inline"):trees()[1]:root()

    local nodes = {}
    for id, node in queries.references:iter_captures(root) do
        node = queries.references.captures[id] == "reference" and node:named_child(1) or node

        if vim.treesitter.get_node_text(node, 0) == old then
            table.insert(nodes, node)
        end
    end

    if #nodes > 0 then
        vim.cmd("undojoin")

        vim.tbl_map(function(node)
            local start_row, start_col, stop_row, stop_col = node:range()
            vim.api.nvim_buf_set_text(0, start_row, start_col, stop_row, stop_col, {new})
        end, nodes)
    end
end

vim.api.nvim_create_autocmd(
    "BufRead",
    {
        pattern = {"*.md"},
        callback = function(tbl)
            data[tbl.buf] = M.get_locations()
        end,
    }
)

vim.api.nvim_create_autocmd(
    {"TextChanged", "InsertLeave"},
    {
        pattern = {"*.md"},
        callback = function(tbl)
            if not tbl.buf or not data[tbl.buf] then
                return
            end

            if vim.api.nvim_buf_get_mark(0, '[')[1] ~= vim.api.nvim_buf_get_mark(0, ']')[1] then
                return
            end

            local row = vim.api.nvim_win_get_cursor(0)[1] - 1
            local old_location = data[tbl.buf][row]

            data[tbl.buf] = M.get_locations()
            local new_location = data[tbl.buf][row]

            if old_location and new_location and old_location ~= new_location then
                M.update_location_references(old_location, new_location)
            end
        end
    }
)

return M
