const express = require('express');
const cors = require('cors');
const querystring = require('node:querystring');

const app = express();
const PORT = 5800;

// Load environment variables
try {
  require('dotenv').config({ path: './apps/api/.env' });
  console.log('📁 .env file loaded successfully');
} catch (error) {
  console.log('❌ Error loading .env file:', error.message);
}

const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID || 'test-client-id';
const GOOGLE_CLIENT_SECRET = process.env.GOOGLE_CLIENT_SECRET || 'test-client-secret';

console.log('🔑 Environment variables loaded:');
console.log('   GOOGLE_CLIENT_ID:', GOOGLE_CLIENT_ID);
console.log('   GOOGLE_CLIENT_SECRET:', GOOGLE_CLIENT_SECRET ? '***SET***' : 'NOT SET');

app.use(cors());
app.use(express.json());

// Mock auth config endpoint
app.get('/v1/auth/config', (_req, res) => {
  res.json({
    data: [
      { provider: 'google', enabled: true },
      { provider: 'github', enabled: true },
      { provider: 'email', enabled: true },
    ],
  });
});

// Real Google OAuth endpoint
app.get('/v1/auth/google', (_req, res) => {
  const _redirectUri = encodeURIComponent(
    'https://uneugenical-proceedingly-federico.ngrok-free.dev/v1/auth/callback/google',
  );
  const _scope = encodeURIComponent('openid email profile');

  res.redirect(
    `https://accounts.google.com/oauth/authorize?${querystring.stringify({
      client_id: GOOGLE_CLIENT_ID,
      redirect_uri:
        'https://uneugenical-proceedingly-federico.ngrok-free.dev/v1/auth/callback/google',
      response_type: 'code',
      scope: 'openid email profile',
      access_type: 'offline',
      prompt: 'consent',
    })}`,
  );
});

// Mock GitHub OAuth endpoint
app.get('/v1/auth/github', (_req, res) => {
  res.redirect(
    `https://github.com/login/oauth/authorize?${querystring.stringify({
      client_id: 'test-client-id',
      redirect_uri: 'http://localhost:5800/v1/auth/callback/github',
      scope: 'user:email',
    })}`,
  );
});

