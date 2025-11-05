import mongoose from 'mongoose';
import Favorite from '../models/favoriteModel.js';
import dotenv from 'dotenv';

dotenv.config();

/**
 * Cleanup Script: Remove guest favorites (created before authentication)
 * These favorites can't be associated with real users and cause cross-user pollution
 */

const cleanupGuestFavorites = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGO_URI);
    console.log('✅ Connected to MongoDB');

    // Find all guest favorites
    const guestFavorites = await Favorite.find({
      userId: { $type: 'string' } // Find all string-type userId (old schema)
    });

    console.log(`📦 Found ${guestFavorites.length} guest favorites to remove`);

    if (guestFavorites.length > 0) {
      // Delete all guest favorites
      const result = await Favorite.deleteMany({
        userId: { $type: 'string' }
      });

      console.log(`✅ Deleted ${result.deletedCount} guest favorites`);
    } else {
      console.log('✨ No guest favorites found - database is clean!');
    }

    await mongoose.disconnect();
    console.log('\n✅ Cleanup complete! Database disconnected.');
    process.exit(0);
  } catch (error) {
    console.error('❌ Cleanup failed:', error);
    process.exit(1);
  }
};

// Run cleanup
cleanupGuestFavorites();
