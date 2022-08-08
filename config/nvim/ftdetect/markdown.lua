local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

local p = { "*.md" }

local function md_settings()
  vim.o.ft = 'markdown'
  vim.g.vim_markdown_no_default_key_mappings = 1

  vim.g.config_file_name = '.project'
  vim.g.mirror_defaults_path = "/Users/hne/Documents/research/hnetext/data/mirror-defaults.json"
  vim.g.file_opening_prefix = "<leader>o"

  require'lex.config'.file.mirror_defaults.set()
end

local function md_buf_enter_settings()
  vim.wo.conceallevel = 2
  vim.bo.expandtab = true
  vim.bo.commentstring = ">%s"
  vim.bo.textwidth = 0
end

local function if_lex(fn)
  return function()
    if vim.b.lex_config_path then
      fn()
    end
  end
end

local lex = augroup('lex_cmds', { clear = true })

aucmd({"BufNewFile", "BufRead"}, { pattern=p, callback=md_settings })
aucmd({"BufNewFile", "BufRead"}, { pattern=p, group=lex, callback=require'lex.config'.set })
aucmd({"BufNewFile", "BufRead"}, { pattern=p, group=lex, callback=if_lex(require'lex.opener'.map) })

aucmd({'BufEnter'}, { pattern=p, callback=md_buf_enter_settings })
aucmd({'BufEnter'}, { pattern=p, group=lex, callback=if_lex(require'lex.sync'.buf_enter) })
aucmd({'TextChanged', 'InsertLeave'}, { pattern=p, group=lex, callback=if_lex(require'lex.sync'.buf_change) })
aucmd({'BufLeave', 'VimLeave'}, { pattern=p, group=lex, callback=if_lex(require'lex.sync'.buf_leave) })