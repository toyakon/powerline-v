
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

	mut user := seg_git_user(arg)
	mut cwd := seg_cwd(arg)
	mut prompt := seg_prompt(arg)
	mut git := seg_git_branch(arg)

	user.next_bg = if cwd.content.len != 0 { cwd.bg } else { 0 }
	cwd.next_bg = if git.content.len != 0 { git.bg } else { prompt.bg }
	git.next_bg = if prompt.content.len != 0 { prompt.bg } else { 0 }

	user.create()
	cwd.create()
	git.create()
	prompt.create()

	mut line := ""
	line += user.content
	line += cwd.content
	line += git.content
	line += prompt.content
	println("$line ")
	
}
