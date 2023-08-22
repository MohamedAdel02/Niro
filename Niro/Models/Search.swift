//
//  Search.swift
//  Niro
//
//  Created by Mohamed Adel on 02/08/2023.
//

import Foundation


struct Search: Codable {
    
    let results: [SearchResult]
    
}

struct SearchResult: Codable {
    
    let id: Int
    let title: String?
    let name: String?
    let type: String
    let posterPath: String?
    let profilePath: String?

    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case type = "media_type"
        case posterPath = "poster_path"
        case profilePath = "profile_path"
        
    }
    
    
    init(id: Int, title: String?, name: String?, type: String, posterPath: String?, profilePath: String?) {
        
        self.id = id
        self.title = title
        self.name = name
        self.posterPath = posterPath
        self.profilePath = profilePath
        
        
        if type == "movie" {
            self.type = "Movie"
            
        } else if type == "tv" {
            self.type = "TV Show"
            
        } else {
            self.type = ""
            
        }
        
    }
    
}
