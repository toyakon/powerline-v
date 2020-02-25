
module main

import toyakon.vargparse

const (
    prompt = "\\$"
)

fn seg_prompt(arg Arg)Segment{
    mut bg := theme.cmd_s_bg
    mut fg := theme.cmd_s_fg

    if arg.prev_exit_code != 0 {
        bg = theme.cmd_f_bg
        fg = theme.cmd_f_fg
    }

    return Segment {
        name: "prompt"
        content: prompt
        space: true
        bg: bg
        fg: fg
    }
}

struct Arg {
    ppid string
    mut:
    prev_exit_code int
    cwd_depth int
    short_cwd int
}

fn main() {
    mut args := vargparse.parser()

    args.add_argument("-ppid:")
    args.add_argument("-err:")
    args.add_argument("-short_cwd")
    args.add_argument("-cwd_depth:")

    args.parse()
    arg := Arg{
        ppid: args.get("-ppid")
        prev_exit_code: args.get("-err").int()
        cwd_depth: args.get("-cwd_depth").int()
        short_cwd: if args.get("-short_cwd") == "true" { 1 } else { 0 }
    }

    user_format := args.get_etc()
    powerline_format := if user_format.len != 0 {
        user_format
    } else {
        ["env", "user", "host", "ssh", "cwd", "git", "job"]
    }

    segment_list := {
        "user": seg_user(arg)
        "guser" : seg_git_user(arg)
        "host" : seg_hostname(arg)
        "ssh" : seg_ssh(arg)
        "cwd" : seg_cwd(arg)
        "prompt" : seg_prompt(arg)
        "git" : seg_git(arg)
        "job" : seg_job(arg)
        "env" : seg_pipenv(arg)
    }

    mut powerline := []Segment
    for pf in powerline_format {
        if pf in segment_list {
            if segment_list[pf].content != "" {
                powerline << segment_list[pf]
            }
        }
    }

    powerline << segment_list["prompt"]

    mut line := ""
    mut next := 0
    mut prev := 0

    for i, pl in powerline {
        line += pl.view()
        if i != powerline.len-1 {
            prev = powerline[i+1].bg
            next = if pl.next != 0 { pl.next } else { pl.bg }
            line += if prev == pl.bg {
                separator_thin(prev, theme.default_fg)
            } else {
                separator(prev, next)
            }
        } else {
            line += separator(0, pl.bg)
        }
    }

    println("$line ")

}
