//
//  AuthManager.swift
//  Niro
//
//  Created by Mohamed Adel on 06/08/2023.
//

import Foundation
import FirebaseAuth

class AuthManger {
    
    static let shared = AuthManger()
    
    private init() { }
    
    func createAccount(name: String, email: String, password: String) async throws {
        
        try await Auth.auth().createUser(withEmail: email, password: password)
        
        try await UpdateUserName(name: name)
    }
    
    
    func UpdateUserName(name: String) async throws {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
    }
    
    
    func signIn(email: String, password: String) async throws {

        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    
    func resetPassword(email: String) async throws {
        
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func resetPassword(currentPassword: String, newPassword: String) async throws {
        
        guard let user = Auth.auth().currentUser, let email = user.email else {
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        try await Auth.auth().currentUser?.reauthenticate(with: credential)
        try await user.updatePassword(to: newPassword)
    }
    
    func signOut() throws {
        
        try Auth.auth().signOut()
    }
    
    
}
