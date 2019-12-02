
module main

struct Segment {
    mut:
    name string
    content string
    space bool
    next int
    bg int
    fg int
    arg Arg
}

const (
    sep = "\uE0B0"
    sep_thin = "\uE0B1"
    sep_ = "\uE0B1"
)

fn set_color(content string bg, fg int)string {
    _fg := if fg != 0 { "\\[\\e[38;5;${fg.str()}m\\]" } else { "" }
    _bg := if bg != 0 { "\\[\\e[48;5;${bg.str()}m\\]" } else { "" }
    _content := "$_fg$_bg$content\\[\\e[0m\\]"
    return _content
}

fn separator(bg, fg int)string {
    return set_color(sep, bg, fg)
}

fn separator_thin(bg, fg int)string {
    return set_color(sep_thin, bg, fg)
}

fn (s Segment) view()string{
    con := if s.space {
        " $s.content "
    } else {
        s.content
    }
    return set_color(con, s.bg, s.fg)
}
