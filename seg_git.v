module main

import os

fn exec_git_cmd(arg string) string{
    ret := os.exec(arg) or { panic(err) }

    return if ret.exit_code != 0 {
        ""
    } else {
        ret.output
    }
}

fn seg_git(arg Arg) Segment {
    stat := seg_git_status(arg)
    branch := seg_git_branch(arg)
    mut content := ""
    if branch.content != "" {
        content += branch.view()
    }
    if stat.content != ""{
        content += separator(stat.bg, branch.bg) +  stat.view()
    }
    return Segment {
        content: content
        bg: theme.git_branch_bg
        next: stat.next
    }
}
