#!/bin/sh
# The blog is wired up: its page loads the front end from the lab's S3 bucket, the front end calls
# the lab's API Gateway (upstream's deploy step wrote the URL into it), and the posts table holds
# upstream's seed data.
set -eu
page=$(curl -fsS "$ISOLOOM_OUTPUT_APP")
bucket=$(printf '%s' "$page" | grep -o 'https://production-blog-awsgoat-bucket-[0-9]*\.s3\.us-east-1\.amazonaws\.com/build' | head -1)
[ -n "$bucket" ] || { echo "the page doesn't point at the lab bucket" >&2; exit 1; }
js=$(printf '%s' "$page" | grep -o '/static/js/main\.[0-9a-f]*\.js' | head -1)
curl -fsS "$bucket$js" | grep -q 'execute-api' || { echo "the front end has no API URL" >&2; exit 1; }
n=$(aws dynamodb scan --table-name blog-posts --select COUNT --query Count --output text)
[ "$n" -gt 0 ] || { echo "blog-posts is empty" >&2; exit 1; }
