/*
 * Requires https://github.com/dgruber/jsv
 */

package main

import (
    "github.com/dgruber/jsv"
    "strings"
    "strconv"
    "regexp"
)

func jsv_on_start_function() {
    //jsv_send_env()
}

func job_verification_function() {

    //
    // Prevent jobs from accidental oversubscription
    //

    // NOTE
    // The submit(1) man page has slightly different terminology:
    // "binding_instance" in the man page is "binding_type" in 
    //  the jsv library.
    const intel_slots, amd_slots = 16, 64

    var modified_p bool = false

    if !jsv.JSV_is_param("pe_name") {
        // no PE => serial job
        jsv.JSV_set_param("binding_strategy", "linear_automatic")
        jsv.JSV_set_param("binding_type", "set")
        jsv.JSV_set_param("binding_amount", "1")
        jsv.JSV_set_param("binding_exp_n", "0")
        modified_p = true
    } else {
        // parallel job
        if !jsv.JSV_is_param("binding_strategy") {
            var v string
            v, _ = jsv.JSV_get_param("pe_max")
            pe_max, _ := strconv.Atoi(v)

            v, _ = jsv.JSV_get_param("pe_min")
            pe_min, _ := strconv.Atoi(v)

            l_hard, _ := jsv.JSV_get_param("l_hard")
            q_hard, _ := jsv.JSV_get_param("q_hard")

            singleat_re, _ := regexp.Compile("@[a-z]")
            doubleat_re, _ := regexp.Compile("@@")
            intelhost_re, _ := regexp.Compile("^ic[:digit:]{2}n[:digit:]{2}$")
            amdhost_re, _ := regexp.Compile("^ac[:digit:]{2}n[:digit:]{2}$")
            gpuhost_re, _ := regexp.Compile("^gpu[:digit:]{2}$")

            var q string
            var host string
            var hostlist string

            if singleat_re.MatchString(q_hard) {
                // we have a single host
                q = strings.Split(q_hard, "@")[0]
                host = strings.Split(q_hard, "@")[1]
            } else if doubleat_re.MatchString(q_hard) {
                // we have a hostgroup
                q = strings.Split(q_hard, "@")[0]
                hostlist = strings.SplitAfterN(q_hard, "@", 2)[1]
            } else {
                // we have no host specifier
                q = q_hard
            }

            cplx := make(map[string]string)
            l_hard_split := strings.Split(l_hard, ",")
            for _, v := range l_hard_split {
                cplx[strings.Split(v, "=")[0]] = strings.Split(v, "=")[1]
            }

            vendor, ok := cplx["vendor"]

            if !ok {
                // vendor was not requested by job
                if strings.EqualFold("gpu.q", q) || strings.EqualFold("@intelhosts", hostlist) {
                    vendor = "intel"
                } else if strings.EqualFold("@amdhosts", hostlist) {
                    vendor = "amd"
                } else {
                    if intelhost_re.MatchString(host) || gpuhost_re.MatchString(host) {
                        vendor = "intel"
                    } else if amdhost_re.MatchString(host) {
                        vendor = "amd"
                    }
                }
            }

            // Only specify binding if pe_max == pe_min, i.e. if a fixed
            // number of slots is requested

            if pe_max == pe_min {
                jsv.JSV_set_param("binding_strategy", "striding_automatic")
                jsv.JSV_set_param("binding_type", "set")

                if strings.EqualFold("intel", vendor) {
                    if pe_max < intel_slots {
                        jsv.JSV_set_param("binding_amount", strconv.Itoa(pe_max))
                    } else {
                        jsv.JSV_set_param("binding_amount", strconv.Itoa(intel_slots))
                    }

                    if pe_max > 31 {
                        jsv.JSV_set_param("R", "y")
                    }
                } else if strings.EqualFold("amd", vendor) {
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

