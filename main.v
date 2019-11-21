import os

const (
	sep = "\uE0B0"
	prompt = "\$"
)


const (
	user_bg = 153
	user_fg = 238
	cmd_s_bg = 153
	cmd_s_fg = 238
	cmd_f_bg = 161
	cmd_f_fg = 238
	
)

fn add_spacer(t string) string {
	return " " + t + " "
}

fn get_user() string{
	user := os.getenv("USER")
	user_c := set_color(add_spacer(user), user_bg, user_fg)
	user_r := user_c + set_fg_color(sep, user_bg)
	return user_r
}

fn get_prompt(exit_code int) string {
	mut bg := cmd_s_bg
	mut fg := cmd_s_fg
	if exit_code != 0 {
		bg = cmd_f_bg
		fg = cmd_f_fg
	}
	prmpt := set_color(add_spacer("$"), bg, fg)
	prmpt_r := prmpt+ set_fg_color(sep, bg)
	return prmpt_r
}

fn set_fg_color(s string c int) string {
	ret := malloc(124)
	C.sprintf(*char(ret), "\e[38;5;%dm%s\e[m", c, s)
	return tos(ret, vstrlen(ret)) 
}

fn set_color(s string bg int fg int) string {
	ret := malloc(124)
	// println("bg: " + bg.str())
	// println("fg: " + fg.str())
	C.sprintf(*char(ret), "\e[38;5;%dm\e[48;5;%dm%s\e[m", fg, bg, s)
	return tos(ret, vstrlen(ret)) 
}

fn main() {
	argv := os.args
	argc := argv.len
	mut prev_exit_code := 0
	for i := 0; i<argc;i++ {
		if argv[i] == "-err" {
			i++
			prev_exit_code = argv[i].int()
		}
	}
	prompt := get_prompt(prev_exit_code)
	user := get_user()
	println(user+prompt)
}