#!/bin/bash
# set -e: exit asap if a command exits with a non-zero status
set -e
trap ctrl_c INT
function ctrl_c() {
  exit 0
}

rm /tmp/.X1-lock 2> /dev/null &

export DISPLAY=:1
Xvfb :1 -screen 0 3840x1080x24+32 -br +bs -ac &
x11vnc -display :1 -rfbport 5903 -shared -forever -clip 1920x1080+0+0 &
x11vnc -display :1 -rfbport 5902 -shared -forever -clip 1920x1080+1920+0 &
/opt/noVNC/utils/novnc_proxy --vnc localhost:5903 --listen 6001 &
/opt/noVNC/utils/novnc_proxy --vnc localhost:5902 --listen 6000 &

echo "Starting Chrome #1"
nohup chromium %u \
  --kiosk --start-fullscreen --incognito \
  --no-first-run \
  --disable-session-crashed-bubble \
  --disable-infobars \
  --disable-restore-background-contents  \
  --disable-translate  \
  --disable-gpu \
  --disable-dev-shm-usage \
  --disable-new-tab-first-run \
  --noerrdialogs \
  --no-sandbox \
  --window-size=1920,1080 \
  --window-position=1920,0 \
  https://web.alarmmonitor.de/d81702b4-2a15-474b-a038-4ace6e9d68b5?fixed1=0&fixed0=0 &

echo "Starting Chrome #2"
nohup chromium %u \
  --kiosk --start-fullscreen --incognito \
  --no-first-run \
  --disable-gpu \
  --disable-dev-shm-usage \
  --disable-session-crashed-bubble \
  --disable-infobars \
  --disable-restore-background-contents  \
  --disable-translate  \
  --disable-new-tab-first-run \
  --noerrdialogs \
  --no-sandbox \
  --window-size=1920,1080 \
  --window-position=0,0 \
  https://web.alarmmonitor.de/d81702b4-2a15-474b-a038-4ace6e9d68b5?fixed1=1&fixed1=1 &
  
#chromium --window-size="1920,1080" --window-position="0,0" --allow-running-insecure-content --disable-gpu --no-sandbox --test-type --app=https://web.alarmmonitor.de/d81702b4-2a15-474b-a038-4ace6e9d68b5?fixed1=0&fixed0=0 2>&1 /home/dockeruser/browser1.log &
echo "Starting Chrome #2"
#chromium --window-size="1920,1080" --window-position="1920,0" --allow-running-insecure-content --disable-gpu --no-sandbox --test-type --app=https://web.alarmmonitor.de/d81702b4-2a15-474b-a038-4ace6e9d68b5?fixed1=1&fixed0=1 2>&1 /home/dockeruser/browser2.log &


wait