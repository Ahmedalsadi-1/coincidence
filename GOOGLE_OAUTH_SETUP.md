# Google OAuth Setup Instructions

## Step 1: Create Google OAuth 2.0 Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing project
3. Go to **APIs & Services** → **Credentials**
4. Click **+ CREATE CREDENTIALS** → **OAuth 2.0 Client IDs**
5. Select **Web application**
6. Configure:
   - **Name**: Refly.AI Development
   - **Authorized JavaScript origins**: `http://localhost:5173`
   - **Authorized redirect URIs**: `http://localhost:5800/v1/auth/callback/google`
7. Click **CREATE**

## Step 2: Enable Required APIs

1. Go to **APIs & Services** → **Library**
2. Enable these APIs:
   - **Google+ API** (for user profile info)
   - **People API** (optional, for email addresses)

## Step 3: Get Your Credentials

After creating the OAuth client, you'll get:
- **Client ID**: `xxxxxxxxxx.apps.googleusercontent.com`
- **Client Secret**: `xxxxxxxxxxxxxxxxxxxxxxxx`

## Step 4: Update Environment Variables

Replace the placeholder values in your .env file:

```bash
# Google OAuth Configuration
GOOGLE_CLIENT_ID=your-google-client-id-here
GOOGLE_CLIENT_SECRET=your-google-client-secret-here
GOOGLE_CALLBACK_URL=http://localhost:5800/v1/auth/callback/google

# Enable Google OAuth
GOOGLE_AUTH_ENABLED=true
```

## Step 5: Test the Flow

1. Restart the servers
2. Visit http://localhost:5173/
3. Click "Sign in with Google"
4. Complete Google OAuth flow
5. You'll be redirected back and logged in!

## Important Notes

- The redirect URI must exactly match what you configured in Google Cloud Console
- For development, use `http://localhost:5800/v1/auth/callback/google`
- For production, use your actual domain
- Keep your Client Secret secure and never commit it to version control