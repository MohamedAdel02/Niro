//
//  NetworkManager.swift
//  Niro
//
//  Created by Mohamed Adel on 01/08/2023.
//

import Foundation
import Alamofire


class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    
    func data(url: String) async throws -> Data {
        
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
                
        return try await fetchData(url: url)
    }
    
    
    func data(imagePath: String) async throws -> Data {
        
        guard let url = URL(string: "\(K.URL.imageURL)\(imagePath)") else {
            throw URLError(.badURL)
        }
                
        return try await fetchData(url: url)
    }
    
    
    func fetchData(url: URL) async throws -> Data {
        
        let result = await AF.request(url).validate().serializingData().result
        
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
        
    }
    

    func addRating(url: String, rating: Double) async throws {
        
        guard let url = URL(string: url) else {
            return
        }
        
        let ratingData = "{\"value\" : \(rating)}"

        var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = ratingData.data(using: .utf8)
        
        
        let result = await AF.request(request).validate().serializingData().result
        
        switch result {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
     
    
    func removeRating(url: String) async throws {
        
        guard let url = URL(string: url) else {
            return
        }

        let result = await AF.request(url, method: .delete).validate().serializingData().result
        
        switch result {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
        
    }

    
    func decodeData<T: Decodable>(data: Data) throws -> T {
        
        return try JSONDecoder().decode(T.self, from: data)
    }

    
}
