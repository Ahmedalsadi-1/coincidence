## 🚨 **GOOGLE OAUTH 404 ERROR - REDIRECT URI MISMATCH**

### **The Problem:**
Google is rejecting the OAuth request with a 404 error because the redirect URI doesn't match what's configured in Google Cloud Console.

### **What We Send:**
```
http://localhost:5800/v1/auth/callback/google
```

### **What Google Expects:**
Must match **exactly** what's in Google Cloud Console.

---

## 🔧 **FIX: Update Google Cloud Console**

### **Step 1: Go to Google Cloud Console**
```
https://console.cloud.google.com/
```

### **Step 2: Navigate to Credentials**
- APIs & Services → Credentials
- Find your OAuth 2.0 Client ID
- Click **EDIT**

### **Step 3: Check Authorized Redirect URIs**
**Current list should have:**
```
http://localhost:5800/v1/auth/callback/google
```

**If it's different or missing:**
- **DELETE ALL** existing URIs
- Click **+ ADD URI**
- **Paste exactly:**
```
http://localhost:5800/v1/auth/callback/google
```
- **NO trailing slash**
- **NO extra spaces**
- **http:// not https://**

### **Step 4: Save and Wait**
- Click **SAVE** at bottom
- Wait **5-10 minutes** for Google to update
- Clear browser cache (Ctrl+Shift+R)

---

## 🧪 **Alternative: Test with Different URI**

If localhost doesn't work, try using `127.0.0.1` instead:

**In Google Cloud Console, use:**
```
http://127.0.0.1:5800/v1/auth/callback/google
```

**And update our server to use:**
```bash
# In coincidence/mock-api-server.js, change:
redirect_uri: 'http://localhost:5800/v1/auth/callback/google'
# To:
redirect_uri: 'http://127.0.0.1:5800/v1/auth/callback/google'
```

---

## 🔍 **Debug Steps:**

### **1. Check Current Configuration**
Run this command to see what URI we're sending:
```bash
curl -s "http://localhost:5800/v1/auth/google" | grep -o "redirect_uri=[^&]*" | sed 's/redirect_uri=//' | sed 's/%3A/:/g' | sed 's/%2F/\//g'
```

### **2. Verify Google Console**
- Go to your OAuth 2.0 Client ID
- Check "Authorized redirect URIs"
- Make sure it matches exactly

### **3. Test Direct Link**
Try this direct OAuth link:
```
https://accounts.google.com/oauth/authorize?client_id=351029698035-6kueu4as5bce178bimna3noa92ogc2tl.apps.googleusercontent.com&redirect_uri=http://localhost:5800/v1/auth/callback/google&response_type=code&scope=openid%20email%20profile&access_type=offline&prompt=consent
```

---

## ✅ **Success Signs:**
- ✅ No more 404 error
- ✅ Google OAuth consent page loads
- ✅ Can sign in and grant permissions
- ✅ Redirects back to your app

**Update your Google Cloud Console redirect URI and try again!** 🎯