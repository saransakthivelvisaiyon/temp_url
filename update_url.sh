#!/bin/bash

# Step 0: Ensure URL file exists
touch cloudflared_url.txt

# Step 1: Start Cloudflared in background and log output
cloudflared tunnel --url http://localhost:8000 > cloudflared.log 2>&1 &

# Step 2: Capture PID of Cloudflared (optional if you want to stop later)
CLOUDFLARED_PID=$!

# Step 3: Poll the log file every 1s for up to 30s to capture the URL
for i in {1..30}; do
    URL=$(grep -o "https://.*trycloudflare.com" cloudflared.log | head -n 1)
    if [ ! -z "$URL" ]; then
        echo "$URL" > cloudflared_url.txt
        echo "✅ Cloudflared URL captured: $URL"
        break
    fi
    sleep 1
done

# Step 4: Git add, commit & push the captured URL
git add cloudflared_url.txt
git commit -m "Updated Cloudflared URL $(date)"
git push origin master

# Step 5: Optional — Leave Cloudflared running or stop it
# kill $CLOUDFLARED_PID
