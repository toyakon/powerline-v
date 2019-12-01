module main

fn seg_user(arg Arg)Segment{
    return Segment {
        name: "user"
        content: "\\u"
        space: true
        bg: user_bg
        fg: user_fg
    }
}
