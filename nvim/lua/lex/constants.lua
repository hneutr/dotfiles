local M = {
    goals_directory = '/Users/hne/Documents/text/written/nonfiction/on-writing/goals',
    journals_directory = '/Users/hne/Documents/text/written/journals/content',
    config_file_name = '.project',
    dir_file_name = '@.md',
    opener_prefix = "<leader>o",
    mirror_defaults = {
        mirrors_dir_prefix = "",
        mirrors = {
            -- chaff
            fragments = {
                opener_prefix = "f",
                dir_prefix = ".chaff/fragments",
                mirror_other_mirrors = false,
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
                mirror_other_mirrors = false,
            },
            outlines = {
                opener_prefix = "o",
                dir_prefix = ".notes/outlines",
                mirror_other_mirrors = false,
            },
            meta = {
                opener_prefix = "m",
                dir_prefix = ".notes/meta",
                mirror_other_mirrors = false,
            },
            questions = {
                opener_prefix = "q",
                dir_prefix = ".notes/questions",
                mirror_other_mirrors = false,
            },
            rejections = {
                opener_prefix = "r",
                dir_prefix = ".notes/rejections",
                mirror_other_mirrors = false,
            },
        },
    },
}

return M
