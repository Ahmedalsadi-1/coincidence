#!/bin/bash

echo "🔍 OAuth Flow Debug Test"
echo "========================"
echo ""

echo "📋 Current Configuration:"
echo "   Web Server: http://localhost:5174/"
echo "   API Server: http://localhost:5800/"
echo "   Google Client ID: 351029698035-6kueu4as5bce178bimna3noa92ogc2tl.apps.googleusercontent.com"
echo ""

echo "🧪 Testing Components:"
echo ""

# Test 1: Web server
echo "1. 🌐 Web Server Status:"
if curl -s -I http://localhost:5174/ | grep -q "200 OK"; then
    echo "   ✅ Web server responding"
else
    echo "   ❌ Web server not responding"
fi

# Test 2: API server
echo "2. 🔧 API Server Status:"
if curl -s http://localhost:5800/v1/auth/config | grep -q "google"; then
    echo "   ✅ API server responding with auth config"
else
    echo "   ❌ API server not responding"
fi

# Test 3: OAuth redirect
echo "3. 🔗 OAuth Redirect Test:"
OAUTH_URL=$(curl -s "http://localhost:5800/v1/auth/google" | grep -o "https://accounts.google.com[^\"]*" | head -1)
if [[ $OAUTH_URL == *"accounts.google.com"* ]]; then
    echo "   ✅ OAuth redirect URL generated correctly"
    echo "   URL: $OAUTH_URL"
else
    echo "   ❌ OAuth redirect not working"
fi

# Test 4: Web proxy
echo "4. 🌉 Web Proxy Test:"
if curl -s http://localhost:5174/v1/auth/config | grep -q "google"; then
    echo "   ✅ Web proxy working (can reach API)"
else
    echo "   ❌ Web proxy not working"
fi

echo ""
echo "🎯 Manual Testing Steps:"
echo "1. Open browser to: http://localhost:5174/"
echo "2. Click in chat input area"
echo "3. Look for login modal with 3 buttons"
echo "4. Click 'Sign in with Google'"
echo "5. Should redirect to Google OAuth page"
echo ""

echo "🔧 If OAuth button doesn't work:"
echo "• Check browser console for JavaScript errors"
echo "• Verify you're on port 5174 (not 5173)"
echo "• Try the direct OAuth URL: http://localhost:5174/v1/auth/google"
echo ""

echo "📞 Debug complete!"