
module main

struct Theme {
    default_bg int
    default_fg int

    user_bg int
    user_fg int

    cwd_bg int
    cwd_fg int

    git_master_bg int
    git_master_fg int
    git_branch_bg int
    git_branch_fg int

    git_staged_bg int
    git_staged_fg int
    git_unstaged_bg int
    git_unstaged_fg int
    git_untracked_bg int
    git_untracked_fg int
    git_ahead_bg int
    git_ahead_fg int

    cmd_s_bg int
    cmd_s_fg int
    cmd_f_bg int
    cmd_f_fg int

}

const (
    theme = Theme{
        default_bg: 237
        default_fg: 255
        user_bg: 153
        user_fg: 238
        cwd_bg: 237
        cwd_fg: 255
        git_master_bg: 75
        git_master_fg: 238
        git_branch_bg: 65
        git_branch_fg: 238
        git_staged_bg: 120
        git_staged_fg: 238
        git_unstaged_bg: 213
        git_unstaged_fg: 238
        git_untracked_bg: 88
        git_untracked_fg: 255
        git_ahead_bg: 237
        git_ahead_fg: 255
        cmd_s_bg: 77
        cmd_s_fg: 238
        cmd_f_bg: 126
        cmd_f_fg: 238
    }
)
