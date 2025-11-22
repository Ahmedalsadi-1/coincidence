# 🚀 Complete Google OAuth Setup Guide

## 📋 Prerequisites
- Node.js installed
- Google account
- Coincidence project running

## 🔧 Step 1: Create Google OAuth 2.0 Credentials

### 1.1 Go to Google Cloud Console
1. Visit [https://console.cloud.google.com/](https://console.cloud.google.com/)
2. Sign in with your Google account
3. Create a new project or select existing one

### 1.2 Enable Required APIs
1. Go to **APIs & Services** → **Library**
2. Search for and enable:
   - **Google+ API** (for user profile info)
   - **People API** (optional, for email addresses)

### 1.3 Create OAuth 2.0 Client
1. Go to **APIs & Services** → **Credentials**
2. Click **+ CREATE CREDENTIALS** → **OAuth 2.0 Client IDs**
3. Select **Web application**
4. Configure the OAuth client:
   - **Name**: `Refly.AI Development`
   - **Authorized JavaScript origins**: `http://localhost:5173`
   - **Authorized redirect URIs**: `http://localhost:5800/v1/auth/callback/google`
5. Click **CREATE**

### 1.4 Get Your Credentials
After creation, you'll see:
- **Client ID**: `xxxxxxxxxx.apps.googleusercontent.com`
- **Client Secret**: `xxxxxxxxxxxxxxxxxxxxxxxx`

## 📝 Step 2: Update Environment Variables

Create or update the `.env` file in the `coincidence/apps/api/` directory:

```bash
# Google OAuth Configuration
GOOGLE_CLIENT_ID=your-google-client-id-here
GOOGLE_CLIENT_SECRET=your-google-client-secret-here
GOOGLE_CALLBACK_URL=http://localhost:5800/v1/auth/callback/google

# Enable Google OAuth
GOOGLE_AUTH_ENABLED=true

# Other settings
NODE_ENV=development
DATABASE_URL="file:./dev.db"
JWT_SECRET=development-jwt-secret-key-change-in-production
SESSION_SECRET=development-session-secret-key-change-in-production
```

## 🔄 Step 3: Restart Services

```bash
# Stop current servers
pkill -f "mock-api-server"
pkill -f "rsbuild"

# Start API server
cd coincidence/apps/api && npm run dev &

# Start web server  
cd coincidence/apps/web && npm run dev &
```

## 🧪 Step 4: Test Google OAuth Flow

### 4.1 Verify Setup
1. Visit http://localhost:5173/
2. Try to interact with the app (click in chat input)
3. Login modal should appear with Google button

### 4.2 Complete OAuth Flow
1. Click **"Sign in with Google"**
2. You'll be redirected to Google's consent screen
3. Sign in with your Google account
4. Grant permissions for email and profile access
5. You'll be redirected back to the app
6. Success page will show your Google profile
7. Window will close automatically
8. You'll be logged into the application

## 🔍 Step 5: Troubleshooting

### Common Issues & Solutions

#### Issue: "redirect_uri_mismatch" Error
**Solution**: Make sure the redirect URI in Google Console exactly matches:
```
http://localhost:5800/v1/auth/callback/google
```

#### Issue: "invalid_client" Error  
**Solution**: Verify Client ID and Client Secret are correct and match your Google Console

#### Issue: Login buttons not visible
**Solution**: Check that both servers are running:
```bash
lsof -i :5173  # Web server
lsof -i :5800  # API server
```

#### Issue: CORS errors
**Solution**: Ensure JavaScript origin is set to `http://localhost:5173`

## 🎯 Step 6: Production Deployment

For production deployment:

1. **Update Redirect URI**:
   - Change to your production domain: `https://yourdomain.com/v1/auth/callback/google`

2. **Update Environment Variables**:
   ```bash
   GOOGLE_CALLBACK_URL=https://yourdomain.com/v1/auth/callback/google
   NODE_ENV=production
   ```

3. **Security Considerations**:
   - Use HTTPS in production
   - Keep Client Secret secure
   - Validate state parameter for CSRF protection
   - Implement proper session management

## 📱 Step 7: Mobile App Considerations

If using mobile app:
1. Add mobile app as authorized origin in Google Console
2. Use deep linking for redirect URI
3. Implement proper mobile OAuth flow

## ✅ Success Criteria

You'll know it's working when:
- ✅ Login modal shows Google button
- ✅ Clicking Google button redirects to Google
- ✅ After authentication, you're redirected back
- ✅ Success page shows your Google profile
- ✅ You're logged into the main application
- ✅ User profile data is accessible in the app

## 🎉 Congratulations!

You now have a fully functional Google OAuth integration! Users can sign in with their Google accounts seamlessly.

## 📚 Additional Resources

- [Google OAuth 2.0 Documentation](https://developers.google.com/identity/protocols/oauth2)
- [Google Cloud Console Help](https://cloud.google.com/docs)
- [Coincidence Project Documentation](https://github.com/Ahmedalsadi-1/coincidence)

---

**Need help?** Check the console logs for detailed error messages and ensure all environment variables are properly configured.