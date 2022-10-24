local M = {
    goals_directory = '/Users/hne/Documents/text/written/nonfiction/on-writing/goals',
    journals_directory = '/Users/hne/Documents/text/written/journals/content',
    config_file_name = '.project',
    dir_file_name = '@.md',
    opener_prefix = "<leader>o",
    mirror_defaults = {
        mirrors = {
            -- chaff
            fragments = {
                opener_prefix = "f",
                dir_prefix = ".chaff/fragments",
            },
            scratch = {
                opener_prefix = "s",
                dir_prefix = ".chaff/scratch",
                mirror_other_mirrors = true,
            },
            -- notes
            alternatives = {
                opener_prefix = "a",
                dir_prefix = ".notes/alternatives",
            },
            ideas = {
                opener_prefix = "i",
                dir_prefix = ".notes/ideas",
            },
            outlines = {
                opener_prefix = "o",
                dir_prefix = ".notes/outlines",
            },
            meta = {
                opener_prefix = "m",
                dir_prefix = ".notes/meta",
            },
            questions = {
                opener_prefix = "q",
                dir_prefix = ".notes/questions",
            },
            rejections = {
                opener_prefix = "r",
                dir_prefix = ".notes/rejections",
            },
            churnlog = {
                opener_prefix = "c",
                dir_prefix = ".notes/churnlog",
            },
        },
    },
}

return M
