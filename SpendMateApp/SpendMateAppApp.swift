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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // MARK: - BODY
    var body: some Scene {
        WindowGroup {
            if userIsActive {
                if delegate.isLoged {
                    MainView()
                        .environmentObject(authController)
                } else {
                    SignInView()
                        .environmentObject(authController)
                }
            } else {
                WelcomeView()
                    .environmentObject(authController)
            }
            
        }
    }
}


// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
  
  private let authController = AuthenticationController()
  var isLoged: Bool = false
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      
      do {
         isLoged = try authController.getUserSignedIn()
      } catch {
          print("Error:- \(error.localizedDescription)")
      }
      
    print("Configured Firebase..!")
    return true
  }
}
