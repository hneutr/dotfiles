luarocks --lua-version 5.1 install --global --server=https://luarocks.org/manifests/hneutr hneutil-lua
luarocks --lua-version 5.1 install --global --server=https://luarocks.org/manifests/hneutr hnetxt-lua

cd $HOME/lib/hnetxt-cli
luarocks --lua-version 5.1 install --server=https://luarocks.org/manifests/hneutr hneutil-lua
luarocks --lua-version 5.1 install --server=https://luarocks.org/manifests/hneutr hnetxt-lua
