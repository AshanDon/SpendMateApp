//
//  UpdatePasswordView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 11/11/2023.
//

import SwiftUI

struct UpdatePasswordView: View {
    
    private enum FocusFields {
        case currentEmail, currentPassword, newPassword, confirmPassword
    }
    
    // MARK: - PROPERTIES
    @State private var currentEmail: String = ""
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLogin: Bool = false
    @State private var alertTitle: AlertTitle = .success
    @State private var showAlertView: Bool = false
    @State private var alertMessage: String = ""
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var authController: AuthenticationController
    
    @FocusState private var focusFields: FocusFields?
    
    private var enableUpdateButton: Bool {
        if currentEmail.isEmpty || currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty {
            return true
        } else {
            return newPassword.elementsEqual(confirmPassword) ? (isLogin ? false : true) : true
        }
    }
    
    @Binding var showSignOutAlert: Bool
    
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
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("New Password")
                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                        .foregroundColor(.black)
                        
                    ZStack(alignment: .leading) {
                        if newPassword.isEmpty {
                            Text("********")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color.black.opacity(0.3))
                                .padding(.bottom, 6)
                                .padding(.leading, 4)
                        }
                        
                        SecureField("", text: $newPassword)
                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                            .keyboardType(.emailAddress)
                            .focused($focusFields, equals: .newPassword)
                            .textFieldStyle(BottomLineTextFieldStyle(lineColor: focusFields == .newPassword ? .accentColor : .black))
                            .textInputAutocapitalization(.never)
                            .submitLabel(.next)
                    }
                } //: New Password Group
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("confirm Password")
                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                        .foregroundColor(.black)
                        
                    ZStack(alignment: .leading) {
                        if confirmPassword.isEmpty {
                            Text("********")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color.black.opacity(0.3))
                                .padding(.bottom, 6)
                                .padding(.leading, 4)
                        }
                        
                        SecureField("", text: $confirmPassword)
                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                            .keyboardType(.emailAddress)
                            .focused($focusFields, equals: .confirmPassword)
                            .textFieldStyle(BottomLineTextFieldStyle(lineColor: focusFields == .confirmPassword ? .accentColor : .black))
                            .textInputAutocapitalization(.never)
                            .submitLabel(.done)
                            .onSubmit {
                                matchNewPassword()
                            }
                    }
                } //: New Password Group
                
                Button(action: {
                    DispatchQueue.main.async {
                        updatePassword()
                    }
                }) {
                    Text("Update")
                        .font(.custom("Roboto-Bold", size: 16))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                } //: Update Button
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.accentColor)
                )
                .disabled(enableUpdateButton)
                .padding(.top, 20)
                
                Spacer()
                
            } //: VStack
            .padding(.top, 30)
            .padding(.horizontal, 20)
        } //: ZStack
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .alert(isPresented: $showAlertView) {
            
            Alert(title: Text(alertTitle.rawValue),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("Ok")){
                if alertTitle == .success {
                    dismiss()
                    showSignOutAlert.toggle()
                }
            }
            )
        } //: Alert
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
    
    private func matchNewPassword(){
        if !newPassword.elementsEqual(confirmPassword) {
            alertTitle = .warning
            alertMessage = "New password and Confirm password must match."
            
            showAlertView.toggle()
            
            newPassword = ""
            confirmPassword = ""
        }
    }
    
    private func updatePassword(){
        do {
            try authController.updateUserPassword(newPassword: confirmPassword)
            alertTitle = .success
            alertMessage = "Your password has been successfully updated."
            
            showAlertView.toggle()
        } catch {
            print("Update Password Error:- \(error.localizedDescription)")
        }
    }
}

struct UpdatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePasswordView(showSignOutAlert: .constant(false))
    }
}
