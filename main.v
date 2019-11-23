
module main

import os

const (
	prompt = "\\$"
)

fn segment_list(s string a Arg)string{

	if s == "user" {
		return get_user()
	}

	// if s == "cwd" {
	// 	return seg_cwd()
	// }

	if s == "prompt" {
		return prompt
	}	

	return "seg_cwd"
}

fn get_prmpt_color(exit_code int) int{
	bg := if exit_code != 0 {
		cmd_f_bg
	} else {
		cmd_s_bg
	}
	return bg
}


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

fn create_segment(s string a Arg next string)string{
	ret := segment_list(s, a)
	return ret
}

struct Arg {
mut:
	prev_exit_code int
	cwd_depth int
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