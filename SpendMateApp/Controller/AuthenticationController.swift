//
//  AuthenticationController.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 11/10/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


class AuthenticationController: ObservableObject {
    
    @Published var signedIn: Bool = false
    
    var user = Authentication(id: "", email: "", password: "")
    
    func createUser() async throws -> Authentication {
        let authData = try await Auth.auth().createUser(withEmail: user.email, password: user.password).user
        return Authentication(id: authData.uid, email: authData.email!, password: "")
    }
    
    func getUserSignedIn() throws -> Bool {
        if Auth.auth().currentUser != nil {
          return true
        } else {
          return false
        }
    }
    
    func signInUser() async throws -> Authentication {
        let authData = try await Auth.auth().signIn(withEmail: user.email, password: user.password).user
        return Authentication(id: authData.uid, email: authData.email!, password: "")
    }
    
    func getCurrentUser() throws -> Authentication {
        let user = Auth.auth().currentUser
        return Authentication(id: user!.uid, email: user!.email!, password: "")
    }
    
    func signOutCurrentUser() throws{
        try Auth.auth().signOut()
    }
    
    func updateEmailAddress(newEmail: String) async throws {
        
        guard let currentUser = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await currentUser.sendEmailVerification(beforeUpdatingEmail: newEmail)
    }
    
    func reAuthenticationUser(email: String, password: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        try await currentUser.reauthenticate(with: credential)
    }
    
    func isEmailVerified() async throws -> Bool{
        guard let currentUser = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return currentUser.isEmailVerified
    }
    
    func sendEmailVerificationLink() async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await currentUser.sendEmailVerification()
    }
    
    func deleteProfile() async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await currentUser.delete()
    }
    
    func updateUserPassword(newPassword: String) throws{
        guard let currentUser = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        currentUser.updatePassword(to: newPassword)
    }
}
