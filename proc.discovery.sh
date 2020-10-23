#!/usr/bin/env bash
set -eu

PROCESS_LIST=$(ps -ax --no-headers -o vsz,comm --sort +comm | awk '!colname[$2]++{if($1 != 0){print $2}}')

if [ "${PROCESS_LIST}" = "" ] ;then
    echo "ZBX_NOTSUPPORTED"
    exit 1
fi

echo "{"
echo "  \"data\":["
IFS=$'\n'
FIRST=1
for VER in ${PROCESS_LIST}
do
  PROC_NAME="$(echo ${VER} | awk -F'\t' '{print $1}')"
  if [ ${FIRST} -eq 1 ] ; then
    echo ""
    FIRST=0
  else
      echo ","
  fi
  echo -e -n "\t\t{ \"{#PROC_NAME}\":\"${PROC_NAME}\" }"
done
echo ""
echo "  ]"
echo "}"
