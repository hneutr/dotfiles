return {
    goals_directory = '/Users/hne/Documents/text/written/nonfiction/on-writing/goals',
    journals_directory = '/Users/hne/Documents/text/written/journals/content',
    config_file_name = '.project',
    dir_file_name = '@.md',
    opener_prefix = "<leader>o",
    mirror_defaults = {
        chaff = {
            dir = ".chaff",
            mirrors = {
                fragments = {opener_prefix = "f"},
                scratch = {opener_prefix = "s", mirror_other_mirrors = true},
            },
        },
        notes = {
            dir = ".notes",
            mirrors = {
                alternatives = {opener_prefix = "a"},
                ideas = {opener_prefix = "i"},
                outlines = {opener_prefix = "o"},
                meta = {opener_prefix = "m"},
                questions = {opener_prefix = "q"},
                rejections = {opener_prefix = "r"},
                churnlog = {opener_prefix = "c"},
            },
        },
    },
}
