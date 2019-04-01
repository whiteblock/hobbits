#!/bin/bash
if [ $# -lt 2 ];then
  echo "ERROR: incorrect number of arguments!"
  exit 1
elif [ ! -p /dev/stdin ]; then
  echo "No data piped into script"
  exit 1
fi
INPUT=$(cat |tr '\0' '|'; echo x) ; INPUT=${INPUT%?}
INFO=($(echo ${INPUT/\\n*/}))
PROTO=${INFO[0]}
VERSION=${INFO[1]}
COMMAND=${INFO[2]}
HEADERBODY=${INPUT/*$COMMAND/}
HEADERBODY=${HEADERBODY//|/\\x00}
HEADER=($(echo ${HEADER/\\n*/}))
BODY=${HEADERBODY/#$HEADER}
printf "$PROTO $VERSION $COMMAND$HEADER$BODY"
