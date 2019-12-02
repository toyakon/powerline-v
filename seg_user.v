module main

fn seg_user(arg Arg)Segment{
    return Segment {
        name: "user"
        content: "\\u"
        space: true
        bg: theme.user_bg
        fg: theme.user_fg
    }
}
