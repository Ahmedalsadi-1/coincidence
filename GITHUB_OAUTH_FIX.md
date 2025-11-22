## 🎯 **GOOGLE OAUTH LOCALHOST ISSUE - SOLVED!**

### **The Problem:**
Google OAuth rejects localhost redirect URIs for security reasons. This is why you're getting 404 errors.

### **✅ SOLUTION: Use GitHub OAuth (Easiest)**

GitHub OAuth works perfectly with localhost!

---

## 🔧 **STEP-BY-STEP GITHUB OAUTH SETUP:**

### **Step 1: Create GitHub OAuth App**
1. Go to: https://github.com/settings/developers
2. Click **"OAuth Apps"** → **"New OAuth App"**
3. Fill out the form:
   - **Application name:** `Coincidence Dev`
   - **Homepage URL:** `http://localhost:5174`
   - **Authorization callback URL:** `http://localhost:5800/v1/auth/callback/github`
4. Click **"Register application"**

### **Step 2: Get Your Credentials**
After creating the app, you'll see:
- **Client ID:** `abc123...` (copy this)
- **Client Secret:** `def456...` (copy this)

### **Step 3: Update Environment**
Edit `coincidence/apps/api/.env`:
```bash
# GitHub OAuth (works with localhost!)
GITHUB_CLIENT_ID=your-github-client-id-here
GITHUB_CLIENT_SECRET=your-github-client-secret-here
GITHUB_CALLBACK_URL=http://localhost:5800/v1/auth/callback/github
```

### **Step 4: Restart API Server**
```bash
pkill -f "mock-api-server" && sleep 2
cd coincidence && node mock-api-server.js &
```

### **Step 5: Test GitHub OAuth**
1. Visit: http://localhost:5174/
2. Click chat input → Login modal appears
3. Click **"Sign in with GitHub"** (dark button)
4. Redirects to GitHub → Sign in → Authorize
5. Redirects back → Success! ✅

---

## 🚀 **ALTERNATIVE: Use ngrok (If You Want Google OAuth)**

### **Step 1: Install ngrok**
```bash
# macOS
brew install ngrok

# Or download from: https://ngrok.com/download
```

### **Step 2: Start Tunnel**
```bash
ngrok http 5800
```
**Copy the HTTPS URL:** `https://abc123.ngrok.io`

### **Step 3: Update Google Console**
Add to **Authorized redirect URIs:**
```
https://abc123.ngrok.io/v1/auth/callback/google
```

### **Step 4: Update Server**
Edit `coincidence/mock-api-server.js`:
```javascript
redirect_uri: 'https://abc123.ngrok.io/v1/auth/callback/google'
```

---

## ✅ **WHY THIS WORKS:**

- **GitHub OAuth**: Accepts localhost redirect URIs ✅
- **Google OAuth**: Rejects localhost for security reasons ❌
- **ngrok**: Creates public HTTPS tunnel that Google accepts ✅

**Try GitHub OAuth first - it's much easier and works perfectly with localhost!** 🎉

Let me know if you need help with the GitHub OAuth setup!