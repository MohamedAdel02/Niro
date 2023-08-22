//
//  MovieDetails.swift
//  Niro
//
//  Created by Mohamed Adel on 09/08/2023.
//

import Foundation


struct MovieDetails: Codable {
    
    let id: Int
    let title: String
    let voteAverage: Float
    let voteCount: Int
    let overview: String
    let status: String
    let runtime: Int
    let releaseDate: String
    let imdbId: String?
    let posterPath: String?
    let poster: Data?
    let backdropPath: String?
    let backdrop: Data?
    let genres: [Genre]
   
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case voteAverage = "vote_average"
        case voteCount =  "vote_count"
        case overview
        case status
        case runtime
        case releaseDate = "release_date"
        case imdbId = "imdb_id"
        case posterPath = "poster_path"
        case poster
        case backdropPath = "backdrop_path"
        case backdrop
        case genres
    }

}

struct Genre: Codable {

    let name: String
    
}


