
module main

import os

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
	argv := os.args
	argc := argv.len
	mut arg := Arg{}
	for i := 0; i<argc;i++ {
		if argv[i] == "-err" {
			i++
			arg.prev_exit_code = argv[i].int()
		}
		if argv[i] == "-cwd_depth" {
			i++
			arg.cwd_depth = argv[i].int()
		}
		if argv[i] == "-short_cwd" {
			arg.short_cwd = 1
		}
	}

	mut user := seg_user(arg)
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