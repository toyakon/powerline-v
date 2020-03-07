
module main

fn seg_hostname(arg Arg)Segment {
    return Segment {
        name: "hostname"
        content: "\\h"
        space: true
        bg: theme.hostname_bg
        fg: theme.hostname_fg
    }
}
