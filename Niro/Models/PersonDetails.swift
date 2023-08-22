//
//  PersonDetails.swift
//  Niro
//
//  Created by Mohamed Adel on 13/08/2023.
//

import Foundation


struct PersonDetails: Codable {
    
    let id: Int
    let name: String
    let profilePath: String?
    let profile: Data?
    let birthday: String?
    let deathday: String?
    let imdbId: String?
    let knownForDepartment: String?

    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case profilePath = "profile_path"
        case profile
        case birthday
        case deathday
        case imdbId = "imdb_id"
        case knownForDepartment = "known_for_department"
    }
    
}

