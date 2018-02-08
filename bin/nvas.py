#!/usr/local/bin/python3
# nvas.py
from neovim import attach
import os, sys

args = sys.argv[1:]
if not args:
    # print "Usage: {} <filename> ...".format(sys.argv[0])
    sys.exit(1)

addr = os.environ["NVIM_LISTEN_ADDRESS"]
if not addr:
    # TODO: Open a new nvim instance if no addr
    sys.exit(2)

import os.path

import threading
nvim = attach("socket", path=addr)
def normalizePath(name):
    return os.path.abspath(name).replace(" ", "\\ ")

def openFiles():
    # To escape terminal mode. Not sure if bug.
    nvim.feedkeys('', 'n')
    nvim.vars['__autocd_cwd'] = os.getcwd()
    for x in args:
        nvim.command("drop {}".format(normalizePath(x)))
        # nvim.command("doautocmd User")
        # nvim.command('execute "lcd" fnameescape(g:__autocd_cwd)')
        # del nvim.vars['__autocd_cwd']

openFiles()
