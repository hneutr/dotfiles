" https://github.com/m00qek/plugin-template.nvim/tree/main/test

set rtp^=./vendor/plenary.nvim/
set rtp^=../

runtime plugin/plenary.vim

lua require('plenary.busted')
