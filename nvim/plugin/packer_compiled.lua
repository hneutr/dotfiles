-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/hne/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/hne/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/hne/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/hne/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/hne/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ReplaceWithRegister = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/ReplaceWithRegister",
    url = "https://github.com/vim-scripts/ReplaceWithRegister"
  },
  fzf = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf-lua"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/fzf-lua",
    url = "https://github.com/ibhagwan/fzf-lua"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/goyo.vim",
    url = "https://github.com/junegunn/goyo.vim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-comment"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/nvim-comment",
    url = "https://github.com/terrortylor/nvim-comment"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-surround"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/nvim-surround",
    url = "https://github.com/kylechui/nvim-surround"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  nvimux = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/nvimux",
    url = "https://github.com/hneutr/nvimux"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["vim-colors-solarized"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/vim-colors-solarized",
    url = "https://github.com/altercation/vim-colors-solarized"
  },
  ["vim-cool"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/vim-cool",
    url = "https://github.com/hneutr/vim-cool"
  },
  ["vim-easy-align"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/vim-easy-align",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/vim-polyglot",
    url = "https://github.com/sheerun/vim-polyglot"
  },
  ["vim-pythonsense"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/vim-pythonsense",
    url = "https://github.com/jeetsukumaran/vim-pythonsense"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-schlepp"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/vim-schlepp",
    url = "https://github.com/zirrostig/vim-schlepp"
  },
  ["vim-sneak"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/vim-sneak",
    url = "https://github.com/justinmk/vim-sneak"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/Users/hne/.local/share/nvim/site/pack/packer/start/vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  }
}

time([[Defining packer_plugins]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
