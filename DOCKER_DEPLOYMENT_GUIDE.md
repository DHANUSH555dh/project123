# Docker Deployment Guide - Cine-Tune List

## Option 1: Run Locally with Docker Compose (Test Before Deploying)

### Prerequisites
- Docker Desktop installed ([Download](https://www.docker.com/products/docker-desktop))
- Docker Compose included with Docker Desktop

### Steps:

1. **Navigate to project root:**
```bash
cd /Users/dhanushg/Desktop/project-bolt-sb1-n9f8dnts\ 2
```

2. **Build and start all services:**
```bash
docker-compose up --build
```

First run will take 2-3 minutes to build images and download MongoDB.

3. **Wait for all services to be healthy:**
Look for messages like:
```
✓ mongodb service running
✓ backend service running  
✓ frontend service running
```

4. **Access your application:**
- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:5001
- **MongoDB:** mongodb://root:rootpassword@localhost:27017

5. **To stop everything:**
```bash
docker-compose down
```

6. **To stop AND remove data:**
```bash
docker-compose down -v
```

---

## Option 2: Deploy on Railway.app (RECOMMENDED - Free Tier Available)

Railway is PERFECT for full-stack apps and gives you:
- ✅ Free tier (500 hours/month)
- ✅ Easy MongoDB integration
- ✅ Automatic deployments from GitHub
- ✅ Environment variables management
- ✅ No credit card needed

### Step-by-Step:

#### 1. Create Railway Account
- Go to https://railway.app
- Click "Start Now"
- Sign up with GitHub (recommended)
- Authorize Railway to access your GitHub account

#### 2. Create New Project
- Click "New Project" 
- Select "Deploy from GitHub repo"
- Search for "project123" and select `DHANUSH555dh/project123`
- Click "Deploy"

#### 3. Add MongoDB Service
- In your Railway project, click "Add Service"
- Select "Database" → "MongoDB"
- Railway will automatically:
  - Create MongoDB instance
  - Set environment variables (MONGODB_URL)
  - Handle backups

#### 4. Configure Backend Service
Railway will auto-detect backend from your docker-compose.yml

**Set Environment Variables in Railway Dashboard:**
- Go to "Backend" service
- Click Variables tab
- Add:
```
NODE_ENV=production
PORT=5001
MONGODB_URI=$MONGODB_URL
CORS_ORIGIN=https://[YOUR-RAILWAY-DOMAIN].up.railway.app
```

#### 5. Configure Frontend Service
Railway will auto-detect frontend from your docker-compose.yml

**Set Environment Variables:**
- Go to "Frontend" service
- Click Variables tab
- Add:
```
VITE_API_URL=https://[YOUR-BACKEND-DOMAIN].up.railway.app
```

#### 6. Deploy
- Railway auto-builds when you push to GitHub
- Watch deployment progress in dashboard
- Once complete, you'll get:
  - Frontend URL: https://project123-[random].up.railway.app
  - Backend URL: https://[backend-random].up.railway.app

---

## Option 3: Deploy on Render.com (Also Free)

### Step-by-Step:

#### 1. Create Account
- Go to https://render.com
- Sign up with GitHub

#### 2. Create Backend Service
- Click "New +"
- Select "Web Service"
- Connect GitHub repo `DHANUSH555dh/project123`
- Configure:
  - **Name:** cine-tune-backend
  - **Runtime:** Node
  - **Build Command:** `cd backend && npm install`
  - **Start Command:** `node server.js`
  - **Plan:** Free
  
#### 3. Add Environment Variables
- In Backend settings, add:
```
NODE_ENV=production
PORT=5001
MONGODB_URI=mongodb+srv://[USERNAME]:[PASSWORD]@cluster.mongodb.net/kosg
CORS_ORIGIN=https://[YOUR-FRONTEND-DOMAIN].onrender.com
```

#### 4. Create Frontend Service
- Click "New +"
- Select "Static Site"
- Connect same GitHub repo
- Configure:
  - **Name:** cine-tune-frontend
  - **Build Command:** `cd project && npm install && npm run build`
  - **Publish Directory:** `project/dist`

#### 5. Add Frontend Environment Variables
- Build Environment Variables:
```
VITE_API_URL=https://[YOUR-BACKEND-DOMAIN].onrender.com
```

---

## Option 4: Deploy on Heroku (Paid, but cheapest option)

### Note: Heroku free tier was discontinued, but pricing starts at $5/month

- Similar process to Railway
- Use Heroku CLI: `heroku create`
- Push with: `git push heroku main`

---

## Troubleshooting

### Services won't start locally
```bash
# Check logs
docker-compose logs -f

# Remove old containers
docker-compose down -v
docker system prune -a

# Rebuild
docker-compose up --build
```

### MongoDB connection errors
```bash
# Check if MongoDB is running
docker-compose logs mongodb

# Verify connection string in backend logs
docker-compose logs backend
```

### Frontend shows 404
- Check nginx logs: `docker-compose logs frontend`
- Verify VITE_API_URL is correctly set
- Clear browser cache: Cmd+Shift+R

### API calls failing from frontend
- Check CORS_ORIGIN setting matches frontend domain
- Check backend logs for errors
- Verify network connectivity between containers

---

## Files Updated for Docker

✅ `docker-compose.yml` - Main orchestration file
✅ `backend/Dockerfile` - Backend image with Node.js
✅ `backend/.dockerignore` - Exclude files from backend image
✅ `project/Dockerfile` - Frontend React app with nginx
✅ `project/nginx.conf` - SPA routing configuration
✅ `project/.dockerignore` - Exclude files from frontend image
✅ `backend/server.js` - Updated CORS to use env variables
✅ `project/src/api/api.ts` - Already configured for env variables

---

## Quick Reference Commands

```bash
# Local development with Docker
docker-compose up --build

# View logs
docker-compose logs -f [service-name]

# Stop all services
docker-compose stop

# Remove everything
docker-compose down -v

# Rebuild specific service
docker-compose build --no-cache backend

# Shell into container
docker-compose exec backend sh
```

---

## Recommended: Use Railway.app

I recommend **Railway** because:
1. ✅ Easiest setup (3-4 clicks)
2. ✅ Free tier is generous (500 hrs/month = full-time)
3. ✅ MongoDB included in free tier
4. ✅ Auto-deploys on GitHub push
5. ✅ Best performance
6. ✅ Great UI and documentation

**Deploy now:** https://railway.app

Let me know if you need help with any step! 🚀
