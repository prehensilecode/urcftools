#!/bin/bash

spark_conf_dir=${SGE_O_WORKDIR}/conf.${JOB_ID}
/bin/mkdir -p ${spark_conf_dir}


### for bash-like
sparkenvfile=${spark_conf_dir}/spark-env.sh

echo "#!/usr/bin/env bash" > $sparkenvfile
echo "export JAVA_HOME=/usr/lib/jvm/java-1.7.0-oracle.x86_64" >> $sparkenvfile
echo "export SPARK_CONF_DIR=${spark_conf_dir}" >> $sparkenvfile
echo "export SPARK_MASTER_WEBUI_PORT=8880" >> $sparkenvfile
echo "export SPARK_WORKER_WEBUI_PORT=8881" >> $sparkenvfile
echo "export SPARK_WORKER_INSTANCES=1" >> $sparkenvfile

spark_master_ip=$( cat ${PE_HOSTFILE} | head -1 | cut -f1 -d\  )
echo "export SPARK_MASTER_IP=${spark_master_ip}" >> $sparkenvfile

echo "export SPARK_MASTER_PORT=7077" >> $sparkenvfile
echo "export MASTER_URL=spark://${spark_master_ip}:7077" >> $sparkenvfile

spark_slaves=${SGE_O_WORKDIR}/slaves.${JOB_ID}
echo "export SPARK_SLAVES=${spark_slaves}" >> $sparkenvfile

spark_worker_cores=$( expr ${NSLOTS} / ${NHOSTS} )
echo "export SPARK_WORKER_CORES=${spark_worker_cores}" >> $sparkenvfile

spark_worker_dir=/lustre/scratch/${SGE_O_LOGNAME}/spark/work.${JOB_ID}
echo "export SPARK_WORKER_DIR=${spark_worker_dir}" >> $sparkenvfile

spark_log_dir=${SGE_O_WORKDIR}/logs.${JOB_ID}
echo "export SPARK_LOG_DIR=${spark_log_dir}" >> $sparkenvfile

echo "export SPARK_LOCAL_DIRS=${TMP}" >> $sparkenvfile

chmod +x $sparkenvfile


### for csh-like
sparkenvfile=${spark_conf_dir}/spark-env.csh

echo "#!/usr/bin/env tcsh" > $sparkenvfile
echo "setenv JAVA_HOME /usr/lib/jvm/java-1.7.0-oracle.x86_64" >> $sparkenvfile
echo "setenv SPARK_CONF_DIR ${spark_conf_dir}" >> $sparkenvfile
echo "setenv SPARK_MASTER_WEBUI_PORT 8880" >> $sparkenvfile
echo "setenv SPARK_WORKER_WEBUI_PORT 8881" >> $sparkenvfile
echo "setenv SPARK_WORKER_INSTANCES 1" >> $sparkenvfile

spark_master_ip=$( cat ${PE_HOSTFILE} | head -1 | cut -f1 -d\  )
echo "setenv SPARK_MASTER_IP ${spark_master_ip}" >> $sparkenvfile

echo "setenv SPARK_MASTER_PORT 7077" >> $sparkenvfile
echo "setenv MASTER_URL spark://${spark_master_ip}:7077" >> $sparkenvfile

spark_slaves=${SGE_O_WORKDIR}/slaves.${JOB_ID}
echo "setenv SPARK_SLAVES ${spark_slaves}" >> $sparkenvfile

spark_worker_cores=$( expr ${NSLOTS} / ${NHOSTS} )
echo "setenv SPARK_WORKER_CORES ${spark_worker_cores}" >> $sparkenvfile

spark_worker_dir=/lustre/scratch/${SGE_O_LOGNAME}/spark/work.${JOB_ID}
echo "setenv SPARK_WORKER_DIR ${spark_worker_dir}" >> $sparkenvfile

spark_log_dir=${SGE_O_WORKDIR}/logs.${JOB_ID}
echo "setenv SPARK_LOG_DIR ${spark_log_dir}" >> $sparkenvfile

echo "setenv SPARK_LOCAL_DIRS ${TMP}" >> $sparkenvfile

chmod +x $sparkenvfile

/bin/mkdir -p ${spark_log_dir}
/bin/mkdir -p ${spark_worker_dir}
cat ${PE_HOSTFILE} | cut -f1 -d \  > ${spark_slaves}

