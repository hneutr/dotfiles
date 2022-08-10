local M = {
    goals_directory = '/Users/hne/Documents/text/written/nonfiction/on-writing/goals',
    journals_directory = '/Users/hne/Documents/text/written/journals/content',
    config_file_name = '.project',
    dir_file_name = '@.md',
    mirror_defaults = {
        mirrors_dir_prefix = ".mirrors",
        mirrors = {
            fragments = {
                opener_prefix = "f",
                dir_prefix = ".fragments",
                mirror_other_mirrors = false,
            },
            scratch = {
                opener_prefix = "s",
                dir_prefix = ".scratch",
                mirror_other_mirrors = true,
            },
            issues = {
                opener_prefix = "i",
                dir_prefix = ".issues",
                mirror_other_mirrors = false,
            },
            ideas = {
                opener_prefix = "d",
                dir_prefix = "ideas",
                mirror_other_mirrors = false,
            },
            outlines = {
                opener_prefix = "o",
                dir_prefix = "outlines",
                mirror_other_mirrors = false,
            },
            meta = {
                opener_prefix = "x",
                dir_prefix = "meta",
                mirror_other_mirrors = false,
            },
        },
    },
}

return M
