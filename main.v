
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

    user := seg_git_user(arg)
    cwd := seg_cwd(arg)
    prompt := seg_prompt(arg)
    git := seg_git(arg)
    job := seg_job(arg)

    powerline := [user, cwd, git, job, prompt]

    mut powerline_view := []Segment

    for pl in powerline {
        if pl.content != "" {
            powerline_view << pl
        }
    }

    mut line := ""
    mut next := 0
    mut prev := 0

    for i, pl in powerline_view {
        
        line += pl.view()
        if i != powerline_view.len-1 {
            prev = powerline_view[i+1].bg
            next = if pl.next != 0 { pl.next } else { pl.bg }
            line += separator(prev, next)
        } else {
            line += separator(0, pl.bg)
        }
    }

    println("$line ")

}
