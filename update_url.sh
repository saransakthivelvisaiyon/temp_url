#!/bin/bash

touch cloudflared_url.txt

# Step 1: Run Cloudflared & capture URL
( cloudflared tunnel --url http://localhost:8000 2>&1 | grep -o -m 1 "https://.*trycloudflare.com" > cloudflared_url.txt ) &

# Step 2: Wait for URL capture
sleep 5

# Step 3: Git push the updated URL
git add cloudflared_url.txt
git commit -m "Updated Cloudflared URL $(date)"
git push origin master

