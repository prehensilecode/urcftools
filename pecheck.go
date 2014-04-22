/*
 * Requires https://github.com/dgruber/jsv
 */

package main

import (
    "github.com/dgruber/jsv"
)

func jsv_on_start_function() {
    //jsv_send_env()
}

func job_verification_function() {

    //
    // Prevent jobs from accidental oversubscription
    //

    var modified_p bool = false
    if !jsv.JSV_is_param("pe_name") {
        jsv.JSV_set_param("binding_strategy", "linear_automatic")
        jsv.JSV_set_param("binding_type", "set")
        jsv.JSV_set_param("binding_amount", "1")
        jsv.JSV_set_param("binding_exp_n", "0")
        modified_p = true
    } else {
        if !jsv.JSV_is_param("binding_strategy") {
            var v string
            v, _ = jsv.JSV_get_param("pe_max")
            jsv.JSV_set_param("binding_strategy", "striding_automatic")
            jsv.JSV_set_param("binding_type", "set")
            jsv.JSV_set_param("binding_amount", v)
            jsv.JSV_set_param("binding_step", "1")
            modified_p = true
        }
    }

    if modified_p {
        jsv.JSV_correct("Job was modified")
    }

    return
}

/* example JSV 'script' */
func main() {
    jsv.Run(true, job_verification_function, jsv_on_start_function)
}

