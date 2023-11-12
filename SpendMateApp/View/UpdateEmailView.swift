//
//  UpdateEmailView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 18/10/2023.
//

import SwiftUI

enum AlertTitle: String {
    case success = "Success!"
    case error = "Error!"
    case warning = "Warning!"
    case attention = "Attention!"
}

struct UpdateEmailView: View {
    
    private enum FocusFields {
        case currentEmail, currentPassword, newEmail, confirmEmail
    }
    
    // MARK: - PROPERTIES
    @State private var currentEmail: String = ""
    @State private var currentPassword: String = ""
    @State private var newEmail: String = ""
    @State private var confirmEmail: String = ""
    @State private var userId: String?
    @State private var oldEmail: String?
    @State private var showAlertView: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLogin: Bool = false
    @State private var newEmailValied: Bool = true
    @State private var confirmEmailValied: Bool = true
    @State private var alertTitle: AlertTitle = .success
    @State private var showLoadingView: Bool = false
    
    @FocusState private var focusFields: FocusFields?
    
    @EnvironmentObject private var authController: AuthenticationController
    
    @Environment(\.dismiss) private var dismiss
    
    private var disableSaveButton: Bool {
        if currentEmail.isEmpty || newEmail.isEmpty || confirmEmail.isEmpty {
            return true
        } else {
            return newEmail.elementsEqual(confirmEmail) ? (isLogin ? false : true) : true
        }
    }
    
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
                    Text("New Email")
                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                        .foregroundColor(.black)
                        
                    ZStack(alignment: .leading) {
                        if newEmail.isEmpty {
                            Text(verbatim: "example@gmail.com")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color.black.opacity(0.3))
                                .padding(.bottom, 6)
                                .padding(.leading, 4)
                        }
                        
                        TextField("", text: $newEmail)
                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                            .keyboardType(.emailAddress)
                            .focused($focusFields, equals: .newEmail)
                            .foregroundColor(newEmailValied ? .black : .red)
                            .textFieldStyle(
                                BottomLineTextFieldStyle(lineColor: focusFields == .newEmail ? .accentColor : (newEmailValied ? .black : .red))
                                )
                            .submitLabel(.next)
                            .textInputAutocapitalization(.never)
                            .onSubmit {
                                if !newEmail.isEmpty {
                                    if(newEmail.range(of:"^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$", options: .regularExpression) != nil) {
                                        newEmailValied = true
                                    } else {
                                        newEmailValied = false
                                    }
                                }
                            }
                            .onTapGesture {
                                if !newEmailValied {
                                    newEmailValied = true
                                    newEmail = ""
                                }
                            }
                    }
                } //: New Email Group
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("Comfirm New Email")
                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                        .foregroundColor(.black)
                        
                    ZStack(alignment: .leading) {
                        if confirmEmail.isEmpty {
                            Text(verbatim: "example@gmail.com")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color.black.opacity(0.3))
                                .padding(.bottom, 6)
                                .padding(.leading, 4)
                        }
                        
                        TextField("", text: $confirmEmail)
                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                            .keyboardType(.emailAddress)
                            .focused($focusFields, equals: .confirmEmail)
                            .foregroundColor(confirmEmailValied ? .black : .red)
                            .textFieldStyle(
                                BottomLineTextFieldStyle(lineColor: focusFields == .confirmEmail ? .accentColor : (confirmEmailValied ? .black : .red)
                                )
                            )
                            .submitLabel(.done)
                            .textInputAutocapitalization(.never)
                            .onSubmit {
                                
                                if !confirmEmail.isEmpty{
                                    
                                    if(confirmEmail.range(of:"^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$", options: .regularExpression) != nil) {
                                        confirmEmailValied = true
                                        
                                        isMatchEmailFields()
                                    } else {
                                        confirmEmailValied = false
                                    }
                                }
                            }
                            .onTapGesture {
                                if !confirmEmailValied{
                                    confirmEmailValied = true
                                    confirmEmail = ""
                                }
                            }
                    }
                    
                } //: Confirm Email Group
                
                Button(action: {
                    DispatchQueue.main.async {
                        showLoadingView.toggle()
                        
                        updateEmailAddress()
                    }
                }) {
                    Text("Update")
                        .font(.custom("Roboto-Bold", size: 16))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                } //: Save Button
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.accentColor)
                )
                .disabled(disableSaveButton)
                .padding(.top, 20)
                
                Spacer()
                
            } //: VStack
            .padding(.top, 30)
            .padding(.horizontal, 20)
        } //: ZStack
        .navigationTitle("Change Email")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlertView) {
            
            Alert(title: Text(alertTitle.rawValue),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("Ok"))
            )
        }
        .overlay {
            if showLoadingView {
                LoadingView()
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    
    // MARK: - FUNCTION
    func reAuthenticateUser(){
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
            }
        }
    }
    private func isMatchEmailFields(){
        if !newEmail.elementsEqual(confirmEmail) {
            alertTitle = .warning
            alertMessage = "New Email and Confirm New Email must match."
            
            showAlertView.toggle()
            
            newEmail = ""
            confirmEmail = ""
        }
    }
    
    private func updateEmailAddress(){
        Task {
            do {
                try await authController.updateEmailAddress(newEmail: confirmEmail)
                
                alertTitle = .success
                alertMessage = "Sent the verification link to the “\(confirmEmail)” via the email."
                
                showLoadingView.toggle()
                showAlertView.toggle()
                
            } catch {
                alertTitle = .error
                alertMessage = error.localizedDescription
                
                showLoadingView.toggle()
                showAlertView.toggle()
                
                print(error.localizedDescription)
            }
        }
    }
}

struct UpdateEmailView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateEmailView()
    }
}
