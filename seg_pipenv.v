
module main

import os

fn seg_pipenv(arg Arg)Segment {
    env := os.getenv("VIRTUAL_ENV")

    e := env.split("/")
    en := if e.len < 2 {
        ""
    }else if ".venv" in e {
        e[e.len-2]
    } else {
        e[e.len-1]
    }
    // println(en)
    return Segment {
        name: "env"
        content: en
        space: true
        bg: theme.hostname_bg
        fg: theme.hostname_fg
    }
}
