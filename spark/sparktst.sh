#!/bin/bash
#$ -S /bin/bash
#$ -P fooPrj
#$ -M foomail@drexel.edu
#$ -m a
#$ -j y
#$ -cwd
#$ -jc spark.intel
#$ -l exclusive
#$ -l vendor=intel
#$ -pe sparkintel 32
#$ -l h_rt=0:30:00
#$ -l h_vmem=4g
#$ -l m_mem_free=3g

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load use.own
module load gcc
module load sge/univa
module load scala
module load python/2.7-current
module load spark

export SPARK_CONF_DIR=${SGE_O_WORKDIR}/conf.${JOB_ID}
. ${SPARK_CONF_DIR}/spark-env.sh

env | sort

echo ""

echo "Where am I?"
echo "$( pwd ) on $( hostname )"

echo "Starting master on ${SPARK_MASTER_IP} ..."
start-master.sh
echo "Done starting master."

echo "Starting slave..."
start-slaves.sh
echo "Done starting slave."

echo "Submitting job..."
spark-submit --master $MASTER_URL myjob.py
echo "Done job."

echo "Stopping slaves..."
stop-slaves.sh
echo "Done stopping slaves"

echo "Stopping master..."
stop-master.sh
echo "Done stopping master."


