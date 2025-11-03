# Custom Android Test Orchestrator with Retry Logic - JFrog Upload Guide

## 📦 Distribution Package

This directory contains the custom Android Test Orchestrator v1.7.0 with intelligent retry logic.

### Files for Upload:
```
orchestrator-retry-1.7.0.apk       (873 KB) - The custom orchestrator APK
orchestrator-retry-1.7.0.pom       (1.2 KB) - Maven POM descriptor
orchestrator-retry-1.7.0.apk.md5   (33 B)   - APK MD5 checksum
orchestrator-retry-1.7.0.apk.sha1  (41 B)   - APK SHA1 checksum
orchestrator-retry-1.7.0.pom.md5   (33 B)   - POM MD5 checksum
orchestrator-retry-1.7.0.pom.sha1  (41 B)   - POM SHA1 checksum
```

## 🚀 Manual Upload to JFrog

### Step 1: Prepare Your JFrog Credentials

You'll need:
- **JFrog URL**: Your organization's Artifactory URL
- **Repository**: The target repository (e.g., `libs-release-local`)
- **Username**: Your JFrog username
- **API Key** or **Password**: Your authentication credentials

### Step 2: Upload Using cURL

Replace the placeholders with your actual values:

```bash
# Set your JFrog details
JFROG_URL="https://your-org.jfrog.io/artifactory"
REPO_NAME="libs-release-local"
USERNAME="your-username"
API_KEY="your-api-key"

# Maven coordinates
GROUP_PATH="com/inditex/testing"
ARTIFACT_ID="orchestrator-retry"
VERSION="1.7.0"

# Base path in JFrog
BASE_PATH="${JFROG_URL}/${REPO_NAME}/${GROUP_PATH}/${ARTIFACT_ID}/${VERSION}"

# Upload APK
curl -u ${USERNAME}:${API_KEY} -X PUT "${BASE_PATH}/orchestrator-retry-${VERSION}.apk" \
     -T orchestrator-retry-1.7.0.apk

# Upload POM
curl -u ${USERNAME}:${API_KEY} -X PUT "${BASE_PATH}/orchestrator-retry-${VERSION}.pom" \
     -T orchestrator-retry-1.7.0.pom

# Upload checksums
curl -u ${USERNAME}:${API_KEY} -X PUT "${BASE_PATH}/orchestrator-retry-${VERSION}.apk.md5" \
     -T orchestrator-retry-1.7.0.apk.md5

curl -u ${USERNAME}:${API_KEY} -X PUT "${BASE_PATH}/orchestrator-retry-${VERSION}.apk.sha1" \
     -T orchestrator-retry-1.7.0.apk.sha1

curl -u ${USERNAME}:${API_KEY} -X PUT "${BASE_PATH}/orchestrator-retry-${VERSION}.pom.md5" \
     -T orchestrator-retry-1.7.0.pom.md5

curl -u ${USERNAME}:${API_KEY} -X PUT "${BASE_PATH}/orchestrator-retry-${VERSION}.pom.sha1" \
     -T orchestrator-retry-1.7.0.pom.sha1
```

### Step 3: Verify Upload

Check JFrog UI or use cURL to verify:

```bash
curl -u ${USERNAME}:${API_KEY} "${BASE_PATH}/"
```

## 📝 Update Your Gradle Configuration

After uploading to JFrog, update your `build.gradle`:

### 1. Add JFrog Repository (in root `build.gradle` or `settings.gradle`):

```groovy
repositories {
    maven {
        url "https://your-org.jfrog.io/artifactory/libs-release-local"
        credentials {
            username = project.findProperty("jfrog.username") ?: System.getenv("JFROG_USERNAME")
            password = project.findProperty("jfrog.password") ?: System.getenv("JFROG_PASSWORD")
        }
    }
}
```

### 2. Update Module `build.gradle` (`ca-ui-testing/build.gradle`):

Replace:
```groovy
// androidTestUtil(libsTesting.androidx.test.orchestrator)  // Replaced with custom retry-aware orchestrator
androidTestUtil(files('libs/retry-orchestrator.apk'))
androidTestUtil(libsTesting.androidx.test.services)  // Required for custom orchestrator 1.7.0
```

With:
```groovy
// Custom orchestrator with retry logic from JFrog
androidTestUtil("com.inditex.testing:orchestrator-retry:1.7.0@apk")
androidTestUtil(libsTesting.androidx.test.services)  // Required for custom orchestrator 1.7.0
```

## 🔍 Maven Coordinates

```xml
<dependency>
    <groupId>com.inditex.testing</groupId>
    <artifactId>orchestrator-retry</artifactId>
    <version>1.7.0</version>
    <type>apk</type>
</dependency>
```

## ✨ Features

This custom orchestrator includes:
- ✅ Immediate retry logic (no test collection overhead)
- ✅ Flaky test detection and reporting
- ✅ Per-test retry tracking
- ✅ Detailed logging with attempt counts
- ✅ Compatible with androidx.test 1.6.1+
- ✅ Zero changes to test code required
- ✅ Works with Cucumber and JUnit tests

## 🎯 Usage

Run tests with retry enabled:
```bash
./gradlew :ca-ui-testing:connectedBetaLocalDebugAndroidTest \\
  -Pcucumber.env=local \\
  -Pcucumber.retry.count=2 \\
  -Pcucumber.tags=@yourTag
```

## 📊 Retry Statistics

Check logcat for retry information:
```bash
adb logcat | grep "RETRY:"
adb logcat | grep "=== RETRY SUMMARY ==="
```

## 🔧 Troubleshooting

### If download fails from JFrog:
1. Verify credentials are correct
2. Check repository permissions
3. Confirm artifact path: `com/inditex/testing/orchestrator-retry/1.7.0/`
4. Ensure `@apk` type is specified in dependency

### If retry logic doesn't work:
1. Verify `retryCount` parameter is passed in testInstrumentationRunnerArguments
2. Check orchestrator is being used: `adb logcat | grep "Retry mode enabled"`
3. Confirm testOptions.execution = 'ANDROIDX_TEST_ORCHESTRATOR'

## 📦 Version History

- **1.7.0** (Nov 2025) - Initial release with immediate retry logic
  - Based on androidx-test main branch (orchestrator 1.7.0)
  - Immediate retry on failure (no test collection overhead)
  - Flaky test detection and reporting
  - Per-test attempt tracking

## 📞 Support

For issues or questions, check:
- Source: `/Users/cngs/Inditex/android-test` (branch: main)
- Built APK: `bazel-bin/runner/android_test_orchestrator/stubapp/stubapp.apk`
- MD5: `5ec910a515aea4378b51699fe4ba4853`
