local ls = require"luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {
    -- imports
    s("die", { t("import sys; sys.exit()") }),
    s("idefd", { t("from collections import defaultdict") }),
    s("ipath", { t("from pathlib import Path") }),
    s("ipd", { t("import pandas as pd") }),
    s("inp", { t("import numpy as np") }),
    s("iplt", { t("import matplotlib.pyplot as plt") }),
    s("ism", { t("import statsmodels.api as sm") }),
    -- misc
    s("main", {
        t{"if __name__ == '__main__':",
        "    "}, i(1),
    }),
    s("init", { t("def __init__(self, "), i(1), t("):") }),
    s("pp", { t("import pprint; pp = pprint.PrettyPrinter(); pp.pprint("), i(1), t(")") }),
})
