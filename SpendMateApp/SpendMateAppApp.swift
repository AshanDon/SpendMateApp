//
//  SpendMateAppApp.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 02/10/2023.
//

import SwiftUI

@main
struct SpendMateAppApp: App {
    
    // MARK: - PROPERTIES
    private let userIsActive = UserDefaults.standard.bool(forKey: "isActive")
    
    // MARK: - BODY
    var body: some Scene {
        WindowGroup {
            if !userIsActive {
                WelcomeView()
                //SignUpView()
            } else {
                MainView()
            }
        }
    }
}
