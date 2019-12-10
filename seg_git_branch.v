
module main

fn get_branch() string{
    ret := exec_git_cmd("git status -sb --ignore-submodules")
    status := ret.split("\n")
    if status.len == 0 {
        return ""
    }

    branch := status[0].trim("#").trim_space()

    return if branch.contains("...") {
        branch[..branch.index(".")]
    } else {
        branch
    }
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
