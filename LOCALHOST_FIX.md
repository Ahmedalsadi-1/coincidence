## 🚨 **LOCALHOST REDIRECT URI ISSUE - ALTERNATIVE SOLUTIONS**

Since Google is rejecting localhost/127.0.0.1 redirect URIs, let's use **ngrok** to create a public tunnel for testing.

---

## 🔧 **SOLUTION 1: Use ngrok (Recommended)**

### **Step 1: Install ngrok**
```bash
# Download and install ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update && sudo apt install ngrok

# Or for macOS:
brew install ngrok
```

### **Step 2: Start ngrok tunnel**
```bash
# Start ngrok on port 5800 (our API server)
ngrok http 5800
```

**Copy the HTTPS URL it gives you, like:**
```
https://abc123.ngrok.io
```

### **Step 3: Update Google Cloud Console**
1. Go to: https://console.cloud.google.com/
2. APIs & Services → Credentials
3. Find your OAuth 2.0 Client ID → EDIT
4. **Authorized redirect URIs:** Add:
   ```
   https://abc123.ngrok.io/v1/auth/callback/google
   ```
5. Click **SAVE**

### **Step 4: Update Server Code**
```bash
# Edit coincidence/mock-api-server.js
# Change the redirect_uri to use ngrok URL:
redirect_uri: 'https://abc123.ngrok.io/v1/auth/callback/google'
```

### **Step 5: Restart and Test**
```bash
pkill -f "mock-api-server" && sleep 2
cd coincidence && node mock-api-server.js &
```

Now test with: http://localhost:5174/

---

## 🔄 **SOLUTION 2: Use GitHub OAuth Instead**

Since Google OAuth is having issues with localhost, let's test with GitHub OAuth which works better with localhost.

### **Step 1: Create GitHub OAuth App**
1. Go to: https://github.com/settings/developers
2. **OAuth Apps** → **New OAuth App**
3. Fill out:
   - **Application name:** Coincidence Dev
   - **Homepage URL:** http://localhost:5174
   - **Authorization callback URL:** http://localhost:5800/v1/auth/callback/github
4. Click **Register application**

### **Step 2: Get Credentials**
- **Client ID:** Copy this
- **Client Secret:** Copy this

### **Step 3: Update Environment**
```bash
# Edit coincidence/apps/api/.env
GITHUB_CLIENT_ID=your-github-client-id
GITHUB_CLIENT_SECRET=your-github-client-secret
```

### **Step 4: Test GitHub OAuth**
- Visit: http://localhost:5174/
- Click "Sign in with GitHub"
- Should work with localhost!

---

## 🧪 **SOLUTION 3: Quick Test with Direct URL**

Test if the issue is with the redirect URI format by trying a direct OAuth URL:

```bash
# Replace YOUR_CLIENT_ID with your actual Google Client ID
curl -s "https://accounts.google.com/oauth/authorize?client_id=YOUR_CLIENT_ID&redirect_uri=http://localhost:5800/v1/auth/callback/google&response_type=code&scope=openid%20email%20profile"
```

If this gives a 404, then Google definitely doesn't accept localhost URIs for your app.

---

## 📞 **WHY LOCALHOST DOESN'T WORK:**

Google OAuth has restrictions on localhost redirect URIs for security reasons. They prefer public HTTPS URLs for production apps.

**Use ngrok or GitHub OAuth for testing!** 🎯