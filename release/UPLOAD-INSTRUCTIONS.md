# Custom Orchestrator JFrog Upload Instructions

## 📦 Artifact Details

- **GroupId**: `androidx.test.inditex`
- **ArtifactId**: `orchestrator-retry`
- **Version**: `1.7.0-v1`
- **Packaging**: `apk`
- **Size**: 873KB

## 📋 Files to Upload

Located in: `/Users/cngs/Inditex/android-test/release/`

```
orchestrator-retry-1.7.0-v1.apk       # Main APK artifact
orchestrator-retry-1.7.0-v1.apk.md5   # MD5 checksum
orchestrator-retry-1.7.0-v1.apk.sha1  # SHA1 checksum
orchestrator-retry-1.7.0-v1.pom       # Maven POM descriptor
```

---

## 🚀 Upload to JFrog Artifactory

### Option 1: Web UI Upload

1. **Login** to your JFrog Artifactory
2. **Navigate** to your Android libraries repository (e.g., `android-libs` or `android-local`)
3. **Create path**: `androidx/test/inditex/orchestrator-retry/1.7.0-v1/`
4. **Upload files**:
   - `orchestrator-retry-1.7.0-v1.apk`
   - `orchestrator-retry-1.7.0-v1.apk.md5`
   - `orchestrator-retry-1.7.0-v1.apk.sha1`
   - `orchestrator-retry-1.7.0-v1.pom`

### Option 2: cURL Upload (Command Line)

Replace placeholders with your actual values:

```bash
# Configuration
ARTIFACTORY_URL="https://your-artifactory.inditex.com/artifactory"
REPO_KEY="android-libs"  # or your repository name
USERNAME="your-username"
PASSWORD="your-password-or-token"

# Base path following Maven convention
BASE_PATH="androidx/test/inditex/orchestrator-retry/1.7.0-v1"

# Upload APK
curl -u ${USERNAME}:${PASSWORD} \
  -T orchestrator-retry-1.7.0-v1.apk \
  "${ARTIFACTORY_URL}/${REPO_KEY}/${BASE_PATH}/orchestrator-retry-1.7.0-v1.apk"

# Upload POM
curl -u ${USERNAME}:${PASSWORD} \
  -T orchestrator-retry-1.7.0-v1.pom \
  "${ARTIFACTORY_URL}/${REPO_KEY}/${BASE_PATH}/orchestrator-retry-1.7.0-v1.pom"

# Upload checksums
curl -u ${USERNAME}:${PASSWORD} \
  -T orchestrator-retry-1.7.0-v1.apk.md5 \
  "${ARTIFACTORY_URL}/${REPO_KEY}/${BASE_PATH}/orchestrator-retry-1.7.0-v1.apk.md5"

curl -u ${USERNAME}:${PASSWORD} \
  -T orchestrator-retry-1.7.0-v1.apk.sha1 \
  "${ARTIFACTORY_URL}/${REPO_KEY}/${BASE_PATH}/orchestrator-retry-1.7.0-v1.apk.sha1"
```

### Option 3: JFrog CLI Upload

```bash
# Install JFrog CLI if not already installed
# brew install jfrog-cli

# Configure server
jfrog config add --artifactory-url=https://your-artifactory.inditex.com/artifactory \
  --user=your-username --password=your-password

# Upload with pattern
jfrog rt upload \
  "orchestrator-retry-1.7.0-v1.*" \
  "android-libs/androidx/test/inditex/orchestrator-retry/1.7.0-v1/" \
  --flat=true
```

---

## ✅ Verify Upload

After uploading, check the artifact URL:

```
https://your-artifactory.inditex.com/artifactory/android-libs/androidx/test/inditex/orchestrator-retry/1.7.0-v1/
```

You should see:
- orchestrator-retry-1.7.0-v1.apk
- orchestrator-retry-1.7.0-v1.pom
- Checksum files

---

## 🔧 Usage in Projects

### Step 1: Update Version Catalog

Add to `gradle/libsTesting.versions.toml`:

