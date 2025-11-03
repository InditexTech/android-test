# Custom Orchestrator - Quick Reference

## 📦 Distribution Package Location
```
/Users/cngs/Inditex/android-test/release/
```

## 🚀 Upload to JFrog

### Using the automated script:
```bash
cd /Users/cngs/Inditex/android-test/release
./upload-to-jfrog.sh
```

### Manual upload with cURL:
See `JFROG-UPLOAD-GUIDE.md` for detailed instructions

## 🎯 Maven Coordinates
```
groupId:    com.inditex.testing
artifactId: orchestrator-retry
version:    1.7.0
type:       apk
```

## 📝 Update build.gradle After Upload

In `/Users/cngs/Inditex/mob-zaraappandroid/code/ca-ui-testing/build.gradle`:

**Comment out the local APK line:**
```groovy
// androidTestUtil(files('libs/retry-orchestrator.apk'))
```

**Uncomment the JFrog line:**
```groovy
androidTestUtil("com.inditex.testing:orchestrator-retry:1.7.0@apk")
```

## ✅ Verification Checksums
```
MD5:  5ec910a515aea4378b51699fe4ba4853
SHA1: 19de60e4964a09b832f4300e35379f1e96e8b1c3
```

## 📚 Files Included
1. `orchestrator-retry-1.7.0.apk` (873 KB) - The custom orchestrator
2. `orchestrator-retry-1.7.0.pom` (1.2 KB) - Maven descriptor
3. Checksum files (.md5, .sha1) for verification
4. `upload-to-jfrog.sh` - Automated upload script
5. `JFROG-UPLOAD-GUIDE.md` - Complete documentation

## 🔧 Current Status
- ✅ Custom orchestrator built (version 1.7.0)
- ✅ JFrog distribution package prepared
- ✅ Upload script created
- ✅ build.gradle prepared with both options
- ⏳ Ready for manual upload to JFrog

## 📖 Next Steps
1. Run `./upload-to-jfrog.sh` to upload to JFrog
2. After successful upload, update build.gradle to use JFrog version
3. Remove local APK if desired: `rm libs/retry-orchestrator.apk`
