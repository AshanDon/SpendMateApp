//
//  SettingsView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 13/10/2023.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - PROPERTIES
    @AppStorage("ProfileComplete") private var isProfileComplete: Bool = false
    @AppStorage("isUserSignIn") var isUserSignIn: Bool?
    
    @State private var showSignOutAlert: Bool = false
    @State private var showLoadingView: Bool = false
    @State private var showSignInView: Bool = false
    
    @EnvironmentObject private var authController: AuthenticationController
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            
            
            List {
                Section {
                    Group {
                        if isProfileComplete {
                            ProfileCard()
                        } else {
                            EmptyProfileCard()
                        }
                    } // Profile Group<#code#>
                } //: Profile Data Section
                
                Section("Profile") {
                    Button(action: {}) {
                        HStack {
                            Text(verbatim: "Update Profile")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color("#666666"))
                                .lineSpacing(10)
                            
                            Spacer()
                        }
                    }
                } //: Profile Section
                
                Section("Account") {
                    Button(action: {}) {
                        HStack {
                            Text(verbatim: "Update Email")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color("#666666"))
                                .lineSpacing(10)
                            
                            Spacer()
                        }
                    } //: Edit email
                    
                    Button(action: {}) {
                        HStack {
                            Text(verbatim: "Update Password")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color("#666666"))
                                .lineSpacing(10)
                            
                            Spacer()
                        }
                    } //: Update Password
                    
                    Button(action: {}) {
                        HStack {
                            Text(verbatim: "Delete Account")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color("#666666"))
                                .lineSpacing(10)
                            
                            Spacer()
                        }
                    } //: Delete Account
                    
                } //: Account Section
                
                Section {
                    Button(action: {}) {
                        HStack {
                            Text(verbatim: "About")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color("#666666"))
                                .lineSpacing(10)
                            
                            Spacer()
                        }
                    } //: About
                }
                
                Section {
                    Button(action: {
                        showSignOutAlert.toggle()
                    }) {
                        HStack {
                            Text(verbatim: "Sign Out")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color("#666666"))
                                .lineSpacing(10)
                            
                            Spacer()
                        }
                    } //: Sign Out
                }
            } //: List
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        } //: NavigationStack
        .alert(isPresented: $showSignOutAlert) {
            Alert(
                title: Text(""),
                message: Text("Are you sure you want to sign-up?"),
                primaryButton: .destructive(Text("Yes")) {
                    showLoadingView.toggle()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        signOutUser()
                    }
                },
                secondaryButton: .cancel()
                )
        }
        .overlay {
            if showLoadingView {
                LoadingView()
            }
        }
        .fullScreenCover(isPresented: $showSignInView) {
            SignInView()
        }
    }
    
    // MARK: - FUNCTION
    func signOutUser() {
        Task {
            
            do {
                try authController.signOutCurrentUser()
            } catch {
                print("Error:- \(error.localizedDescription)")
            }
            
            showLoadingView.toggle()
            isUserSignIn = false
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

