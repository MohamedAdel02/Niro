//
//  Constants.swift
//  Niro
//
//  Created by Mohamed Adel on 01/08/2023.
//

import Foundation


struct K {
    
    struct API {
        
        static let popularMovies        = "\(URL.baseURL)movie/popular"
        static let topRatedMovies       = "\(URL.baseURL)movie/top_rated"
        static let commingSoonMovies    = "\(URL.baseURL)movie/upcoming"
        static let topRatedTVShows      = "\(URL.baseURL)tv/top_rated"
        static let popularTVShows       = "\(URL.baseURL)tv/popular"
        static let search               = "\(URL.baseURL)search/multi"
        static let movieDetails         = "\(URL.baseURL)movie/"
        static let showDetails          = "\(URL.baseURL)tv/"
        static let personDetails        = "\(URL.baseURL)person/"
        static let newGuestSession      = "\(URL.baseURL)authentication/guest_session/new"
        static let guestSession         = "\(URL.baseURL)guest_session/"
    }

    struct URL {
        
        static let baseURL      = "https://api.themoviedb.org/3/"
        static let imdbMovie    = "https://www.imdb.com/title/"
        static let imdbPerson   = "https://www.imdb.com/name/"
        static let tmdbMovie    = "https://www.themoviedb.org/movie/"
        static let tmdbTVSHow   = "https://www.themoviedb.org/tv/"
        static let tmdbPerson   = "https://www.themoviedb.org/person/"
        static let imageURL     = "https://www.themoviedb.org/t/p/w440_and_h660_face"
    }
    
    struct APIKey {
        
        static let tmdb = "0d699223dc630e1d65cc7c6941884b31"
    }
    
    
    struct Identifier {
        
        static let moviesCollectionViewCell     = "moviesCollectionViewCell"
        static let genreCollectionViewCell      = "genreCollectionViewCell"
        static let detailsCollectionViewCell    = "detailsCollectionViewCell"
        static let ratingsCollectionViewCell    = "ratingsCollectionViewCell"
        static let tableViewCell                = "tableViewCell"
        static let customTableViewCell          = "customTableViewCell"
    }
    
    
}
