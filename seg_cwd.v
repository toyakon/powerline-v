module main

import os

fn get_full_cwd() []string {
	mut cwd_full := os.getwd()
	home_path := os.getenv("HOME")
	cwd_full = cwd_full.replace(home_path, "~")
	return cwd_full.split("/")
}

fn get_cwd(depth int) string {
	mut cwd := get_full_cwd()
	mut ret := []string
	if depth != 0 && depth < cwd.len{
		cwd = cwd[cwd.len-depth..]
		ret << "..."
		ret << cwd
	} else {
		ret = cwd
	}
	mut ret_s := ""
	for i, c in ret {
		ret_s = "$ret_s $c"
		if i != ret.len-1 {
			ret_s = "$ret_s $sep_"
		}
	}

	return ret_s
}

fn seg_cwd(arg Arg)Segment{
	return Segment {
		name: "cwd"
		content: get_cwd(arg.cwd_depth)
		bg: cwd_bg
		fg: cwd_fg
	}
}