```toml
[versions]
orchestrator-retry = "1.7.0-v1"

[libraries]
androidx-test-orchestrator-custom = { 
    module = "androidx.test.inditex:orchestrator-retry", 
    version.ref = "orchestrator-retry" 
}
```

### Step 2: Update build.gradle

In `ca-ui-testing/build.gradle`:

```groovy
dependencies {
    // Replace local file with JFrog artifact
    androidTestUtil(libsTesting.androidx.test.orchestrator.custom) {
        artifact {
            name = 'orchestrator-retry'
            type = 'apk'
        }
    }
    
    // Still need test-services for 1.7.0 compatibility
    androidTestUtil(libsTesting.androidx.test.services)
}
```

### Step 3: Ensure JFrog Repository is Configured

In root `build.gradle.kts`, verify repository is configured:

```kotlin
allprojects {
    repositories {
        maven {
            url = uri("${properties["artifactory_context_url"]}/${properties["artifactory_resolve_repokey"]}")
            credentials {
                username = "${properties["artifactory_username"]}"
                password = "${properties["artifactory_password"]}"
            }
        }
    }
}
```

---

## 📝 Version Management

### Naming Convention

```
1.7.0-v1   # Initial release
1.7.0-v2   # Bug fixes / improvements
1.7.0-v3   # Additional features
```

### Update Process

When you update the orchestrator:

1. **Rebuild**: 
   ```bash
   cd /Users/cngs/Inditex/android-test
   export PATH="$HOME/.asdf/installs/ivm-python/3.12.5/bin:$PATH"
   bazelisk build //runner/android_test_orchestrator/stubapp:stubapp
   ```

2. **Create new version**:
   ```bash
   VERSION="1.7.0-v2"
   cp bazel-bin/runner/android_test_orchestrator/stubapp/stubapp.apk \
      release/orchestrator-retry-${VERSION}.apk
   ```

3. **Update POM** (change version in XML)

4. **Generate checksums**:
   ```bash
   md5 -q orchestrator-retry-${VERSION}.apk > orchestrator-retry-${VERSION}.apk.md5
   shasum -a 1 orchestrator-retry-${VERSION}.apk | awk '{print $1}' > orchestrator-retry-${VERSION}.apk.sha1
   ```

5. **Upload to JFrog** (new version path)

6. **Update version catalog** in projects

---

## 🏢 Recommended JFrog Repository Structure

```
artifactory/
└── android-libs/               # Your repository
    └── androidx/
        └── test/
            └── inditex/
                └── orchestrator-retry/
                    ├── 1.7.0-v1/
                    │   ├── orchestrator-retry-1.7.0-v1.apk
                    │   ├── orchestrator-retry-1.7.0-v1.apk.md5
                    │   ├── orchestrator-retry-1.7.0-v1.apk.sha1
                    │   └── orchestrator-retry-1.7.0-v1.pom
                    ├── 1.7.0-v2/
                    │   └── ...
                    └── maven-metadata.xml  # Auto-generated by Artifactory
```

---

## 📊 Features of This Custom Orchestrator

- ✅ **Immediate retry** after test failure (not batch retry)
- ✅ **Intelligent retry logic** - only retries failed tests
- ✅ **Flaky test detection** - marks tests that pass on retry
- ✅ **Per-test failure tracking** - accurate before/after comparison
- ✅ **Configurable retry count** via `-Pcucumber.retry.count=N`
- ✅ **Compatible with androidx.test 1.6.x/1.7.x** infrastructure
- ✅ **Works with Cucumber Android** test runner

---

## 🔒 Security Notes

- Store credentials in `~/.gradle/gradle.properties` or use environment variables
- Never commit passwords to Git
- Consider using JFrog API tokens instead of passwords
- Use HTTPS for all Artifactory connections

---

## 📞 Support

For issues with:
- **Orchestrator functionality**: Contact QA automation team
- **JFrog upload/access**: Contact DevOps or Artifactory admins
- **Integration issues**: Check repository configuration in build files

---

**Generated**: November 3, 2025  
**Source**: /Users/cngs/Inditex/android-test (main branch, commit with retry logic)
