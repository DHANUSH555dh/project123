# 🚂 Complete Railway Deployment Guide

## 📋 Overview

This guide will help you deploy both frontend and backend to Railway with proper configuration.

---

## 🎯 Railway Services Setup

You need **TWO separate services** in Railway:

### 1️⃣ **Backend Service** (Node.js API)
- Repository: `DHANUSH555dh/project123`
- Root Directory: `backend`
- Build Command: `npm install`
- Start Command: `npm start`

### 2️⃣ **Frontend Service** (React + Vite)
- Repository: `DHANUSH555dh/project123`
- Root Directory: `project`
- Build Command: Custom (see below)
- Start Command: `nginx -g 'daemon off;'`

---

## ⚙️ Backend Service Configuration

### **Settings Tab:**

1. **Root Directory:** `backend`
2. **Build Command:** `npm install`
3. **Start Command:** `npm start`

### **Variables Tab:**

Add these environment variables:

```env
NODE_ENV=production
PORT=${{RAILWAY_PUBLIC_PORT}}
MONGO_URI=mongodb+srv://dhanush:X1drhGkl9Q42KW37@cluster0.0tclkq2.mongodb.net/kosg?retryWrites=true&w=majority&appName=Cluster0
JWT_SECRET=kosg_super_secret_key_change_in_production_2024_v2
JWT_EXPIRE=7d
CORS_ORIGIN=*
```

**Important Notes:**
- `PORT=${{RAILWAY_PUBLIC_PORT}}` - Railway will set this automatically
- `CORS_ORIGIN=*` - Allows all origins (temporary for debugging)
- Keep your MongoDB URI from Atlas

### **Networking Tab:**

1. Click **"Generate Domain"**
2. Note your backend URL: `https://project123-production-XXXX.up.railway.app`
3. This is your backend API URL

---

## ⚙️ Frontend Service Configuration

### **Settings Tab:**

1. **Root Directory:** `project`
2. **Watch Paths:** `/project/**`
3. **Custom Build Command:**
   ```bash
   VITE_API_URL=https://project123-production-10c7.up.railway.app npm install && VITE_API_URL=https://project123-production-10c7.up.railway.app npm run build
   ```
   ⚠️ **Replace `project123-production-10c7` with YOUR backend domain!**

4. **Start Command:** `nginx -g 'daemon off;'`

### **Variables Tab:**

Add this build-time variable:

```env
VITE_API_URL=https://project123-production-10c7.up.railway.app
```

⚠️ **Replace with your actual backend domain!**

### **Networking Tab:**

1. Click **"Generate Domain"**
2. Your frontend will be at: `https://project123-production-YYYY.up.railway.app`

---

## 🔄 Deployment Order

### **Step 1: Deploy Backend First**

1. Go to Railway Dashboard
2. Click **"New Project"** → **"Deploy from GitHub repo"**
3. Select `DHANUSH555dh/project123`
4. Railway will create a service
5. Name it **"backend"**
6. Configure settings as shown above
7. Add environment variables
8. Generate domain
9. Wait for deployment to complete (2-3 minutes)
10. Test: `curl https://YOUR-BACKEND-URL.up.railway.app/api/health`

### **Step 2: Deploy Frontend Second**

1. In the same Railway project, click **"New Service"**
2. Select **"GitHub Repo"** → `DHANUSH555dh/project123`
3. Name it **"frontend"**
4. Configure settings with your backend URL
5. Add `VITE_API_URL` variable pointing to backend
6. Generate domain
7. Wait for deployment to complete (3-4 minutes)
8. Visit your frontend URL

---

## ✅ Verification Checklist

After both deployments complete:

### Backend Health Check:
```bash
curl https://YOUR-BACKEND-URL.up.railway.app/api/health
```

**Expected Response:**
```json
{
  "status": "OK",
  "message": "KOSG API is running",
  "timestamp": "2025-11-05T..."
}
```

### Frontend Check:
1. Open `https://YOUR-FRONTEND-URL.up.railway.app`
2. Open browser console (F12)
3. Look for: `🔗 API URL: https://YOUR-BACKEND-URL...`
4. Try signup/login - should work!

---

## 🐛 Troubleshooting

### Problem: Backend returns 502

**Solutions:**
1. Check backend logs in Railway → Deployments → View Logs
2. Look for errors:
   - MongoDB connection failed → Check Atlas IP whitelist
   - Port errors → Ensure `PORT=${{RAILWAY_PUBLIC_PORT}}`
   - Missing env vars → Add them in Variables tab

### Problem: Frontend shows "Cannot connect to backend"

**Solutions:**
1. Check browser console for the API URL
2. Ensure `VITE_API_URL` is set correctly in Railway
3. Redeploy frontend after setting env var
4. Test backend health endpoint directly

### Problem: CORS errors in browser console

**Solutions:**
1. Check backend `CORS_ORIGIN` is set to `*` or includes frontend domain
2. Ensure backend is listening on `0.0.0.0` not `localhost`
3. Check backend logs for OPTIONS requests

### Problem: "Application failed to respond"

**Solutions:**
1. **Root Directory** must be set correctly:
   - Backend: `backend`
   - Frontend: `project`
2. Check build logs for errors
3. Ensure start command is correct

---

## 📊 Current Configuration

### Backend Files:
- ✅ `backend/server.js` - Listens on `0.0.0.0:$PORT`
- ✅ `backend/Dockerfile` - Exposes port, runs `node server.js`
- ✅ CORS enabled with wildcard origin

### Frontend Files:
- ✅ `project/Dockerfile` - Multi-stage build with nginx
- ✅ `project/nginx.conf` - Serves SPA correctly
- ✅ `project/build-env.sh` - Creates `.env.production` with `VITE_API_URL`
- ✅ `project/src/api/api.ts` - Uses `import.meta.env.VITE_API_URL`

---

## 🔑 Important Environment Variables

### Backend Must Have:
```env
PORT=${{RAILWAY_PUBLIC_PORT}}      # Railway sets this automatically
MONGO_URI=mongodb+srv://...        # Your MongoDB Atlas connection
JWT_SECRET=your-secret-key         # For JWT tokens
CORS_ORIGIN=*                      # Allow frontend domain
```

### Frontend Must Have:
```env
VITE_API_URL=https://backend-url   # Your Railway backend domain
```

---

## 🚀 Quick Deploy Commands

After setting up Railway services, push changes:

```bash
git add -A
git commit -m "Configure for Railway deployment"
git push origin main
```

Railway will auto-deploy on every push to `main` branch.

---

## 📞 Need Help?

Check Railway logs:
1. Go to Railway Dashboard
2. Click your service (backend or frontend)
3. Click **"Deployments"** tab
4. Click **"View Logs"** on latest deployment
5. Look for errors (red text)

---

**Your Backend URL:** `https://project123-production-10c7.up.railway.app`
**Your Frontend URL:** `https://project123-production-956d.up.railway.app`

**Test Now:**
```bash
# Backend health
curl https://project123-production-10c7.up.railway.app/api/health

# Frontend
open https://project123-production-956d.up.railway.app
```

🎉 **Happy deploying!**
