//
//  GuestSession.swift
//  Niro
//
//  Created by Mohamed Adel on 12/08/2023.
//

import Foundation


struct GuestSession: Codable {
    
    let success: Bool
    let id: String

    enum CodingKeys: String, CodingKey {
        case success
        case id = "guest_session_id"
        
    }
    
}
