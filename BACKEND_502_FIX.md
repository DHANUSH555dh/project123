# 🚨 Backend 502 Error - Troubleshooting Guide

## Current Status
- ❌ Backend returning 502: "Application failed to respond"
- ✅ Frontend deployed successfully at https://project123-production-956d.up.railway.app
- ❌ Backend not accessible at https://project123-production-10c7.up.railway.app

## Most Likely Causes

### 1. Missing Environment Variables ⚠️
The backend REQUIRES these variables to start:

```env
MONGO_URI=mongodb+srv://dhanush:X1drhGkl9Q42KW37@cluster0.0tclkq2.mongodb.net/kosg?retryWrites=true&w=majority&appName=Cluster0
JWT_SECRET=kosg_super_secret_key_change_in_production_2024_v2
PORT=${{RAILWAY_PUBLIC_PORT}}
NODE_ENV=production
```

### 2. MongoDB Connection Failing
If MongoDB Atlas blocks Railway's IP, the app won't start.

### 3. Port Configuration Wrong
Railway assigns a port dynamically - backend must use `process.env.PORT`

---

## 🔧 How to Fix (Step by Step)

### Step 1: Check Railway Backend Logs

1. Go to Railway Dashboard
2. Click **project123-production-10c7** (backend service)
3. Click **Deployments** tab
4. Click **View Logs** on the latest deployment

**Look for these errors:**
- `❌ MongoDB Connection Error` - MongoDB issue
- `Error: listen EADDRINUSE` - Port conflict
- `JWT_SECRET is not defined` - Missing env var
- `Cannot find module` - Build issue

### Step 2: Add Environment Variables

Go to Railway → Backend Service → **Variables** tab

**Add these EXACTLY:**

```
MONGO_URI=mongodb+srv://dhanush:X1drhGkl9Q42KW37@cluster0.0tclkq2.mongodb.net/kosg?retryWrites=true&w=majority&appName=Cluster0
JWT_SECRET=kosg_super_secret_key_change_in_production_2024_v2
JWT_EXPIRE=7d
NODE_ENV=production
CORS_ORIGIN=*
```

**⚠️ DO NOT ADD `PORT` - Railway sets this automatically**

### Step 3: Fix MongoDB Atlas Network Access

1. Go to https://cloud.mongodb.com
2. Click your cluster (Cluster0)
3. Click **Network Access** (left sidebar)
4. Click **Add IP Address**
5. Click **"Allow Access from Anywhere"** (0.0.0.0/0)
6. Click **Confirm**

This allows Railway's dynamic IPs to connect.

### Step 4: Verify Railway Settings

Go to Railway → Backend Service → **Settings** tab

**Check these:**
- ✅ Root Directory: `backend`
- ✅ Build Command: Leave empty (Dockerfile handles it)
- ✅ Start Command: Leave empty (Dockerfile CMD handles it)
- ✅ Watch Paths: `/backend/**`

### Step 5: Redeploy Backend

After adding env variables and fixing MongoDB:

1. Go to **Deployments** tab
2. Click ⋮ (three dots) on latest deployment
3. Click **Redeploy**
4. Wait 2-3 minutes
5. Check logs for success messages

---

## ✅ What Success Looks Like

**In Railway logs, you should see:**
```
🔒 CORS enabled for origins: *
🚀 Server running on http://0.0.0.0:8080
📊 Environment: production
✅ MongoDB connected successfully
✅ MongoDB Connected: cluster0.0tclkq2.mongodb.net
📦 Database: kosg
```

**Then this should work:**
```bash
curl https://project123-production-10c7.up.railway.app/api/health
```

**Expected response:**
```json
{
  "status": "OK",
  "message": "KOSG API is running",
  "timestamp": "2025-11-05T..."
}
```

---

## 🎯 Quick Checklist

- [ ] Environment variables added in Railway (especially MONGO_URI and JWT_SECRET)
- [ ] MongoDB Atlas allows 0.0.0.0/0 in Network Access
- [ ] Root Directory set to `backend`
- [ ] Redeployed after adding env vars
- [ ] Checked deployment logs for errors
- [ ] Health endpoint returns 200 OK

---

## 🐛 Common Errors and Solutions

### Error: "MongoDB Connection Error"
**Solution:** 
1. Check MongoDB Atlas Network Access allows 0.0.0.0/0
2. Verify MONGO_URI is correct in Railway variables
3. Check MongoDB Atlas cluster is active

### Error: "JWT_SECRET is not defined"
**Solution:**
1. Add `JWT_SECRET` to Railway variables
2. Redeploy

### Error: "listen EADDRINUSE"
**Solution:**
1. Do NOT set PORT in Railway variables
2. Backend uses `process.env.PORT` automatically
3. Redeploy

### Error: "Application failed to respond"
**Solution:**
1. Check all environment variables are set
2. Check deployment logs for crash errors
3. Verify Dockerfile is being used correctly

---

## 📞 Still Not Working?

Copy the **deployment logs** from Railway and share them. Look for:
- Red error messages
- Stack traces
- "Error:" lines
- Connection failures

The logs will tell us exactly what's wrong.

---

**Priority: Add MONGO_URI and JWT_SECRET to Railway variables, then redeploy!** 🚀
