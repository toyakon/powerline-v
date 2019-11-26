
module main

struct Segment {
mut:
	name string
	content string
	next_bg int
	bg int
	fg int
	arg Arg
}

const (
	sep = "\uE0B0"
	sep_ = "\uE0B1"
)

struct Separator {
mut:
	text string
	bg int
	fg int
}

fn (s mut Segment) spacer() {
	s.content = " $s.content "
}

fn (s mut Segment) color(){
	mut ret := "\\[\\e[38;5;${s.fg.str()}m\\]"
	if s.bg != 0 {
		ret = "$ret\\[\\e[48;5;${s.bg.str()}m\\]"
	}
	s.content = "$ret${s.content}\\[\\e[0m\\]"
}

fn (s mut Segment) create() {
	if s.content.len == 0 {
		bg: 0
		return
	}
	s.spacer()
	s.color()

	mut sp := Separator {
		text: sep
		bg: s.next_bg
		fg: s.bg
	}
	if sp.bg != 0 {
		if sp.bg == s.bg {
			sp.text = sep_
			sp.fg = 244
		}
	}
	
	mut sprt := &Segment {
		content: sp.text
		fg: sp.fg
		bg: sp.bg
	}	

	sprt.color()

	s.content = s.content + sprt.content
}