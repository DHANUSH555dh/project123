import express from "express";
import {
  registerUser,
  loginUser,
  getMe,
  updateProfile,
  getUsers,
} from "../controllers/authController.js";
import { protect, admin } from "../middleware/authMiddleware.js";

const router = express.Router();

// Explicitly handle OPTIONS for all auth routes
router.options("/signup", (req, res) => {
  res.status(204).end();
});

router.options("/login", (req, res) => {
  res.status(204).end();
});

router.post("/signup", registerUser);
router.post("/login", loginUser);
router.get("/me", protect, getMe);
router.put("/profile", protect, updateProfile);
router.get("/users", protect, admin, getUsers);

export default router;
