//
//  List.swift
//  Niro
//
//  Created by Mohamed Adel on 01/08/2023.
//

import Foundation

struct List: Codable {
    
    let results: [Item]
    
}

struct Item: Codable {
    
    let id: Int
    let title: String?
    let name: String?
    let posterPath: String?
    let poster: Data?
    var rating: Double?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case posterPath = "poster_path"
        case poster
        case rating
        case type
    }
    
    init(id: Int, title: String?, name: String?, poster: Data?) {
        self.id = id
        self.poster = poster
        self.title = title
        self.name = name
        self.posterPath = nil
        self.rating = nil
        self.type = nil
    }
    
    init(id: Int, title: String?, poster: Data?, type: String?) {
        self.id = id
        self.poster = poster
        self.type = type
        self.title = title
        self.name = nil
        self.posterPath = nil
        self.rating = nil
    }


    init(id: Int,title: String?, name: String?, posterPath: String?, rating: Double?, type: String?) {
        self.id = id
        self.rating = rating
        self.posterPath = posterPath
        self.type = type
        self.title = title
        self.name = name
        self.poster = nil
    }
    
}
