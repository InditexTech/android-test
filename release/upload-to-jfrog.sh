#!/bin/bash
set -e
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Custom Orchestrator JFrog Upload${NC}"
if [ ! -f "orchestrator-retry-1.7.0.apk" ]; then
    echo -e "${RED}Error: orchestrator-retry-1.7.0.apk not found${NC}"
    exit 1
fi

read -p "JFrog URL (e.g., https://your-org.jfrog.io/artifactory): " JFROG_URL
read -p "Repository (e.g., libs-release-local): " REPO_NAME
read -p "Username: " USERNAME
read -sp "API Key: " API_KEY
echo ""

JFROG_URL=${JFROG_URL%/}
BASE_PATH="${JFROG_URL}/${REPO_NAME}/com/inditex/testing/orchestrator-retry/1.7.0"

echo -e "${YELLOW}Uploading to: ${BASE_PATH}${NC}"
read -p "Continue? (y/n): " CONFIRM
[ "$CONFIRM" != "y" ] && exit 0

upload() {
    echo -n "Uploading $1... "
    curl -s -u "${USERNAME}:${API_KEY}" -X PUT "${BASE_PATH}/$2" -T "$1" -o /dev/null && echo -e "${GREEN}✅${NC}" || echo -e "${RED}❌${NC}"
}

upload "orchestrator-retry-1.7.0.apk" "orchestrator-retry-1.7.0.apk"
upload "orchestrator-retry-1.7.0.pom" "orchestrator-retry-1.7.0.pom"
upload "orchestrator-retry-1.7.0.apk.md5" "orchestrator-retry-1.7.0.apk.md5"
upload "orchestrator-retry-1.7.0.apk.sha1" "orchestrator-retry-1.7.0.apk.sha1"
upload "orchestrator-retry-1.7.0.pom.md5" "orchestrator-retry-1.7.0.pom.md5"
upload "orchestrator-retry-1.7.0.pom.sha1" "orchestrator-retry-1.7.0.pom.sha1"

echo -e "${GREEN}✅ Upload complete!${NC}"
echo 'Add to build.gradle: androidTestUtil("com.inditex.testing:orchestrator-retry:1.7.0@apk")'
