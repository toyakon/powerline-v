

module main

fn get_ahead(status string) int {
    if status.contains("ahead") {
        mut ah := status.all_after("ahead ")
        ah =  ah.trim("]")
        return ah.int()
    } else {
        return 0
    }
}

fn get_stash() int {
    ret := exec_git_cmd("git stash list")
    stash := ret.split("\n")
    return stash.len
}

fn get_status() map[string]int {
    ret := exec_git_cmd("git status -sb --ignore-submodules")
    status := ret.split("\n")
    mut git_stat := {
        "ahead": 0
        "staged": 0
        "unstaged": 0
        "untracked": 0
        "conflicted": 0
        "stash": 0
    }

    if status.len == 0 {
        return git_stat
    }

    git_stat["ahead"] = get_ahead(status[0])
    git_stat["stash"] = get_stash()
    files := status[1..]
    for f in files {
        st := f[..2]
        match st {
            "??" {
                git_stat["untracked"] = git_stat["untracked"] + 1
            }
            "DD", "AU", "UA", "DU", "AA", "UU" {
                git_stat["conflicted"] =  git_stat["conflicted"] + 1
            }
            else {
                if st[0].str() == " " {
                    git_stat["unstaged"] = git_stat["unstaged"] + 1
                }
                if st[1].str() == " " {
                    git_stat["staged"] = git_stat["staged"] + 1
                }
            }
        }
    }
    return git_stat
}

fn seg_git_status(arg Arg) Segment {
    status := get_status()
    git_colors := {
        "ahead_bg": theme.git_ahead_bg,
        "ahead_fg": theme.git_ahead_fg,
        "staged_bg": theme.git_staged_bg,
        "staged_fg": theme.git_staged_fg,
        "unstaged_bg": theme.git_unstaged_bg,
        "unstaged_fg": theme.git_unstaged_fg,
        "untracked_bg": theme.git_untracked_bg,
        "untracked_bfg": theme.git_untracked_fg,
        "conflicted_bg": theme.git_conflicted_bg,
        "conflicted_fg": theme.git_conflicted_fg,
        "stash_bg": theme.git_stash_bg,
        "stash_fg": theme.git_stash_fg
    }
    mut first := 0
    mut next := 0
    mut prev := 0

    mut line := ""

    keys := status.keys()

    mut exists := []string
    for st in keys {
        if status[st] != 0 {
            exists << st
        }
    }

    for i, st in exists {
        if prev != 0 {
            line += separator(next, prev)
        }
        sg := Segment {
            content: status[st].str() + icons["git_$st"]
            space: true
            bg: git_colors["${st}_bg"]
            fg: git_colors["${st}_fg"]
        }
        if first == 0 {
            first = sg.bg
        } else {
            first = first
        }
        if i < exists.len-1 {
            n := exists[i+1]
            next = git_colors["${n}_bg"]
        } else {
            next = sg.bg
        }
        prev = sg.bg
        line += sg.view()
    }

    return Segment {
        name: "git_status"
        content: line
        bg: first
        next: next
    }
}

