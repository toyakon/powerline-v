
module main

import os

const (
	prompt = "\\$"
)


fn get_user() string {
	return os.getenv("USER")
}

fn seg_user(arg Arg)Segment{
	return Segment {
		name: "user"
		content: get_user()
		bg: user_bg
		fg: user_fg
	}
}

fn seg_prompt(arg Arg)Segment{
	// println(arg.prev_exit_code)
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
	// mut next := ""
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
	user.next_bg = cwd.bg
	cwd.next_bg = prompt.bg
	user.create()
	cwd.create()
	prompt.create()
	print(user.content)
	print(cwd.content)
	print(prompt.content)
	// set := ["user", "cwd", "prompt"]
	
	// mut line := ""
	// for i, s in set {
	// 	if i < set.len-1 {
	// 		next = set[i+1]
	// 	}else if i == set.len-1 {
	// 		next = ""
	// 	}
	// 	line = line + create_segment(s, arg, next)
	// }
	// println("$line ")
}