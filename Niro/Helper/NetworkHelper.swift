//
//  NetworkHelper.swift
//  Niro
//
//  Created by Mohamed Adel on 15/08/2023.
//

import Foundation

class NetworkHelper {

    static func getMoviseRatingsURL(guestSessionId: String) -> String {
        return "\(K.API.guestSession)\(guestSessionId)/rated/movies?api_key=\(K.APIKey.tmdb)"
    }

    static func getTVShowsRatingsURL(guestSessionId: String) -> String {
        return "\(K.API.guestSession)\(guestSessionId)/rated/tv?api_key=\(K.APIKey.tmdb)"
    }

    static func getTopRatedMoviesURL() -> String {
        return "\(K.API.topRatedMovies)?api_key=\(K.APIKey.tmdb)"
    }

    static func getPopularMoviesURL() -> String {
        return "\(K.API.popularMovies)?api_key=\(K.APIKey.tmdb)"
    }

    static func getCommingSoonMoviesURL() -> String {
        return "\(K.API.commingSoonMovies)?api_key=\(K.APIKey.tmdb)&region=US"
    }
    
    static func getTopRatedTVShowsURL() -> String {
        return "\(K.API.topRatedTVShows)?api_key=\(K.APIKey.tmdb)"
    }
    
    static func getPopularTVShowsURL() -> String {
        return "\(K.API.popularTVShows)?api_key=\(K.APIKey.tmdb)"
    }
    
    static func getSearchURL(text: String) -> String {
        return "\(K.API.search)?api_key=\(K.APIKey.tmdb)&query=\(text)"
    }
    
    static func getNewGuestSessionURL() -> String {
        return "\(K.API.newGuestSession)?api_key=\(K.APIKey.tmdb)"
    }
    
    static func getMovieDetailsURL(movieId: Int) -> String {
        return "\(K.API.movieDetails)\(movieId)?api_key=\(K.APIKey.tmdb)"
    }

    static func getMovieCreditsURL(movieId: Int) -> String {
        return "\(K.API.movieDetails)\(movieId)/credits?api_key=\(K.APIKey.tmdb)"
    }

    static func getRateMovieURL(movieId: Int, guestSessionId: String) -> String {
        return "\(K.API.movieDetails)\(movieId)/rating?api_key=\(K.APIKey.tmdb)&guest_session_id=\(guestSessionId)"
    }
    
    static func getTVShowDetailsURL(showId: Int) -> String {
        return "\(K.API.showDetails)\(showId)?api_key=\(K.APIKey.tmdb)"
    }
    
    static func getTVShowCreditsURL(showId: Int) -> String {
        return "\(K.API.showDetails)\(showId)/aggregate_credits?api_key=\(K.APIKey.tmdb)"
    }
    
    static func getRateTVShowURL(showId: Int, guestSessionId: String) -> String {
        return "\(K.API.showDetails)\(showId)/rating?api_key=\(K.APIKey.tmdb)&guest_session_id=\(guestSessionId)"
    }
    
    static func getPersonDetailsURL(personId: Int) -> String {
        return "\(K.API.personDetails)\(personId)?api_key=\(K.APIKey.tmdb)"
    }
    
    static func getPersonFilmographyURL(personId: Int) -> String {
        return "\(K.API.personDetails)\(personId)/combined_credits?api_key=\(K.APIKey.tmdb)"
    }
    
}