// Google OAuth callback handler
app.get('/v1/auth/callback/google', async (req, res) => {
  const { code, error, error_description } = req.query;

  console.log('🔍 Google OAuth Callback Debug:');
  console.log('   Full query params:', req.query);
  console.log('   Code:', code ? 'RECEIVED' : 'MISSING');
  console.log('   Error:', error || 'NONE');
  console.log('   Error Description:', error_description || 'NONE');

  if (error) {
    return res.status(400).send(`
      <html>
        <body style="font-family: Arial, sans-serif; text-align: center; padding: 50px;">
          <h1 style="color: #dc3545;">❌ Authentication Failed</h1>
          <h2>Google OAuth Error</h2>
          <p><strong>Error:</strong> ${error}</p>
          <p><strong>Description:</strong> ${error_description || 'No description provided'}</p>
          <p style="color: #666;">This usually means the redirect URI in Google Cloud Console doesn't match what this server expects.</p>
          <p><strong>Expected redirect URI:</strong> https://uneugenical-proceedingly-federico.ngrok-free.dev/v1/auth/callback/google</p>
          <script>
            setTimeout(() => window.close(), 5000);
          </script>
        </body>
      </html>
    `);
  }

  if (!code) {
    return res.status(400).send(`
      <html>
        <body style="font-family: Arial, sans-serif; text-align: center; padding: 50px;">
          <h1 style="color: #dc3545;">❌ Authentication Failed</h1>
          <h2>No Authorization Code</h2>
          <p>No authorization code was received from Google.</p>
          <script>
            setTimeout(() => window.close(), 3000);
          </script>
        </body>
      </html>
    `);
  }

  try {
    // Exchange authorization code for access token
    const tokenResponse = await fetch('https://oauth2.googleapis.com/token', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: querystring.stringify({
        code: code,
        client_id: GOOGLE_CLIENT_ID,
        client_secret: GOOGLE_CLIENT_SECRET,
        redirect_uri:
          'https://uneugenical-proceedingly-federico.ngrok-free.dev/v1/auth/callback/google',
        grant_type: 'authorization_code',
      }),
    });

    const tokenData = await tokenResponse.json();

    if (tokenData.error) {
      throw new Error(tokenData.error_description || 'Token exchange failed');
    }

    // Get user profile information
    const userResponse = await fetch('https://www.googleapis.com/oauth2/v2/userinfo', {
      headers: {
        Authorization: `Bearer ${tokenData.access_token}`,
      },
    });

    const userData = await userResponse.json();

    // Generate a mock user session
    const userSession = {
      uid: `google_${userData.id}`,
      email: userData.email,
      name: userData.name,
      avatar: userData.picture,
      provider: 'google',
      accessToken: tokenData.access_token,
      refreshToken: tokenData.refresh_token,
    };

    // Send success response
    res.send(`
      <html>
        <head>
          <title>Authentication Successful</title>
        </head>
        <body style="font-family: Arial, sans-serif; text-align: center; padding: 50px;">
          <div style="max-width: 400px; margin: 0 auto;">
            <h1 style="color: #4285f4;">✅ Authentication Successful!</h1>
            <div style="margin: 20px 0;">
              <img src="${userData.picture}" alt="Profile" style="width: 80px; height: 80px; border-radius: 50%; margin-bottom: 20px;">
            </div>
            <h2>Welcome, ${userData.name}!</h2>
            <p style="color: #666;">${userData.email}</p>
            <p style="color: #28a745; font-weight: bold;">You can now close this window.</p>
            <script>
              // Send user data to parent window
              window.opener.postMessage({
                type: 'oauth_success',
                provider: 'google',
                user: ${JSON.stringify(userSession)}
              }, '*');
              
              // Close window after a short delay
              setTimeout(() => {
                window.close();
              }, 2000);
            </script>
          </div>
        </body>
      </html>
    `);
  } catch (error) {
    console.error('Google OAuth error:', error);
    res.status(500).send(`
      <html>
        <body>
          <h1>Authentication Failed</h1>
          <p>Error: ${error.message}</p>
          <script>
            setTimeout(() => window.close(), 3000);
          </script>
        </body>
      </html>
    `);
  }
});

// GitHub OAuth callback handler
app.get('/v1/auth/callback/github', (_req, res) => {
  res.send(`
    <html>
      <head>
        <title>GitHub Authentication</title>
      </head>
      <body style="font-family: Arial, sans-serif; text-align: center; padding: 50px;">
        <div style="max-width: 400px; margin: 0 auto;">
          <h1 style="color: #333;">🐙 GitHub Authentication</h1>
          <p style="color: #666;">Authentication successful! You can close this window.</p>
          <script>
            window.opener.postMessage({ 
              type: 'oauth_success', 
              provider: 'github',
              user: {
                uid: 'github_mock_user',
                name: 'GitHub User',
                email: 'user@example.com'
              }
            }, '*');
            setTimeout(() => window.close(), 2000);
          </script>
        </div>
      </body>
    </html>
  `);
});

// Mock email sign-in
app.post('/v1/auth/email/signin', (req, res) => {
  const { email } = req.body;
  res.json({
    success: true,
    user: {
      uid: 'email-user-id',
      email: email,
      name: 'Email User',
    },
  });
});

// Mock email sign-up
app.post('/v1/auth/email/signup', (req, res) => {
  const { email, name } = req.body;
  res.json({
    success: true,
    user: {
      uid: 'email-user-id',
      email: email,
      name: name,
    },
  });
});

// Mock user session endpoint
app.get('/v1/auth/me', (_req, res) => {
  res.json({
    success: true,
    user: {
      uid: 'demo-user',
      email: 'demo@example.com',
      name: 'Demo User',
    },
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Authentication server running on http://localhost:${PORT}`);
  console.log(`📝 Google OAuth configured with Client ID: ${GOOGLE_CLIENT_ID}`);
  console.log(`🔑 Google Client Secret: ${GOOGLE_CLIENT_SECRET ? 'SET' : 'NOT SET'}`);
  console.log('🌐 Visit http://localhost:5173 to test authentication');
});
