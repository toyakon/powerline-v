
module main

import os

fn get_jobs(ppid string) int {
    mut jobs := 0
	if ppid == "" {
		return jobs
	}
    ps := os.exec("ps o pid,ppid,stat,command --ppid $ppid") or { return jobs }

    psa := ps.output.split("\n")
    for p in psa {
        _p := p.split(" ")
        if _p[1] == ppid && _p[2].contains("T") {
            jobs++
        }
    }
    return jobs
}

fn seg_job(arg Arg) Segment {
    jobs := get_jobs(arg.ppid)
    job := if jobs == 0 {
        ""
    } else {
        jobs.str()
    }
    return Segment {
        name: "job"
        content: job
        space: true
        bg: theme.job_bg
        fg: theme.job_fg
    }
}
