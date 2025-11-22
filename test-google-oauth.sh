#!/bin/bash

echo "🚀 Testing Google OAuth Setup..."
echo ""

# Check if servers are running
echo "📋 Checking server status..."

if lsof -i :5173 > /dev/null 2>&1; then
    echo "✅ Web server running on port 5173"
else
    echo "❌ Web server NOT running on port 5173"
    echo "   Run: cd coincidence/apps/web && npm run dev"
fi

if lsof -i :5800 > /dev/null 2>&1; then
    echo "✅ API server running on port 5800"
else
    echo "❌ API server NOT running on port 5800"
    echo "   Run: cd coincidence && node mock-api-server.js"
fi

echo ""

# Test API endpoints
echo "🔍 Testing API endpoints..."

if curl -s http://localhost:5800/v1/auth/config > /dev/null 2>&1; then
    echo "✅ Auth config endpoint working"
else
    echo "❌ Auth config endpoint NOT working"
fi

echo ""

# Test Google OAuth redirect
echo "🔗 Testing Google OAuth redirect..."
GOOGLE_URL="http://localhost:5800/v1/auth/google"
echo "   Google OAuth URL: $GOOGLE_URL"
echo ""

# Check environment variables
echo "🔧 Checking environment variables..."

if [ -f "coincidence/apps/api/.env" ]; then
    if grep -q "GOOGLE_CLIENT_ID=" coincidence/apps/api/.env; then
        CLIENT_ID=$(grep "GOOGLE_CLIENT_ID=" coincidence/apps/api/.env | cut -d'=' -f2)
        if [ "$CLIENT_ID" != "your-google-client-id-here" ]; then
            echo "✅ Google Client ID configured: $CLIENT_ID"
        else
            echo "⚠️  Google Client ID needs to be updated"
        fi
    else
        echo "❌ Google Client ID not configured"
    fi
else
    echo "❌ .env file not found in coincidence/apps/api/"
fi

echo ""

# Instructions
echo "📝 Next Steps:"
echo "1. If servers are not running, start them:"
echo "   cd coincidence && node mock-api-server.js &"
echo "   cd coincidence/apps/web && npm run dev &"
echo ""
echo "2. If Google Client ID is not configured:"
echo "   a. Go to Google Cloud Console"
echo "   b. Create OAuth 2.0 Client ID"
echo "   c. Update GOOGLE_CLIENT_ID in coincidence/apps/api/.env"
echo ""
echo "3. Test the flow:"
echo "   a. Visit http://localhost:5173/"
echo "   b. Click 'Sign in with Google'"
echo "   c. Complete Google OAuth flow"
echo ""
echo "🌐 Ready to test Google OAuth!"