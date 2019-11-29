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

fn seg_git_branch(arg Arg) Segment {
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
