//
//  SpendMateAppApp.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 02/10/2023.
//

import SwiftUI
import Firebase

@main
struct SpendMateAppApp: App {
    
    // MARK: - PROPERTIES
    private let userIsActive = UserDefaults.standard.bool(forKey: "isActive")
    
    @StateObject private var authController = AuthenticationController()
    @StateObject private var profiController = ProfileController()
    @StateObject private var categoryController = CategoryController()
    @StateObject private var expenseController = ExpenseController()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    // MARK: - BODY
    var body: some Scene {
        WindowGroup {
            if userIsActive {
                RootView()
                    .environmentObject(authController)
                    .environmentObject(profiController)
                    .environmentObject(categoryController)
                    .environmentObject(expenseController)
            } else {
                WelcomeView()
                    .environmentObject(authController)
                    .environmentObject(profiController)
                    .environmentObject(categoryController)
                    .environmentObject(expenseController)
            }
        }
    }
}

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      
    print("Configured Firebase..!")
    return true
  }
}
