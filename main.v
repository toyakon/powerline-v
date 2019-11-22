
module main

import os

const (
	sep = "\uE0B0"
	prompt = "\$"
	bg_template = "\e[48;5;%dm"
	fg_template = "\e[38;5;%dm"
)

struct Segment {
	text string
	bg int
	fg int
	mut:
	ret string
}

fn add_spacer(t string) string {
	return " " + t + " "
}

fn (s mut Segment) spacer() {
	s.ret = " $s.text "
}

fn (s mut Segment) color() {
	ret := malloc(32)
	C.sprintf(ret, "\e[38;5;%dm\e[48;5;%dm%s\e[m", s.fg, s.bg, s.ret)
	s.ret = tos(ret, vstrlen(ret))
}

fn get_user() string{
	mut user := &Segment {
		text: os.getenv("USER")
		bg: user_bg
		fg: user_fg
	}

	user.spacer()
	user.color()
	return user.ret
}

fn get_prompt(exit_code int) string {
	mut bg := cmd_s_bg
	mut fg := cmd_s_fg
	if exit_code != 0 {
		bg = cmd_f_bg
		fg = cmd_f_fg
	}
	mut prmpt := &Segment {
		text: prompt
		bg: bg
		fg: fg
	}
	prmpt.spacer()
	prmpt.color()
	return prmpt.ret
}


fn main() {
	argv := os.args
	argc := argv.len
	mut prev_exit_code := 0
	for i := 0; i<argc;i++ {
		if argv[i] == "-err" {
			i++
			prev_exit_code = argv[i].int()
		}
	}
	prompt := get_prompt(prev_exit_code)
	user := get_user()
	println(user+prompt)
}