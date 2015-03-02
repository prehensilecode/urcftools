#!/bin/bash
export FLEXLMDIR=/opt/flexlm
export PATH=${FLEXLMDIR}/bin:${PATH}
export LM_LICENSE_FILE=28518@proteusmaster.cm.cluster:27495@license01.coe.drexel.edu:27495@license02.coe.drexel.edu:27495@license03.coe.drexel.edu


WWWHOME=/var/www/html
STATUSFILE=${WWWHOME}/lmstat.txt
STATUSFILEHTML=${WWWHOME}/lmstat.html

lmstat -a | grep -v "License\ file" | sed -e 's/27495/...../g' | sed -e 's/28518/...../g' > ${STATUSFILE}

chmod 644 ${STATUSFILE}

echo "<!DOCTYPE html " > ${STATUSFILEHTML}
echo "     PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"" >> ${STATUSFILEHTML}
echo "     \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">" >> ${STATUSFILEHTML}
echo "     <html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">" >> ${STATUSFILEHTML}
echo "     <head>" >> ${STATUSFILEHTML}
echo "         <meta http-equiv=\"Content-type\" content=\"text/html;charset=UTF-8\" />" >> ${STATUSFILEHTML}
echo "         <meta http-equiv="refresh" content=\"300\"/>" >> ${STATUSFILEHTML}
echo "         <title>License Status</title>" >> ${STATUSFILEHTML}
echo "     </head>" >> ${STATUSFILEHTML}
echo "<body>" >> ${STATUSFILEHTML}
echo "<pre>" >> ${STATUSFILEHTML}
cat ${STATUSFILE} >> ${STATUSFILEHTML}
echo "</pre>" >> ${STATUSFILEHTML}
echo "</html>" >> ${STATUSFILEHTML}

chmod 644 ${STATUSFILEHTML}
