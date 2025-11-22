## 🧪 **TEST GITHUB OAUTH SETUP**

### **Step 1: Create GitHub OAuth App**
1. Go to: https://github.com/settings/developers
2. **OAuth Apps** → **New OAuth App**
3. Configure:
   - **Application name:** `Coincidence Dev`
   - **Homepage URL:** `http://localhost:5174`
   - **Authorization callback URL:** `http://localhost:5800/v1/auth/callback/github`
4. **Register application**

### **Step 2: Get Credentials**
- Copy **Client ID**
- Copy **Client Secret**

### **Step 3: Update Environment**
```bash
# Edit coincidence/apps/api/.env
GITHUB_CLIENT_ID=paste-your-client-id-here
GITHUB_CLIENT_SECRET=paste-your-client-secret-here
```

### **Step 4: Test**
```bash
# Restart API server
pkill -f "mock-api-server" && sleep 2
cd coincidence && node mock-api-server.js &

# Test OAuth URL
curl -s "http://localhost:5800/v1/auth/github" | head -1
```

**Expected:** Redirect to GitHub OAuth page

### **Step 5: Full Test**
1. Visit: http://localhost:5174/
2. Click "Sign in with GitHub"
3. Complete OAuth flow
4. Success! ✅

---

## 📋 **GITHUB OAUTH VS GOOGLE OAUTH:**

| Feature | GitHub OAuth | Google OAuth |
|---------|-------------|--------------|
| **Localhost Support** | ✅ Works | ❌ 404 Error |
| **Setup Time** | 5 minutes | 15+ minutes |
| **User Data** | Username, email | Full profile |
| **Reliability** | Very reliable | Sometimes blocks localhost |

**GitHub OAuth is perfect for development and testing!** 🚀