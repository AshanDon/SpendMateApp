//
//  UpdatePasswordView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 11/11/2023.
//

import SwiftUI

struct DeleteAccountView: View {
    
    private enum FocusFields {
        case currentEmail, currentPassword
    }
    
    // MARK: - PROPERTIES
    @State private var currentEmail: String = ""
    @State private var currentPassword: String = ""
    @State private var isLogin: Bool = false
    @State private var alertTitle: AlertTitle = .success
    @State private var showAlertView: Bool = false
    @State private var alertMessage: String = ""
    @State private var showLoadingView: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var authController: AuthenticationController
    @EnvironmentObject private var profileController: ProfileController
    @EnvironmentObject private var categoryController: CategoryController
    
    @FocusState private var focusFields: FocusFields?
    
    @AppStorage("CurrentUser") private var currentUser: String?
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 15) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("Current Email")
                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                        .foregroundColor(.black)
                        
                    ZStack(alignment: .leading) {
                        if currentEmail.isEmpty {
                            Text(verbatim: "example@gmail.com")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color.black.opacity(0.3))
                                .padding(.bottom, 6)
                                .padding(.leading, 4)
                        }
                        
                        TextField("", text: $currentEmail)
                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                            .keyboardType(.emailAddress)
                            .focused($focusFields, equals: .currentEmail)
                            .textFieldStyle(BottomLineTextFieldStyle(lineColor: focusFields == .currentEmail ? .accentColor : .black))
                            .textInputAutocapitalization(.never)
                            .overlay {
                                if isLogin {
                                    HStack(alignment: .center) {
                                        
                                        Spacer()
                                        
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(Font.body.weight(.regular))
                                            .imageScale(.medium)
                                            .foregroundColor(.green)
                                    }
                                    .padding(.bottom, 5)
                                    .padding(.trailing, 5)
                                }
                            }
                            .submitLabel(.next)
                    }
                } //: Current Email Group
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("Current Password")
                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                        .foregroundColor(.black)
                        
                    ZStack(alignment: .leading) {
                        if currentPassword.isEmpty {
                            Text("********")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color.black.opacity(0.3))
                                .padding(.bottom, 6)
                                .padding(.leading, 4)
                        }
                        
                        SecureField("", text: $currentPassword)
                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                            .keyboardType(.emailAddress)
                            .focused($focusFields, equals: .currentPassword)
                            .textFieldStyle(BottomLineTextFieldStyle(lineColor: focusFields == .currentPassword ? .accentColor : .black))
                            .textInputAutocapitalization(.never)
                            .overlay {
                                if isLogin {
                                    HStack(alignment: .center) {
                                        
                                        Spacer()
                                        
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(Font.body.weight(.regular))
                                            .imageScale(.medium)
                                            .foregroundColor(.green)
                                    }
                                    .padding(.bottom, 5)
                                    .padding(.trailing, 5)
                                }
                            }
                            .submitLabel(.next)
                            .onSubmit {
                                DispatchQueue.main.async {
                                    reAuthenticateUser()
                                }
                            }
                    }
                } //: Current Password Group
                
                Button(action: {
                    DispatchQueue.main.async {
                        showLoadingView.toggle()
                        deleteAccount()
                    }
                }) {
                    Text("Delete Account")
                        .font(.custom("Roboto-Bold", size: 16))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                } //: Update Button
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.accentColor)
                )
                .disabled(isLogin ? false : true)
                .padding(.top, 20)
                
                Spacer()
                
            } //: VStack
            .padding(.top, 30)
            .padding(.horizontal, 20)
        } //: ZStack
        .navigationTitle("Delete Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .alert(isPresented: $showAlertView) {
            
            Alert(title: Text(alertTitle.rawValue),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("Ok")){
                if alertTitle == .success {
                    authController.signedIn = false
                }
            }
            )
        } //: Alert
        .overlay {
            if showLoadingView {
                LoadingView()
            }
        }
    }
    
    // MARK: - FUNCTION
    private func reAuthenticateUser(){
        Task {
            do {
                
                try await authController.reAuthenticationUser(email: currentEmail, password: currentPassword)
                isLogin = true
                
            } catch {
                alertTitle = .error
                alertMessage = "Invalid email or password. Please enter a valid email or password."
                showAlertView.toggle()
                
                currentEmail = ""
                currentPassword = ""
                isLogin = false
            }
        }
    }
    
    private func deleteAccount(){
        Task {
            do {
                if let userId = currentUser {
                    try await authController.deleteProfile()
                    try await profileController.deleteProfile(userId: userId)
                    try await categoryController.deleteAllData(userId: userId)
                }
                
                showLoadingView.toggle()
                
                alertTitle = .success
                alertMessage = "Account has been successfully deleted"
                showAlertView.toggle()
                
            } catch {
                alertTitle = .error
                alertMessage = error.localizedDescription
                showAlertView.toggle()
            }
        }
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView()
    }
}
