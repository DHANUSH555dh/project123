import api from './api';
import type { Movie, Favorite } from './api';

/**
 * Get liked movies directly from Favorites collection
 * This is a helper function to ensure we get movies even if
 * the UserInteraction collection doesn't have them
 */
export const getLikedMoviesFromFavorites = async (): Promise<Movie[]> => {
  try {
    // Get all favorites
    const response = await api.get("/api/favorites");
    const favorites: Favorite[] = response.data.favorites || response.data;
    
    console.log('getLikedMoviesFromFavorites - Raw favorites:', favorites);
    
    // Filter for movies only
    const movieFavorites = favorites.filter(fav => fav.itemType === "Movie");
    console.log('getLikedMoviesFromFavorites - Movie favorites:', movieFavorites);
    
    // Extract movie IDs
    const movieIds = movieFavorites.map(fav => 
      typeof fav.itemId === 'string' ? fav.itemId : fav.itemId._id
    );
    console.log('getLikedMoviesFromFavorites - Movie IDs:', movieIds);
    
    if (movieIds.length === 0) {
      return [];
    }
    
    // Fetch full movie data for each ID
    const moviePromises = movieIds.map(id => 
      api.get(`/api/movies/${id}`).catch(err => {
        console.error(`Error fetching movie ${id}:`, err);
        return null;
      })
    );
    
    const movieResponses = await Promise.all(moviePromises);
    const movies = movieResponses
      .filter(response => response !== null)
      .map(response => response!.data);
    
    console.log('getLikedMoviesFromFavorites - Full movies:', movies);
    return movies;
  } catch (error) {
    console.error("Error getting liked movies from favorites:", error);
    return [];
  }
};
