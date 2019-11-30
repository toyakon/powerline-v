module main

import os

fn get_current_branch() string {
    ret := os.exec("git branch") or {
        return ""
    }
    if ret.exit_code != 0 {
        return ""
    }
    branches := ret.output.split("\n")
    mut current := ""
    for b in branches {
        if b.starts_with("*") {
            current = b.replace("*", "").trim_space()
            break
        }
    }
    return current
}

fn get_status() string {
    ret := os.exec("git status -sb --ignore-submodules") or { return "" }
    if ret.exit_code != 0 {
        return ""
    }
    status := ret.output.split("\n")
    branch := status[0].trim("#").trim_space()

    tbranch := if branch.contains("...") {
        branch[..branch.index(".")]
    } else {
        branch
    }

    mut stat := "$tbranch"

    file := status[1..]

    mut staged := 0
    mut not_staged := 0
    mut untracked := 0

    if file.len != 0  {
        for f in file {
            if f.contains("??") {
                untracked++
            }
            if f[0].str() == " " {
                not_staged++
            }
            if f[1].str() == " " {
                staged++
            }

        }
    }

    if staged != 0 {
        stat = "$stat $sep_ $staged✓"
    }

    if not_staged != 0 {
        stat = "$stat $sep_ $not_staged✏"
    }

    if untracked != 0 {
        stat = "$stat $sep_ $untracked+"
    }

    return stat

}

fn seg_git_branch(arg Arg) Segment {
    br := get_status()
    return Segment {
        name: "git_branch"
        content: br
        bg: git_master_bg
        fg: git_branch_fg
    }
}

fn seg_git_branch2(arg Arg) Segment {
    br := get_current_branch()
    clr := if br == "master" {
        git_master_bg
    } else {
        git_branch_bg
    }
    return Segment {
        name: "git_branch"
        content: br
        bg: clr
        fg: git_branch_fg
    }
}

fn get_git_user() string {
    usr := os.exec("git config user.name") or { return "" }
    if usr.exit_code != 0 {
        return ""
    }
    return usr.output
}

fn seg_git_user(arg Arg) Segment {
    usr := get_git_user()
    return Segment {
        name: "git_user"
        content: usr
        bg: user_bg
        fg: user_fg
    }
}
