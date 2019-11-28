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
	for i, c in cwd {
		ret = if i == 0 {
			"$ret$c"
		} else {
			"$ret $c"
		}
		if i != cwd.len-1 {
			ret = "$ret $sep_"
		}
	}
	return ret
}

fn short_cwd(depth int) string{
	cwd := get_cwd(depth)
	mut ret := ""
	
	for i, c in cwd {
        if i == 0 {
            ret = c
        } else if i == cwd.len-1 {
			ret = "$ret $c"
        } else {
			ret = "$ret " + c[0].str()
		}
		if i != cwd.len-1 {
			ret = "$ret $sep_"
		}
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
		bg: cwd_bg
		fg: cwd_fg
	}
}
