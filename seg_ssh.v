module main

import os

fn seg_ssh(arg Arg)Segment {
    ssh := os.getenv("SSH_CLIENT")
    content := if ssh != "" {
       "ssh" 
    } else {
        ""
    }

    return Segment {
        name: "ssh"
        content: content
        space: true
        bg: theme.ssh_bg
        fg: theme.ssh_fg

    }
}

