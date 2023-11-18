//
//  RootView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 18/11/2023.
//

import SwiftUI

struct RootView: View {
    
    // MARK: - PROPERTIES
    @EnvironmentObject private var authController: AuthenticationController
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            if authController.signedIn{
                MainView()
            } else {
                SignInView()
            }
        }
        .onAppear {
            userSignedIn()
        }
    }
    
    // MARK: - FUNCTION
    private func userSignedIn(){
        do {
            authController.signedIn = try authController.getUserSignedIn()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
