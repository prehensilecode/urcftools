/*
 * Requires https://github.com/dgruber/jsv
 */

package main

import (
    "github.com/dgruber/jsv"
    "strings"
    "strconv"
)

func jsv_on_start_function() {
    //jsv_send_env()
}

func job_verification_function() {
    // show qsub params
    //jsv.JSV_show_params()


    //
    // Prevent jobs from accidental oversubscription
    //
    const intel_slots, amd_slots = 16, 64

    var modified_p bool = false
    if !jsv.JSV_is_param("pe_name") {
        jsv.JSV_set_param("binding_strategy", "linear_automatic")
        jsv.JSV_set_param("binding_type", "set")
        jsv.JSV_set_param("binding_amount", "1")
        jsv.JSV_set_param("binding_exp_n", "0")
        modified_p = true
    } else {
        if !jsv.JSV_is_param("binding_strategy") {
            var pe_max int
            var v string
            v, _ = jsv.JSV_get_param("pe_max")
            pe_max, _ = strconv.Atoi(v)

            var hostlist string 
            hostlist, _ = jsv.JSV_get_param("q_hard")
            hostlist = strings.SplitAfterN(hostlist, "@", 2)[1]

            jsv.JSV_set_param("binding_strategy", "striding_automatic")
            jsv.JSV_set_param("binding_type", "pe")

            //jsv.JSV_log_info("FOOBAR")
            //jsv.JSV_log_info(hostlist)
            //jsv.JSV_log_info(v)
            //jsv.JSV_log_info(strconv.Itoa(pe_max))

            if strings.EqualFold("@intelhosts", hostlist) {
                if pe_max < intel_slots {
                    jsv.JSV_set_param("binding_amount", strconv.Itoa(pe_max))
                } else {
                    jsv.JSV_set_param("binding_amount", strconv.Itoa(intel_slots))
                }
            } else if strings.EqualFold("@amdhosts", hostlist) {
                if pe_max < amd_slots {
                    jsv.JSV_set_param("binding_amount", strconv.Itoa(pe_max))
                } else {
                    jsv.JSV_set_param("binding_amount", strconv.Itoa(amd_slots))
                }
            }

            jsv.JSV_set_param("binding_step", "1")
            modified_p = true
        }
    }

    if modified_p {
        jsv.JSV_correct("Job was modified")

        // show qsub params
        jsv.JSV_show_params()
    }

    return
}

/* example JSV 'script' */
func main() {
    jsv.Run(true, job_verification_function, jsv_on_start_function)
}

