
module main

import os

const (
	sep = "\uE0B0"
	sep_ = "\uE0B1"
	prompt = "\\$"
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
	mut ret := "\\[\\e[38;5;${s.fg.str()}m\\]"
	if s.bg != 0 {
		ret = "$ret\\[\\e[48;5;${s.bg.str()}m\\]"
	}
	s.seg = "$ret${s.seg}\\[\\e[0m\\]"
}

fn create_segment(s string a Arg)string{
	mut user := segment_list(s, a)

	user.spacer()
	user.color()

	mut sp := sep
	mut sp_bg := 0
	mut sp_fg := user.bg
	if a.next_seg != "" {
		next_seg := segment_list(a.next_seg, a)
		sp_bg = next_seg.bg
		if next_seg.bg == user.bg {
			sp = sep_
			sp_fg = 244
		}
	}
	
	mut sprt := &Segment {
		seg: sp
		fg: sp_fg
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

	set := ["user", "user", "cwd", "temp", "prompt"]
	
	mut line := ""
	for i, s in set {
		if i < set.len-1 {
			arg.next_seg = set[i+1]
		}else if i == set.len-1 {
			arg.next_seg = ""
		}
		line = line + create_segment(s, arg)
	}
	println("$line ")
}