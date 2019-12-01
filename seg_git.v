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

fn get_status() string {
    ret := os.exec("git status -sb --ignore-submodules") or { return "" }
    if ret.exit_code != 0 {
        return ""
    }
    status := ret.output.split("\n")

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

    mut stat := ""

    if staged != 0 {
        mut s := Segment {
            content: staged.str()
            bg: cmd_s_bg
            fg: cmd_s_fg
            next_bg: cmd_f_bg
        }
        s.create()
        stat = "$stat$s.content"
    }

    if not_staged != 0 {
        mut ns := Segment {
            content: not_staged.str()
            bg: cmd_f_bg
            fg: cmd_f_fg
            next_bg: cmd_s_bg
        }
        ns.create()
        stat = "$stat$ns.content"
    }

    if untracked != 0 {
        mut ut := Segment {
            content: untracked.str()
            bg: cmd_s_bg
            fg: cmd_s_fg
        }
        ut.create()
        stat = "$stat$ut.content"
    }

    return stat

}


fn seg_git_status(arg Arg) Segment {
    br := Segment {
        content: get_status()
        bg: git_master_bg
        fg: git_branch_fg
    }

    return br
}

