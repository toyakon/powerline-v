
module main

fn get_git_user() string {
    usr := exec_git_cmd("git config user.name")
    return usr
}

fn seg_git_user(arg Arg) Segment {
    return Segment {
        name: "git_user"
        content: get_git_user()
        space: true
        bg: user_bg
        fg: user_fg
    }
}
