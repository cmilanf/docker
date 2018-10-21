#!/bin/bash
# Credit to: https://gist.github.com/arichika/b1a1413b554734ae964f

pemsdir='/home/letsencrypt/live'      # default search PEMs
pfxspath='/home/letsencrypt/live'   # dest of the PFXs
passfile='/home/letsencrypt/live/passfile.txt'  # password to be applied to the PFX file
openssl='/usr/bin/openssl' # openssl version to use
#cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1 > ${passfile}
$openssl rand -base64 16 > ${passfile}

for cnvifull in `find "${pemsdir}" -name 'cert*.pem' -o -name '*chain*.pem'`
do
  cnvifile=${cnvifull}
  cnvipkey="${cnvifull%/*}/privkey.pem"

  cnvopem=`echo ${cnvifull} | sed -e "s#${pemsdir}#${pfxspath}#g"`
  cnvofull="${cnvopem%.*}.pfx"

  echo "- :-) ->"
  echo "-in    ${cnvifull}"
  echo "-inkey ${cnvipkey}"
  echo "-out   ${cnvofull}"

  mkdir -p ${cnvofull%/*}

  $openssl pkcs12 \
    -export \
    -in ${cnvifull} \
    -inkey ${cnvipkey} \
    -out ${cnvofull} \
    -passout file:${passfile}
done
