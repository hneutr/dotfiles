local ls = require("luasnip")
local ps = ls.parser.parse_snippet

return {
    -- imports
    ps("die", "import sys; sys.exit()\n", {trim_empty = false}),
    ps("idefd", "from collections import defaultdict\n", {trim_empty = false}),
    ps("idefd", "from pathlib import Path\n", {trim_empty = false}),
    ps("ipd", "import pandas as pd\n", {trim_empty = false}),
    ps("inp", "import numpy as np\n", {trim_empty = false}),
    ps("iplt", "import matplotlib.pyplot as plt\n", {trim_empty = false}),
    ps("ism", "import statsmodels.api as sm\n", {trim_empty = false}),
    ps("pp", "import pprint; pp = pprint.PrettyPrinter(); pp.pprint($1)"),
    ps("main", [[
        if __name__ == '__main__':
            $1
    ]]),
    ps("init", "def __init__(self, $1):"),
}
