#!/bin/bash

touch cloudflared_url.txt

cloudflared tunnel --url http://localhost:8000 > cloudflared.log 2>&1 &

CLOUDFLARED_PID=$!

# Polling the log file every 1s for up to 30s to capture the URL
for i in {1..30}; do
    URL=$(grep -o "https://.*trycloudflare.com" cloudflared.log | head -n 1)
    if [ ! -z "$URL" ]; then
        echo "$URL" > cloudflared_url.txt
        echo "Cloudflared URL captured: $URL"
        break
    fi
    sleep 1
done

git add cloudflared_url.txt
git commit -m "Updated Cloudflared URL $(date)"
git push origin master

# Leave Cloudflared running or stop it
# kill $CLOUDFLARED_PID
