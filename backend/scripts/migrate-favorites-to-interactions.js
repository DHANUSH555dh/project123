import mongoose from 'mongoose';
import Favorite from '../models/favoriteModel.js';
import UserInteraction from '../models/userInteractionModel.js';
import dotenv from 'dotenv';

dotenv.config();

/**
 * Migration Script: Create UserInteraction records for existing Favorites
 * This is a one-time script to migrate old favorites to the UserInteraction system
 */

const migrateFavoritesToInteractions = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGO_URI);
    console.log('✅ Connected to MongoDB');

    // Get all favorites
    const favorites = await Favorite.find({});
    console.log(`📦 Found ${favorites.length} favorites to migrate`);

    let created = 0;
    let skipped = 0;
    let errors = 0;

    for (const favorite of favorites) {
      try {
        // Skip guest favorites (created before authentication)
        if (favorite.userId === 'guest' || !favorite.userId) {
          console.log(`⏭️  Skipping ${favorite.itemType} ${favorite.itemId} - guest favorite (no user)`);
          skipped++;
          continue;
        }

        // Check if interaction already exists
        const existingInteraction = await UserInteraction.findOne({
          user: favorite.userId,
          itemId: favorite.itemId,
          itemType: favorite.itemType, // Already capitalized "Movie" or "Music"
          interactionType: 'like'
        });

        if (existingInteraction) {
          console.log(`⏭️  Skipping ${favorite.itemType} ${favorite.itemId} - interaction already exists`);
          skipped++;
          continue;
        }

        // Create new UserInteraction record
        await UserInteraction.create({
          user: favorite.userId,
          itemId: favorite.itemId,
          itemType: favorite.itemType, // Keep capitalized "Movie" or "Music"
          interactionType: 'like',
          createdAt: favorite.createdAt || new Date()
        });

        console.log(`✅ Created interaction for ${favorite.itemType} ${favorite.itemId}`);
        created++;
      } catch (error) {
        console.error(`❌ Error migrating favorite ${favorite._id}:`, error.message);
        errors++;
      }
    }

    console.log('\n📊 Migration Summary:');
    console.log(`   ✅ Created: ${created}`);
    console.log(`   ⏭️  Skipped: ${skipped}`);
    console.log(`   ❌ Errors: ${errors}`);
    console.log(`   📦 Total: ${favorites.length}`);

    await mongoose.disconnect();
    console.log('\n✅ Migration complete! Database disconnected.');
    process.exit(0);
  } catch (error) {
    console.error('❌ Migration failed:', error);
    process.exit(1);
  }
};

// Run migration
migrateFavoritesToInteractions();
