Vim�UnDo� �F`?+����Ly["�o��ѦKG4١���8*   $           !                       b�=    _�                             ����                                                                                                                                                                                                                                                                                                                                                             b��    �                Mmap("s", "<Tab>", function() require'luasnip'.jump(1) end, { silent = true })5��                          �      N               5�_�                           ����                                                                                                                                                                                                                                                                                                                                                v       b��    �         %      Ymap({ "i", "s" }, "<S-Tab>", function() require'luasnip'.jump(-1) end, { silent = true })5��                         �                     5�_�                       	    ����                                                                                                                                                                                                                                                                                                                                                v       b��    �         %      Tmap({ "i", , "<S-Tab>", function() require'luasnip'.jump(-1) end, { silent = true })5��       	                  �                     5�_�                       	    ����                                                                                                                                                                                                                                                                                                                                                v       b��    �         %      Smap({ "i" , "<S-Tab>", function() require'luasnip'.jump(-1) end, { silent = true })5��       	                  �                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                                v       b��    �         %      Rmap({ "i", "<S-Tab>", function() require'luasnip'.jump(-1) end, { silent = true })5��                         �                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                                v       b��    �         %      Qmap( "i", "<S-Tab>", function() require'luasnip'.jump(-1) end, { silent = true })5��                         �                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                V       b�A    �         %    �         %    5��                          �              Q       5�_�      	                     ����                                                                                                                                                                                                                                                                                                                                                v       b�E   	 �         &      Pmap("i", "<S-Tab>", function() require'luasnip'.jump(-1) end, { silent = true })5��                        �                    5�_�      
           	          ����                                                                                                                                                                                                                                                                                                                                                v       b�G     �         &      Omap("i", "<ctrl>", function() require'luasnip'.jump(-1) end, { silent = true })5��                         �                     5�_�   	              
          ����                                                                                                                                                                                                                                                                                                                                                v       b�H   
 �         &      Kmap("i", "<>", function() require'luasnip'.jump(-1) end, { silent = true })5��                         �                     5�_�   
                        ����                                                                                                                                                                                                                                                                                                                                                v       b�L    �         &      Nmap("i", "<c-f>", function() require'luasnip'.jump(-1) end, { silent = true })5��       3                 �                    5�_�                       3    ����                                                                                                                                                                                                                                                                                                                                                v       b�L    �         &      Mmap("i", "<c-f>", function() require'luasnip'.jump(0) end, { silent = true })5��       3                 �                    5�_�                           ����                                                                                                                                                                                                                                                                                                                                                v       b�P    �         &      Pmap("i", "<S-Tab>", function() require'luasnip'.jump(-1) end, { silent = true })5��                        �                    5�_�                           ����                                                                                                                                                                                                                                                                                                                               ,          ,       V   ,    b��    �         &    �         &    5��                          e              _       5�_�                            ����                                                                                                                                                                                                                                                                                                                               ,          ,       V   ,    b��    �                ^map('i', "<Tab>", "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", {5��               ^       a         ^       a       5�_�                       !    ����                                                                                                                                                                                                                                                                                                                               ,          ,       V   ,    b��    �         '      ^map('i', "<Tab>", "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", {5��       !                 �                    5�_�                       @    ����                                                                                                                                                                                                                                                                                                                               @          F       v   F    b��    �         '      Vmap('i', "<Tab>", "luasnip#expandable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", {5��       @                 �                    5�_�                       G    ����                                                                                                                                                                                                                                                                                                                               @          F       v   F    b�+    �                a-- map('i', "<Tab>", "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", {5��                                b               5�_�                       "    ����                                                                                                                                                                                                                                                                                                                               @          F       v   F    b�+    �                #-- expand or jump within a snippet.5��                          �      $               5�_�                        *    ����                                                                                                                                                                                                                                                                                                                               @          F       v   F    b�<    �                +    -- delete_check_events = 'InsertLeave',5��                          �       ,               5�_�                           ����                                                                                                                                                                                                                                                                                                                                         ,       v   ,    b�x    �         &      Nmap('i', "<Tab>", "luasnip#ex() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", {5��                        !                    5��