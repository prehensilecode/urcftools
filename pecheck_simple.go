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
        hostlist, _ := jsv.JSV_get_param("q_hard")
        hostlist = strings.SplitAfterN(hostlist, "@", 2)[1]

        v, _ := jsv.JSV_get_param("pe_max")
        pe_max, _ := strconv.Atoi(v)

        if strings.EqualFold("@amdhosts", hostlist) {
            if pe_max > 127 {
                jsv.JSV_set_param("R", "y")
                modified_p = true
            }
        }

        if strings.EqualFold("@intelhosts", hostlist) {
            if pe_max > 31 {
                jsv.JSV_set_param("R", "y")
                modified_p = true
            }
        }
    }


    if modified_p {
        // jsv.JSV_show_params()
        jsv.JSV_correct("Job was modified")
    } else {
        jsv.JSV_correct("Job was not modified")
    }

    return
}

func main() {
    jsv.Run(true, job_verification_function, jsv_on_start_function)
}

