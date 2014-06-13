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
            var pe_min int
            var v string
            v, _ = jsv.JSV_get_param("pe_max")
            pe_max, _ = strconv.Atoi(v)

            v, _ = jsv.JSV_get_param("pe_min")
            pe_min, _ = strconv.Atoi(v)

            var hostlist string 
            hostlist, _ = jsv.JSV_get_param("q_hard")
            hostlist = strings.SplitAfterN(hostlist, "@", 2)[1]

            // Only specify binding if pe_max == pe_min, i.e. if a fixed
            // number of slots is requested

            if pe_max == pe_min {
                jsv.JSV_set_param("binding_strategy", "striding_automatic")
                jsv.JSV_set_param("binding_type", "pe")

                if strings.EqualFold("@intelhosts", hostlist) {
                    if pe_max < intel_slots {
                        jsv.JSV_set_param("binding_amount", strconv.Itoa(pe_max))
                    } else {
                        jsv.JSV_set_param("binding_amount", strconv.Itoa(intel_slots))
                    }

                    if pe_max > 31 {
                    jsv.JSV_set_param("R", "y")
                    }
                } else if strings.EqualFold("@amdhosts", hostlist) {
                    if pe_max < amd_slots {
                        jsv.JSV_set_param("binding_amount", strconv.Itoa(pe_max))
                    } else {
                        jsv.JSV_set_param("binding_amount", strconv.Itoa(amd_slots))

                        if pe_max > 127 {
                            jsv.JSV_set_param("R", "y")
                        }
                    }
                }
                jsv.JSV_set_param("binding_step", "1")
                modified_p = true
            }
        }
    }

    //jsv.JSV_show_params()
    if modified_p {
        jsv.JSV_correct("Job was modified")
    } else {
        jsv.JSV_correct("Job was not modified")
    }

    return
}

/* example JSV 'script' */
func main() {
    jsv.Run(true, job_verification_function, jsv_on_start_function)
}

