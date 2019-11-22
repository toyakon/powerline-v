
module main

import os

const (
	sep = "\uE0B0"
	prompt = "\$"
	bg_template = "\e[48;%dm"
	fg_template = "\e[38;%dm"
)

struct Segment {
	bg int
	fg int
	mut:
	next_bg int
	seg string
}

fn segment_list(s string a Arg)Segment{
	mut seg_list := map[string]Segment

	seg_list["user"] = Segment{seg:get_user(), bg:user_bg, fg:user_fg}
	seg_list["empty"] = Segment{seg:"empty", bg:init_bg, fg:init_fg}
	seg_list["cwd"] = Segment{seg:get_cwd(), bg:cwd_bg, fg:cwd_fg}
	seg_list["prompt"] = Segment{seg:prompt, bg:get_prmpt_color(a.prev_exit_code), fg:cmd_s_fg}

	mut ret := Segment{seg:s, bg:init_bg, fg:init_fg}
	if s in seg_list {
		ret = seg_list[s]
	}	
	return ret
}

fn get_prmpt_color(exit_code int) int{
	mut bg := cmd_s_bg
	if exit_code != 0 {
		bg = cmd_f_bg
	}
	return bg
}

fn get_cwd() string {
	cwd := os.getwd()
	return cwd
}
fn get_user() string {
	return os.getenv("USER")
}

fn (s mut Segment) spacer() {
	s.seg = " $s.seg "
}

fn (s mut Segment) color(){
	ret := malloc(256)
	if s.bg == 0 {
		C.sprintf(ret, "\e[38;5;%dm%s\e[m", s.fg, s.seg)
	} else {
		C.sprintf(ret, "\e[38;5;%dm\e[48;5;%dm%s\e[m", s.fg, s.bg, s.seg)
	}
	s.seg = tos(ret, vstrlen(ret))
}

fn create_segment(s string a Arg)string{
	mut user := segment_list(s, a)

	user.spacer()
	user.color()

	mut sp_bg := 0
	if a.next_seg != "" {
		next_seg := segment_list(a.next_seg, a)
		sp_bg = next_seg.bg
	}
	
	mut sprt := &Segment {
		seg: sep
		fg: user.bg
		bg: sp_bg
	}	

	sprt.color()

	return user.seg + sprt.seg
}

struct Arg {
mut:
	prev_exit_code int
	next_seg string
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
	}

	set := ["user", "cwd", "prompt"]
	
	mut line := ""
	for i, s in set {
		if i < set.len-1 {
			arg.next_seg = set[i+1]
		}else if i == set.len-1 {
			arg.next_seg = ""
		}
		line = line + create_segment(s, arg)
	}
	println(line)
}