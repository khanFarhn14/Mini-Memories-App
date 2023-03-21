# **Mini Memories**
This is an application that records videos and saves them to Firebase

As a practice exercise, I created this application to save files to the cloud of Firebase

## **Environment Setup**

### Dependencies

Run this Command on your Terminal

Camera & Video plugin
```bash
  flutter pub add camera
  flutter pub add video_player
```

### **Firebase Environment Setup**
After creating Firebase Project and adding setting up changes in android file

Firebase Dependencies
```bash
  flutter pub add firebase_auth
  flutter pub add cloud_firestore
  flutter pub add firebase_core
  flutter pub add firebase_storage
```

## Android Specific prequisites

Go to Android/app/build.gradle search for minSdkVersion

**Increase minSdkVersion to 21**

Add Internet Permission on your AndroidManifest.xml file at /android/app/src/main/AndroidManifest.xml

```bash
<uses-permission android:name="android.permission.INTERNET"/>
```

<!-- ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
``` -->
