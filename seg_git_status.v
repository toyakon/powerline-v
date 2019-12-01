

module main

fn get_status() []int {
    ret := exec_git_cmd("git status -sb --ignore-submodules")
    status := ret.split("\n")
    if status.len == 0 {
        return [0,0,0]
    }

    file := status[1..]

    mut staged := 0
    mut not_staged := 0
    mut untracked := 0

    if file.len != 0  {
        for f in file {
            if f.contains("??") {
                untracked++
            }
            if f[0].str() == " " {
                not_staged++
            }
            if f[1].str() == " " {
                staged++
            }

        }
    }

    return [staged, not_staged, untracked]
}



fn seg_git_status(arg Arg) Segment {
    status := get_status()
    mut first := 0
    mut next := 0
    mut prev := 0

    mut stat := ""

    if status[0] != 0 {
        sg := Segment {
            content: status[0].str()
            space: true
            bg: staged_bg
            fg: staged_fg
        }
        first = if first == 0 { sg.bg } else { first }
        stat += sg.view()
        next = if status[1] != 0 {
            unstaged_bg
        } else if status[2] != 0 {
            untracked_bg
        } else {
            sg.bg
        }
        prev = sg.bg
    }

    if status[1] != 0 {

        if prev != 0 {
            stat += separator(next, prev)
        }
        sg := Segment {
            content: status[1].str()
            space: true
            bg: unstaged_bg
            fg: unstaged_fg
        }
        first = if first == 0 { sg.bg } else { first }
        stat += sg.view()
        next = if status[2] != 0 {
            untracked_bg
        } else {
            sg.bg
        }
        prev = sg.bg
    }

    if status[2] != 0 {
        if prev != 0 {
            stat += separator(next, prev)
        }
        sg := Segment {
            content: status[2].str()
            space: true
            bg: untracked_bg
            fg: untracked_fg
        }
        first = if first == 0 { sg.bg } else { first }
        stat += sg.view()
        next = sg.bg
    }

    return Segment {
        content: stat
        bg: first
        next: next
    }
}

