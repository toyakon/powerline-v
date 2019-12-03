module main

import os

fn get_full_cwd() []string {
    mut cwd_full := os.getwd()
    home_path := os.getenv("HOME")
    cwd_full = cwd_full.replace(home_path, "~")
    return cwd_full.split("/")
}

fn long_cwd(depth int) string {
    cwd := get_cwd(depth)
    mut ret := ""
    mut prev := 0
    for c in cwd {
        seg := Segment {
            content: c
            space: true
            bg: theme.cwd_bg
            fg: theme.cwd_fg
        }
        if prev != 0 {
            ret += if prev == seg.bg {
                separator_thin(prev, theme.cwd_fg)
            } else {
                separator(prev, seg.bg)
            }
        }
        ret += seg.view()
        prev = seg.bg

    }
    return ret
}

fn short_cwd(depth int) string{
    cwd := get_cwd(depth)
    mut ret := ""
    mut prev := 0
    for i, c in cwd {
        seg := Segment {
            content: if i == 0 || i == cwd.len-1 { c } else { c[0].str() }
            space: true
            bg: theme.cwd_bg
            fg: theme.cwd_fg
        }
        if prev != 0 {
            ret += if prev == seg.bg {
                separator_thin(prev, theme.cwd_fg)
            } else {
                separator(prev, seg.bg)
            }
        }
        ret += seg.view()
        prev = seg.bg

    }
    return ret
}

fn get_cwd(depth int) []string {
    mut cwd := get_full_cwd()
    mut ret := []string
    if depth != 0 && depth < cwd.len{
        cwd = cwd[cwd.len-depth..]
        ret << "\u2026"
        ret << cwd
    } else {
        ret = cwd
    }
    return ret
}

fn seg_cwd(arg Arg)Segment{
    cwd := if arg.short_cwd == 1 {
        short_cwd
    } else {
        long_cwd
    }

    return Segment {
        name: "cwd"
        content: cwd(arg.cwd_depth)
        bg: theme.cwd_bg
        fg: theme.cwd_fg
    }
}

