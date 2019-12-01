
module main

import toyakon.vargparse

const (
    prompt = "\\$"
)

fn seg_prompt(arg Arg)Segment{
    bg := if arg.prev_exit_code != 0 {
        cmd_f_bg
    } else {
        cmd_s_bg
    }
    return Segment {
        name: "prompt"
        content: prompt
        space: true
        bg: bg
        fg: cmd_s_fg
    }
}

struct Arg {
    mut:
    prev_exit_code int
    cwd_depth int
    short_cwd int
}

fn main() {
    mut args := vargparse.parser()

    args.add_argument("-err:")
    args.add_argument("-short_cwd")
    args.add_argument("-cwd_depth:")

    args.parse()
    arg := Arg{
        prev_exit_code: args.get("-err").int()
        cwd_depth: args.get("-cwd_depth").int()
        short_cwd: if args.get("-short_cwd") == "true" { 1 } else { 0 }
    }

    user := seg_git_user(arg)
    cwd := seg_cwd(arg)
    prompt := seg_prompt(arg)
    git := seg_git(arg)
    powerline := [user, cwd, git, prompt]

    mut line := ""
    mut next := 0
    mut prev := 0

    for i, pl in powerline {
        if pl.content == "" {
            continue
        }

        line += pl.view()
        if i != powerline.len-1 {
            prev = if powerline[i+1].content == "" {
                powerline[(i+2)%powerline.len].bg
            } else {
                powerline[i+1].bg
            }
            next = if pl.next != 0 { pl.next } else { pl.bg }
            line += separator(prev, next)
        } else {
            line += separator(0, pl.bg)
        }
    }

    println("$line ")

}
