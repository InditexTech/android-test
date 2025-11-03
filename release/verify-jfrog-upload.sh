#!/bin/bash

# Verify the orchestrator was uploaded correctly to Inditex JFrog

echo "🔍 Verifying Custom Orchestrator in JFrog..."
echo ""

read -p "JFrog Username: " USERNAME
read -sp "JFrog API Key: " API_KEY
echo ""
echo ""

BASE_URL="https://inditex.jfrog.io/artifactory/gradle-snapshot-local/com/inditex/testing/orchestrator-retry/1.7.0"

echo "Checking artifacts at:"
echo "  $BASE_URL"
echo ""

check_file() {
    local file=$1
    local url="${BASE_URL}/${file}"
    
    echo -n "  Checking ${file}... "
    
    http_code=$(curl -s -o /dev/null -w "%{http_code}" -u "${USERNAME}:${API_KEY}" "$url")
    
    if [ "$http_code" = "200" ]; then
        echo "✅ Found"
        return 0
    else
        echo "❌ Not found (HTTP $http_code)"
        return 1
    fi
}

echo "Artifacts:"
check_file "orchestrator-retry-1.7.0.apk"
check_file "orchestrator-retry-1.7.0.pom"
check_file "orchestrator-retry-1.7.0.apk.md5"
check_file "orchestrator-retry-1.7.0.apk.sha1"
check_file "orchestrator-retry-1.7.0.pom.md5"
check_file "orchestrator-retry-1.7.0.pom.sha1"

echo ""
echo "Full artifact URL:"
echo "  https://inditex.jfrog.io/artifactory/gradle-snapshot-local/com/inditex/testing/orchestrator-retry/1.7.0/"
echo ""
