# 🧪 Testing the Recommendation System Locally

## 🎯 Quick Start Guide

### **Step 1: Check Servers are Running**

- ✅ **Backend**: http://localhost:5001
- ✅ **Frontend**: http://localhost:5173

---

## 📝 **Test Scenarios**

### **Scenario 1: Create an Account and Login**

1. Open http://localhost:5173 in your browser
2. Click **"Sign Up"**
3. Create a new account:
   - Name: Test User
   - Email: test@example.com
   - Password: test123
4. You should be logged in automatically

---

### **Scenario 2: Like Some Movies**

1. Go to the **Movies** page
2. Browse the movies
3. Click the **Like** button (❤️) on several movies
   - Pick different genres (Action, Drama, Comedy, Sci-Fi)
   - Like at least 5-10 movies
4. This builds your taste profile!

---

### **Scenario 3: Like Some Music**

1. Go to the **Music** page
2. Browse the songs
3. Click the **Like** button on several songs
   - Try different genres
   - Like at least 5-10 songs
4. This helps the system learn your music preferences!

---

### **Scenario 4: Get Movie Recommendations**

#### **Using the API (Postman/Insomnia/curl):**

```bash
# First, login to get your token
curl -X POST http://localhost:5001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "test123"
  }'

# Copy the token from the response, then:

# Get general recommendations
curl -X GET http://localhost:5001/api/recommendations/movies \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"

# Get recommendations for a specific mood
curl -X GET "http://localhost:5001/api/recommendations/movies?mood=happy&limit=10" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"

# Try different moods:
# - happy
# - sad
# - energetic
# - calm
# - romantic
# - angry
# - motivational
# - relaxing
```

---

### **Scenario 5: Get Music Recommendations**

```bash
# Get general music recommendations
curl -X GET http://localhost:5001/api/recommendations/music \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"

# Get recommendations for energetic mood
curl -X GET "http://localhost:5001/api/recommendations/music?mood=energetic&limit=10" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

### **Scenario 6: Track Interactions**

```bash
# Like a movie
curl -X POST http://localhost:5001/api/recommendations/interact \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "itemId": "MOVIE_ID_HERE",
    "itemType": "movie",
    "interactionType": "like",
    "mood": "happy"
  }'

# Rate a song (1-5 stars)
curl -X POST http://localhost:5001/api/recommendations/interact \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "itemId": "SONG_ID_HERE",
    "itemType": "music",
    "interactionType": "rating",
    "rating": 5
  }'

# View a movie
curl -X POST http://localhost:5001/api/recommendations/interact \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "itemId": "MOVIE_ID_HERE",
    "itemType": "movie",
    "interactionType": "view",
    "duration": 120
  }'
```

---

### **Scenario 7: View Your Liked Items**

```bash
# Get all movies you've liked
curl -X GET http://localhost:5001/api/recommendations/liked/movies \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"

# Get all music you've liked
curl -X GET http://localhost:5001/api/recommendations/liked/music \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## 🧪 **Testing the Recommendation Quality**

### **Test 1: Content-Based Filtering**

1. Like 5 action movies
2. Request recommendations
3. **Expected**: You should see more action movies in recommendations

### **Test 2: Mood-Based Filtering**

1. Like some movies
2. Request recommendations with `?mood=happy`
3. **Expected**: You should get uplifting, feel-good movies

### **Test 3: Collaborative Filtering**

1. Create 2-3 test accounts
2. Make them like similar movies
3. Request recommendations
4. **Expected**: Users with similar taste should get similar recommendations

---

## 🔍 **Checking the Database**

You can verify the data is being tracked:

```javascript
// In MongoDB Compass or Mongo Shell:

// View user interactions
db.userinteractions.find().pretty()

// Count likes
db.userinteractions.countDocuments({ interactionType: "like" })

// View movies
db.movies.find().limit(10).pretty()

// View music
db.musics.find().limit(10).pretty()
```

---

## 📊 **Understanding the Responses**

### **Movie Recommendation Response:**

```json
{
  "success": true,
  "data": {
    "recommendations": [
      {
        "_id": "...",
        "title": "The Shawshank Redemption",
        "genre": ["Drama"],
        "mood": ["inspirational", "hopeful"],
        "rating": 9.3,
        "popularity": 1500,
        "recommendationScore": 8.5  // Higher = better match
      }
    ],
    "liked": [
      // Your previously liked movies
    ],
    "mood": "happy"
  }
}
```

### **Recommendation Score Explained:**

- **High score (7-10)**: Perfect match for your taste
- **Medium score (4-7)**: Good match
- **Low score (1-4)**: Worth exploring

The score is calculated from:
- Content-based similarity (40%)
- Collaborative filtering (30%)
- Mood matching (30%)

---

## 🎨 **Frontend Testing Checklist**

- [ ] Can create an account
- [ ] Can login
- [ ] Can view movies
- [ ] Can like movies
- [ ] Can unlike movies
- [ ] Can view music
- [ ] Can like music
- [ ] Can filter by genre
- [ ] Can filter by mood
- [ ] Search works
- [ ] Pagination works
- [ ] Profile page shows liked items
- [ ] Recommendations update after liking items

---

## 🐛 **Troubleshooting**

### **Issue: No recommendations**
**Solution**: Make sure you've liked at least 3-5 items first

### **Issue: Same recommendations every time**
**Solution**: 
- Clear interactions: `db.userinteractions.deleteMany({})`
- Like different genres/moods

### **Issue: 401 Unauthorized**
**Solution**: Make sure you're logged in and using a valid token

### **Issue: Empty response**
**Solution**: Check that database is seeded with movies/music

---

## 📝 **Sample Test Flow**

1. **Setup** (5 minutes)
   - Create account
   - Like 10 movies (mix of genres)
   - Like 10 songs (mix of moods)

2. **Test Content-Based** (2 minutes)
   - Request recommendations
   - Verify they match your liked genres

3. **Test Mood-Based** (2 minutes)
   - Request with `?mood=happy`
   - Verify upbeat content returned

4. **Test Interactions** (2 minutes)
   - Rate some items
   - Add favorites
   - Check liked items endpoint

5. **Verify** (1 minute)
   - Check MongoDB for stored interactions
   - Verify recommendation scores make sense

---

## 🎯 **Success Criteria**

✅ **Content-Based**: Recommendations match your liked genres/artists  
✅ **Collaborative**: Similar users get similar recommendations  
✅ **Mood-Based**: Mood filter changes results appropriately  
✅ **Hybrid**: Combined results are diverse and relevant  
✅ **Tracking**: Interactions are saved correctly  
✅ **Performance**: Recommendations load in < 1 second  

---

## 🚀 **Next Steps**

Once local testing is complete:
1. Fix any bugs found
2. Improve recommendation weights if needed
3. Deploy to Railway
4. Test on production
5. Gather real user feedback!

---

**Happy testing!** 🎉
