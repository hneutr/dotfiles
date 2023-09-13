local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_url = 'https://github.com/wbthomason/packer.nvim'
local bootstrap

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', packer_url, install_path})
    vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup(function(use)
    ----------------------------------[ plugins ]-----------------------------------
    use 'wbthomason/packer.nvim'                                        -- plugin manager
    use 'altercation/vim-colors-solarized'                              -- colorscheme
    use 'hneutr/nvimux'                                                 -- tmux replacement
    use 'hneutr/vim-cool'                                               -- it's cool
    use {'junegunn/fzf', run = function() vim.fn['fzf#install']() end } -- fzf
    use 'ibhagwan/fzf-lua'                                              -- fzf-lua
    use 'junegunn/goyo.vim'                                             -- distraction free + centered editing
    use 'wellle/targets.vim'                                            -- more objects
    use({"L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*"})                -- snippets
    use 'windwp/nvim-autopairs'                                         -- close things

    ----------------------------------[ mappings ]----------------------------------
    use 'tpope/vim-commentary'                                          -- toggle comments
    use 'junegunn/vim-easy-align'                                       -- align text at a separator
    use 'justinmk/vim-sneak'                                            -- 2char motions
    use "kylechui/nvim-surround"                                        -- deal with surrounding things
    use 'tpope/vim-unimpaired'                                          -- paired options
    use 'vim-scripts/ReplaceWithRegister'                               -- paste without modifying registers
    use 'zirrostig/vim-schlepp'                                         -- move things up and down
    use 'monaqa/dial.nvim'                                              -- cycle between dates, true/false, etc

    ---------------------------------[ languages ]----------------------------------
    use 'nvim-treesitter/nvim-treesitter'                               -- syntax/indent
    use 'jeetsukumaran/vim-pythonsense'                                 -- python text objects
    use 'sheerun/vim-polyglot'


    use_rocks 'inspect'
    use_rocks 'penlight'
    use_rocks {'lyaml', env = {YAML_DIR = "/opt/homebrew"}}
    use_rocks {'hneutil-lua', server = "https://luarocks.org/manifests/hneutr"}
    use "~/lib/hnetxt-nvim"

    ----------------------------------[ testing ]-----------------------------------

    if bootstrap then
        require('packer').sync()
    end
end)
