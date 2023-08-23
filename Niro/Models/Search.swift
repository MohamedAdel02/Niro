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
    
}
