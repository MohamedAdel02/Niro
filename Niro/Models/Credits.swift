//
//  Credits.swift
//  Niro
//
//  Created by Mohamed Adel on 09/08/2023.
//

import Foundation


struct Credits: Codable {
    
    let cast: [CastMember]
    let crew: [CrewMember]
    
}


struct CastMember: Codable {
    
    let id: Int
    let name: String
    let profilePath: String?
    let character: String?
    let roles: [Role]?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
        case character
        case roles
        
    }
    
}


struct CrewMember: Codable {
    
    let id: Int
    let name: String
    let job: String?
    
}


struct Role: Codable {
    
    let character: String
}
