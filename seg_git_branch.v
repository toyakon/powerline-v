
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
    return Segment {
        name: "git_branch"
        content: get_branch()
        space: true
        bg: git_master_bg
        fg: git_branch_fg
    }
}
