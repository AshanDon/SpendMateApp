//
//  Authentication.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 11/10/2023.
//

import SwiftUI
import FirebaseAuth

struct Authentication {
    let uid: String
    var email: String
    var password: String
    
    init(id: String, email: String, password: String) {
        self.uid = id
        self.email = email
        self.password = password
    }
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
        self.password = ""
    }
}
