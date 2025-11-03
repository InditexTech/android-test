# Upload Custom Orchestrator to Inditex JFrog

## 🎯 Target Repository
```
URL: https://inditex.jfrog.io/artifactory/gradle-snapshot-local/
```

## 🚀 Quick Upload

Run the upload script:
```bash
cd /Users/cngs/Inditex/android-test/release
./upload-to-jfrog.sh
```

When prompted, enter:
- **JFrog URL**: `https://inditex.jfrog.io/artifactory`
- **Repository**: `gradle-snapshot-local`
- **Username**: Your Inditex JFrog username
- **API Key**: Your Inditex JFrog API key

## 📋 What Gets Uploaded

The orchestrator will be uploaded to:
```
https://inditex.jfrog.io/artifactory/gradle-snapshot-local/
  └── com/inditex/testing/orchestrator-retry/1.7.0/
      ├── orchestrator-retry-1.7.0.apk
      ├── orchestrator-retry-1.7.0.pom
      ├── orchestrator-retry-1.7.0.apk.md5
      ├── orchestrator-retry-1.7.0.apk.sha1
      ├── orchestrator-retry-1.7.0.pom.md5
      └── orchestrator-retry-1.7.0.pom.sha1
```

## 🔧 Configure Gradle to Use JFrog

### Step 1: Add JFrog Repository

Add to your **root `build.gradle.kts`** or **`settings.gradle.kts`**:

```kotlin
repositories {
    maven {
        url = uri("https://inditex.jfrog.io/artifactory/gradle-snapshot-local/")
        credentials {
            username = providers.gradleProperty("jfrog.username")
                .orElse(providers.environmentVariable("JFROG_USERNAME"))
                .orNull
            password = providers.gradleProperty("jfrog.password")
                .orElse(providers.environmentVariable("JFROG_PASSWORD"))
                .orNull
        }
    }
}
```

Or for **Groovy `build.gradle`**:
```groovy
repositories {
    maven {
        url "https://inditex.jfrog.io/artifactory/gradle-snapshot-local/"
        credentials {
            username = project.findProperty("jfrog.username") ?: System.getenv("JFROG_USERNAME")
            password = project.findProperty("jfrog.password") ?: System.getenv("JFROG_PASSWORD")
        }
    }
}
```

### Step 2: Add Credentials

Add to `~/.gradle/gradle.properties`:
```properties
jfrog.username=your-username
jfrog.password=your-api-key
```

Or set environment variables:
```bash
export JFROG_USERNAME="your-username"
export JFROG_PASSWORD="your-api-key"
```

### Step 3: Update Module build.gradle

In `/Users/cngs/Inditex/mob-zaraappandroid/code/ca-ui-testing/build.gradle`:

**Replace:**
```groovy
androidTestUtil(files('libs/retry-orchestrator.apk'))
```

**With:**
```groovy
androidTestUtil("com.inditex.testing:orchestrator-retry:1.7.0@apk")
```

## ✅ Verify Upload

After uploading, verify the artifact is accessible:
```bash
curl -u your-username:your-api-key \
  "https://inditex.jfrog.io/artifactory/gradle-snapshot-local/com/inditex/testing/orchestrator-retry/1.7.0/"
```

## 🧪 Test Gradle Download

```bash
cd /Users/cngs/Inditex/mob-zaraappandroid/code
./gradlew :ca-ui-testing:dependencies --configuration androidTestUtil
```

Look for:
```
com.inditex.testing:orchestrator-retry:1.7.0@apk
```

## 📦 Maven Coordinates

```xml
## Maven Coordinates

```
groupId: com.inditex.testing
artifactId: orchestrator-retry
version: 1.7.0
type: apk
```

Full dependency declaration:
```gradle
androidTestUtil("com.inditex.testing:orchestrator-retry:1.7.0@apk")
```
```

## 🔐 Security Note

⚠️ Never commit JFrog credentials to Git. Always use:
- `gradle.properties` (in home directory, not project)
- Environment variables
- CI/CD secret management
