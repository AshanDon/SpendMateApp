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
    
    var user = Authentication(id: "", email: "", password: "")
    
    func createUser() async throws -> Authentication {
        let authData = try await Auth.auth().createUser(withEmail: user.email, password: user.password)
        return Authentication(user: authData.user)
    }
    
    func getUserSignedIn() throws -> Bool {
        if Auth.auth().currentUser != nil {
          return true
        } else {
          return false
        }
    }
    
    func signInUser() async throws -> Authentication {
        let authData = try await Auth.auth().signIn(withEmail: user.email, password: user.password)
        return Authentication(user: authData.user)
    }
}
