#!/bin/bash
# set -e: exit asap if a command exits with a non-zero status
set -e
trap ctrl_c INT
function ctrl_c() {
  exit 0
}

rm /tmp/.X1-lock 2> /dev/null &
export DISPLAY=:1

sudo /usr/bin/supervisord
wait