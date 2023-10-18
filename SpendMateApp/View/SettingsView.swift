//
//  SettingsView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 13/10/2023.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - PROPERTIES
    @AppStorage("isUserSignIn") var isUserSignIn: Bool?
    @AppStorage("ProfileComplete") private var isProfileComplete: Bool = false
    
    @State private var showSignOutAlert: Bool = false
    @State private var showLoadingView: Bool = false
    @State private var showUpdateProfileView: Bool = false
    @State private var showNewProfileView: Bool = false
    @State private var userId: String = ""
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var profileCardOpacity: Double = 0
    
    @EnvironmentObject private var authController: AuthenticationController
    @EnvironmentObject private var profileController: ProfileController
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                if !isProfileComplete {
                    Section {
                        ProfileCard(userId: $userId, email: $email, viewOpacitiy: $profileCardOpacity)
                            .opacity(profileCardOpacity == 0 ? 0 : 1)
                            .overlay {
                                ZStack(alignment: .center) {
                                    VStack(alignment: .center, spacing: 4) {
                                        ProgressView()
                                            .tint(.accentColor)
                                            .scaleEffect(1)
                                            .progressViewStyle(CircularProgressViewStyle())
                                        
                                        Text("Loading...")
                                            .font(.custom("Roboto-Regular", size: 12))
                                            .foregroundColor(.accentColor)
                                        
                                    } //: VStack
                                } //: ZStack
                                .opacity(profileCardOpacity == 0 ? 1 : 0)
                            }
                    }
                } else {
                    Section {
                        EmptyProfileCard(showNewProfile: $showNewProfileView)
                    }
                }
                
                
                if !isProfileComplete {
                    Section("Profile") {
                        Button(action: {
                            showUpdateProfileView.toggle()
                        }) {
                            HStack {
                                Text(verbatim: "Update Profile")
                                    .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                    .foregroundColor(Color("#666666"))
                                    .lineSpacing(10)
                                
                                Spacer()
                            }
                        }
                    } //: Profile Section
                }
                
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
            .navigationDestination(isPresented: $showNewProfileView) {
                NewProfile()
            }
            .navigationDestination(isPresented: $showUpdateProfileView) {
                UpdateProfile(showView: $showUpdateProfileView)
            }
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
        .onAppear{
            DispatchQueue.global(qos: .background).async {
                loadAuthenticationData()
            }
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
    
    private func loadAuthenticationData(){
        Task {
            do {
                let auth = try authController.getCurrentUser()
                userId = auth.uid
                email = auth.email
            } catch {
                print("Error:- \(error.localizedDescription)")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

