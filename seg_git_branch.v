
module main

fn get_branch() string{
    ret := exec_git_cmd("git rev-parse --abbrev-ref HEAD")
    return ret
}

fn seg_git_branch(arg Arg) Segment {
    branch := get_branch()
    mut bg := theme.git_branch_bg
    mut fg := theme.git_branch_fg
    if branch == "master" {
        bg = theme.git_master_bg
        fg = theme.git_master_fg
    }
    return Segment {
        name: "git_branch"
        content: branch
        space: true
        bg: bg
        fg: fg
    }
}
