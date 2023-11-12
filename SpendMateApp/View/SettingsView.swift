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
    @State private var showUpdateEmailView: Bool = false
    @State private var isEmailVerified: Bool = false
    @State private var showAlertView: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: AlertTitle = .success
    @State private var showDeleteAlert: Bool = false
    @State private var showEditPasswordView: Bool = false
    @State private var showAboutApp: Bool = false
    
    @EnvironmentObject private var authController: AuthenticationController
    @EnvironmentObject private var profileController: ProfileController
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                if !isProfileComplete {
                    Section {
                        ProfileCard(userId: $userId,
                                    email: $email,
                                    viewOpacitiy: $profileCardOpacity,
                                    showVerifyEmailButton: $isEmailVerified)
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
                    Button(action: {
                        if isEmailVerified {
                            showUpdateEmailView.toggle()
                        } else {
                            alertTitle = .warning
                            alertMessage = "You have to verify your email address before changing the email address."
                            showAlertView.toggle()
                        }
                    }) {
                        HStack {
                            Text(verbatim: "Change Email")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color("#666666"))
                                .lineSpacing(10)
                            
                            Spacer()
                        }
                    } //: Edit email
                    .alert(isPresented: $showAlertView) {
                        Alert(title: Text(alertTitle.rawValue),
                              message: Text(alertMessage),
                              dismissButton: .default(Text("Ok"))
                        )
                    }
                    
                    Button(action: {
                        showEditPasswordView.toggle()
                    }) {
                        HStack {
                            Text(verbatim: "Update Password")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color("#666666"))
                                .lineSpacing(10)
                            
                            Spacer()
                        }
                    } //: Update Password
                    
                    Button(action: {
                        alertTitle = .warning
                        alertMessage = "All your information will be removed from the app. Are you sure you want to delete your account?"
                        showDeleteAlert.toggle()
                    }) {
                        HStack {
                            Text(verbatim: "Delete Account")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color("#666666"))
                                .lineSpacing(10)
                            
                            Spacer()
                        }
                    } //: Delete Account
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(title: Text(alertTitle.rawValue),
                              message: Text(alertMessage),
                              primaryButton: .destructive(Text("Delete")){
                                DispatchQueue.main.async {
                                    showLoadingView.toggle()
                                    deleteAccount()
                                }
                              },
                              secondaryButton: .cancel())
                    }
                    
                } //: Account Section
                
                Section {
                    Button(action: {
                        showAboutApp.toggle()
                    }) {
                        HStack {
                            Text(verbatim: "About app")
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
            .navigationDestination(isPresented: $showUpdateEmailView) {
                UpdateEmailView()
            }
            .navigationDestination(isPresented: $showEditPasswordView) {
                UpdatePasswordView(showSignOutAlert: $showSignOutAlert)
            }
            .navigationDestination(isPresented: $showAboutApp) {
                AboutAppView()
            }
        } //: NavigationStack
        .alert(isPresented: $showSignOutAlert) {
            Alert(
                title: Text("Attention!"),
                message: Text("Are you sure you want to sign out?"),
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
                checkedEmailVerified()
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
    
    private func checkedEmailVerified(){
        Task {
            do {
                isEmailVerified = try await authController.isEmailVerified()
            } catch {
                print("Error:- \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteAccount(){
        Task {
            do {
                try await authController.deleteProfile()
                
                signOutUser()
                
            } catch {
                alertTitle = .error
                alertMessage = error.localizedDescription
                showAlertView.toggle()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

