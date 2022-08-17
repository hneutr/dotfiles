local M = {}

function M.autolist()
    chars = vim.b.autolist_chars or {}

	local preceding_line = vim.fn.getline(vim.fn.line(".") - 1)
    vim.g.testing = preceding_line

    if preceding_line:match("^%s*%d+%.%s") then
		local next_list_index = preceding_line:match("%d+") + 1
		vim.fn.setline(".", preceding_line:match("^%s*") .. next_list_index .. ". ")
        vim.api.nvim_input("<esc>A")
        return
    elseif vim.tbl_count(chars) > 0 then
        for _, char in ipairs(chars) do
            local pattern = "^%s*" .. _G.escape(char) .. "%s"
            local matched_content = preceding_line:match(pattern)
            if matched_content then
                vim.fn.setline(".", matched_content)
                vim.api.nvim_input("<esc>A")
                return
            end
        end
	end
end

return M
