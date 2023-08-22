//
//  TVShowDetails.swift
//  Niro
//
//  Created by Mohamed Adel on 13/08/2023.
//

import Foundation


struct TVShowDetails: Codable {
    
    let id: Int
    let name: String
    let voteAverage: Float
    let voteCount: Int
    let status: String
    var seasons: [Seasons]
    let overview: String
    let posterPath: String?
    let poster: Data?
    let backdropPath: String?
    let backdrop: Data?
    let createdBy: [Creator]?
    let genres: [Genre]
   
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case voteAverage = "vote_average"
        case voteCount =  "vote_count"
        case status
        case seasons
        case overview
        case posterPath = "poster_path"
        case poster
        case backdropPath = "backdrop_path"
        case backdrop
        case createdBy = "created_by"
        case genres
    }

}


struct Creator: Codable {
    
    let name: String

}


struct Seasons: Codable {
    
    let id: Int
    let name: String
    let posterPath: String?
    let airDate: String?
    let seasonNumber: Int?
    
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case posterPath = "poster_path"
        case airDate = "air_date"
        case seasonNumber = "season_number"
    }
     
}



