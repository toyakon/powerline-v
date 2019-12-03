
module main

import os

fn seg_hostname(arg Arg)Segment {
    hostname := os.exec("hostname") or { panic(err) }
    return Segment {
        name: "hostname"
        content: hostname.output
        space: true
        bg: theme.hostname_bg
        fg: theme.hostname_fg
    }
}
