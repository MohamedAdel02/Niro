//
//  FirestoreManager.swift
//  Niro
//
//  Created by Mohamed Adel on 06/08/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class FirestoreManager {
    
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    private init() { }
    
    
    func addTitle(to listName: String, titleId: Int, data: [String: Any]) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let titleId = String(titleId)
        
        try await db.collection("users").document(uid).collection(listName).document(titleId).setData(data)
    }
    
    
    func addGuestSessionId(guestSessionId: String) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let data = ["guestSessionId": guestSessionId]
        
        try await db.collection("users").document(uid).setData(data)
    }
    
    
    func removeTitle(from listName: String, titleId: Int) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let titleId = String(titleId)

        try await db.collection("users").document(uid).collection(listName).document(titleId).delete()
    }
    
    
    func getList(listName: String) async throws -> QuerySnapshot? {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }

        return try await db.collection("users").document(uid).collection(listName).getDocuments()
    }

    
    func getGuestSession() async throws -> String? {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        
        let snapshot = try await db.collection("users").document(uid).getDocument()
        let guestSessionId = snapshot.get("guestSessionId") as? String
        
        return guestSessionId
    }
    
    
    func deleteUser(password: String) async throws {
        
        guard let user = Auth.auth().currentUser, let email = user.email else {
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        try await Auth.auth().currentUser?.reauthenticate(with: credential)
        try await user.delete()

        try await db.collection("users").document(user.uid).collection("favorite").parent?.delete()
        try await db.collection("users").document(user.uid).collection("watchlist").parent?.delete()
        try await db.collection("users").document(user.uid).delete()
                        
    }
     
}
