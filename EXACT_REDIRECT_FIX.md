## 🎯 **EXACT STEPS TO FIX YOUR GOOGLE OAUTH 404 ERROR**

### **Step 1: Check What We Send**
Run this command to see the exact redirect URI we're sending:
```bash
curl -s "http://localhost:5800/v1/auth/google" | grep -o "redirect_uri=[^&]*" | sed 's/redirect_uri=//' | sed 's/%3A/:/g' | sed 's/%2F/\//g'
```

**Expected output:** `http://localhost:5800/v1/auth/callback/google`

### **Step 2: Update Google Cloud Console**
1. Go to: https://console.cloud.google.com/
2. APIs & Services → Credentials
3. Find your OAuth 2.0 Client ID
4. Click **EDIT**
5. Scroll to **Authorized redirect URIs**
6. **DELETE ALL** existing URIs
7. Click **+ ADD URI**
8. **Paste exactly:**
   ```
   http://localhost:5800/v1/auth/callback/google
   ```
9. Click **SAVE**

### **Step 3: Wait and Test**
1. Wait **5-10 minutes** for Google to update
2. Clear browser cache (Ctrl+Shift+R)
3. Try the OAuth flow again

---

## 🔄 **Alternative: Use 127.0.0.1 Instead of localhost**

If localhost doesn't work, try using `127.0.0.1`:

### **In Google Cloud Console:**
```
http://127.0.0.1:5800/v1/auth/callback/google
```

### **Update Server Code:**
```bash
# Edit coincidence/mock-api-server.js
# Change line with redirect_uri to:
redirect_uri: 'http://127.0.0.1:5800/v1/auth/callback/google'
```

Then restart the API server:
```bash
pkill -f "mock-api-server" && sleep 2 && cd coincidence && node mock-api-server.js &
```

---

## 🧪 **Test Direct OAuth Link**
Try this link directly in your browser:
```
https://accounts.google.com/oauth/authorize?client_id=351029698035-6kueu4as5bce178bimna3noa92ogc2tl.apps.googleusercontent.com&redirect_uri=http://localhost:5800/v1/auth/callback/google&response_type=code&scope=openid%20email%20profile&access_type=offline&prompt=consent
```

If this works, then the issue was just propagation time. If it still gives 404, then the redirect URI in Google Console doesn't match.

---

## ✅ **Success Checklist:**
- [ ] Google Cloud Console has the exact URI: `http://localhost:5800/v1/auth/callback/google`
- [ ] No trailing slash
- [ ] No extra spaces
- [ ] Waited 5+ minutes after saving
- [ ] Cleared browser cache
- [ ] OAuth link works without 404

**Fix the redirect URI in Google Cloud Console and you'll be logged in!** 🚀