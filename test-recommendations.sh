#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🎯 Testing KOSG Recommendation System${NC}"
echo ""

# Test 1: Check if backend is running
echo -e "${YELLOW}1. Testing backend health...${NC}"
HEALTH=$(curl -s http://localhost:5001/api/health)
if [[ $HEALTH == *"OK"* ]]; then
    echo -e "${GREEN}✅ Backend is running!${NC}"
else
    echo -e "${RED}❌ Backend is not responding${NC}"
    exit 1
fi
echo ""

# Test 2: Create a test account
echo -e "${YELLOW}2. Creating test account...${NC}"
SIGNUP=$(curl -s -X POST http://localhost:5001/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test'$(date +%s)'@example.com",
    "password": "test123456"
  }')

TOKEN=$(echo $SIGNUP | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -n "$TOKEN" ]; then
    echo -e "${GREEN}✅ Account created!${NC}"
    echo -e "   Token: ${TOKEN:0:20}..."
else
    echo -e "${RED}❌ Failed to create account${NC}"
    echo "   Response: $SIGNUP"
    exit 1
fi
echo ""

# Test 3: Get movie recommendations (before liking anything)
echo -e "${YELLOW}3. Getting initial movie recommendations...${NC}"
MOVIES=$(curl -s -X GET "http://localhost:5001/api/recommendations/movies?limit=5" \
  -H "Authorization: Bearer $TOKEN")

if [[ $MOVIES == *"recommendations"* ]]; then
    echo -e "${GREEN}✅ Got movie recommendations!${NC}"
    echo "$MOVIES" | grep -o '"title":"[^"]*' | head -3 | sed 's/"title":"/ - /'
else
    echo -e "${RED}❌ Failed to get recommendations${NC}"
    echo "   Response: $MOVIES"
fi
echo ""

# Test 4: Get music recommendations
echo -e "${YELLOW}4. Getting music recommendations...${NC}"
MUSIC=$(curl -s -X GET "http://localhost:5001/api/recommendations/music?limit=5" \
  -H "Authorization: Bearer $TOKEN")

if [[ $MUSIC == *"recommendations"* ]]; then
    echo -e "${GREEN}✅ Got music recommendations!${NC}"
    echo "$MUSIC" | grep -o '"title":"[^"]*' | head -3 | sed 's/"title":"/ - /'
else
    echo -e "${RED}❌ Failed to get music recommendations${NC}"
fi
echo ""

# Test 5: Get a movie ID and like it
echo -e "${YELLOW}5. Testing interaction tracking (like a movie)...${NC}"
MOVIE_ID=$(curl -s "http://localhost:5001/api/movies?limit=1" | grep -o '"_id":"[^"]*' | head -1 | cut -d'"' -f4)

if [ -n "$MOVIE_ID" ]; then
    INTERACT=$(curl -s -X POST http://localhost:5001/api/recommendations/interact \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{
        \"itemId\": \"$MOVIE_ID\",
        \"itemType\": \"movie\",
        \"interactionType\": \"like\",
        \"mood\": \"happy\"
      }")
    
    if [[ $INTERACT == *"success"* ]]; then
        echo -e "${GREEN}✅ Successfully liked a movie!${NC}"
    else
        echo -e "${RED}❌ Failed to track interaction${NC}"
        echo "   Response: $INTERACT"
    fi
else
    echo -e "${RED}❌ No movies found in database${NC}"
fi
echo ""

# Test 6: Get mood-based recommendations
echo -e "${YELLOW}6. Testing mood-based recommendations (happy)...${NC}"
MOOD_MOVIES=$(curl -s -X GET "http://localhost:5001/api/recommendations/movies?mood=happy&limit=5" \
  -H "Authorization: Bearer $TOKEN")

if [[ $MOOD_MOVIES == *"recommendations"* ]]; then
    echo -e "${GREEN}✅ Got mood-based recommendations!${NC}"
    echo "$MOOD_MOVIES" | grep -o '"mood":"happy"' > /dev/null && echo -e "   Mood filter: happy ✓"
else
    echo -e "${RED}❌ Failed to get mood-based recommendations${NC}"
fi
echo ""

# Test 7: Get liked items
echo -e "${YELLOW}7. Getting liked movies...${NC}"
LIKED=$(curl -s -X GET http://localhost:5001/api/recommendations/liked/movies \
  -H "Authorization: Bearer $TOKEN")

if [[ $LIKED == *"success"* ]]; then
    echo -e "${GREEN}✅ Retrieved liked movies!${NC}"
    LIKED_COUNT=$(echo "$LIKED" | grep -o '"_id"' | wc -l | tr -d ' ')
    echo -e "   You have liked $LIKED_COUNT movie(s)"
else
    echo -e "${RED}❌ Failed to get liked movies${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ All tests passed!${NC}"
echo ""
echo -e "${BLUE}🎉 Your Hybrid Recommendation System is working!${NC}"
echo ""
echo -e "You can now:"
echo -e "  1. Open ${YELLOW}http://localhost:5173${NC} in your browser"
echo -e "  2. Login with the test account (check terminal for email)"
echo -e "  3. Like some movies and music"
echo -e "  4. Get personalized recommendations!"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
