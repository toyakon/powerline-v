module main

import os

fn get_user() string {
	return os.getenv("USER")
}

fn seg_user(arg Arg)Segment{
	return Segment {
		name: "user"
		content: "\\u"
		bg: user_bg
		fg: user_fg
	}
}