# Firebase Authentication Troubleshooting Guide

## Issues Fixed ✅

### 1. **Facebook Login Showing "Something Went Wrong"**
- **Cause**: Missing Facebook SDK configuration on Android
- **Fix Applied**: Added Facebook SDK meta-data and activity to AndroidManifest.xml
- **Next Steps**: See "Facebook Setup" below

### 2. **Sign-In/Sign-Up Loading Forever**
- **Cause**: No timeout on authentication requests
- **Fix Applied**: Added 30-second timeout to prevent indefinite loading
- **Error Display**: Now shows specific timeout message if Firebase/network doesn't respond

### 3. **Generic Error Messages**
- **Cause**: Error handling wasn't extracting actual error details
- **Fix Applied**: Improved error messages to show actual Firebase/network error details
- **Benefit**: Users now see helpful error messages instead of generic "something went wrong"

---

## Setup Instructions 🔧

### 1. **Facebook Authentication Setup (Required for Facebook Login)**

#### Step 1: Get Your Facebook App ID
1. Go to [Facebook Developers](https://developers.facebook.com/apps)
2. Create a new app (or use existing one)
3. Copy your **App ID**

#### Step 2: Generate Your Key Hash
Run this command in your project:
```bash
keytool -exportcert -alias androiddebugkey -keystore ~/.android/keystore.jks | openssl dgst -sha1 -binary | openssl enc -base64
# On Windows, use (in Git Bash or WSL):
keytool -exportcert -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore | openssl dgst -sha1 -binary | openssl enc -base64
```

#### Step 3: Add Key Hash to Facebook App
1. In your Facebook app dashboard, go to Settings > Basic
2. Add your key hash in the "Android Key Hashes" section
3. Save

#### Step 4: Add Facebook App ID & Client Token to Android
Edit `android/app/src/main/res/values/strings.xml`:
```xml
<string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
<string name="facebook_client_token">YOUR_FACEBOOK_CLIENT_TOKEN</string>
```
Get your Client Token from: App Settings > Basic > Client Token

#### Step 5: Download Facebook SDK
The flutter_facebook_auth package will handle this automatically, but verify:
- Check `pubspec.yaml` has: `flutter_facebook_auth: ^7.1.5`

---

### 2. **Firebase Configuration (Already Set Up)**

Your Firebase is configured in:
- `lib/firebase_options.dart` - Generated from Google Services
- `android/app/google-services.json` - Required for Android

**Verify Firebase in Console**:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Enable "Email/Password" Authentication:
   - Go to Authentication > Sign-in method
   - Enable "Email/Password"

---

### 3. **Testing Flow**

#### Test Email/Password Sign-Up:
1. Tap "New here? Create an account"
2. Fill in: Name, Email, Password (min 6 chars)
3. Tap "Sign Up"
4. Should navigate to Home screen

**Issues**:
- "Invalid email" → Enter valid email format
- "Password is too weak" → Use at least 6 characters
- "Email already registered" → Use different email
- **Hangs for 30s then "timed out"** → Firebase not responding

#### Test Email/Password Sign-In:
1. Use credentials from a previous sign-up
2. Should navigate to Home screen

#### Test Facebook Login:
1. Tap "Continue with Facebook"
2. Facebook login popup should appear
3. Complete Facebook login
4. Should navigate to Home screen

**Issues**:
- Facebook popup doesn't appear → Android configuration missing
- "FB config" error → Check strings.xml has App ID
- App crashes → Key hash mismatch

---

## Detailed Error Messages 🔍

### You'll Now See Specific Errors:

| Error | Cause | Solution |
|-------|-------|----------|
| "No user found for that email." | Email doesn't exist | Sign up first with this email |
| "Incorrect password." | Wrong password | Check password and try again |
| "Email already registered." | Email in use | Use different email or sign in |
| "Request timed out..." | Firebase/network slow | Check internet, try again |
| "Facebook authentication failed..." | FB SDK not configured | Complete Facebook Setup steps |
| "Invalid email" | Malformed email | Use format: user@example.com |
| "Weak password" | Too short (<6 chars) | Use at least 6 characters |
| "No internet connection." | Device offline | Check WiFi/mobile data |

---

## Logs & Debugging 📋

The app now logs detailed information. Launch with:
```bash
flutter run
```

Look for logs in Android Studio logcat:
```
// Facebook login flow:
[FacebookAuth] [INFO] Facebook login: Starting login flow
[FacebookAuth] [INFO] Facebook login: Login result status = granted
[FacebookAuth] [INFO] Facebook login: Got access token, signing in with Firebase

// Sign in flow:
[FacebookAuth] [INFO] Email sign in started
[FacebookAuth] [DEBUG] Sign in response received
[FacebookAuth] [SUCCESS] Sign in successful
```

---

## Common Problems & Solutions 🛠️

### Problem: "Facebook login failed with unknown error"
**Solution**:
1. Verify Facebook App ID in `android/app/src/main/res/values/strings.xml`
2. Verify Key Hash matches in Facebook Developer Console
3. Check Facebook app has Android platform configured
4. Ensure Facebook app is set to Production or Development

### Problem: "Takes 30 seconds then shows timeout"
**Solution**:
1. Check Firebase Configuration is correct
2. Verify internet connection on device
3. Check if Firebase project is actually created
4. Try clearing app data and reinstalling

### Problem: "Sign up with valid email still says invalid"
**Solution**:
1. Check email format: `user@example.com`
2. Don't include spaces: ` user@example.com` ❌
3. Use real-looking email (some rejected by Firebase for safety)

### Problem: "Firebase error: PERMISSION_DENIED"
**Solution**:
1. Go to Firebase Console > Project Settings
2. Check Android SHA-1 hash matches your development key
3. Verify your phone's Google Play Services is up to date

---

## Next Steps 🚀

1. **Complete Facebook Setup** (Critical for FB login)
2. **Test Email/Password Auth** (Should work now with timeouts)
3. **Monitor Logs** (Use them to troubleshoot issues)
4. **Report Specific Errors** (Instead of "something went wrong")

---

## File Changes Made

| File | Change |
|------|--------|
| `android/app/src/main/AndroidManifest.xml` | Added Facebook SDK config & permissions |
| `android/app/src/main/res/values/strings.xml` | Created with FB App ID placeholder |
| `lib/core/errors/error_handler.dart` | Improved error message extraction |
| `lib/features/auth/data/datasources/auth_remote_datasource_impl.dart` | Added detailed logging for FB login |
| `lib/features/auth/presentation/providers/auth_provider.dart` | Added 30s timeout protection |

---

## Questions?
1. **Check the logs first** - they now have much more detail
2. **Verify Facebook credentials** - App ID and Key Hash
3. **Test with simple email/password** - Before complex FB login
4. **Report exact error message** - Instead of generic "something went wrong"
