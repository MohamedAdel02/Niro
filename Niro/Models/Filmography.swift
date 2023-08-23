//
//  Filmography.swift
//  Niro
//
//  Created by Mohamed Adel on 14/08/2023.
//

import Foundation


struct Filmography: Codable {
    
    let cast: [FilmographyItem]
    let crew: [FilmographyItem]
}

struct FilmographyItem: Codable {
    
    let id: Int
    let title: String?
    let name: String?
    let mediaType: String
    let posterPath: String?
    let character: String?
    let department: String?
    let job: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case mediaType = "media_type"
        case posterPath = "poster_path"
        case character
        case department
        case job
        
    }
    
}

