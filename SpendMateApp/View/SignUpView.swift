//
//  SignUpView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 09/10/2023.
//

import SwiftUI
import Combine

struct SignUpView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var isLoading: Bool = false
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                
                Image("backgroundImage")
                    .resizable()
                    .scaledToFit()
                
                Spacer()
                
                
            } //: VStack
            .overlay(
                VStack(alignment: .center, content: {
                    HStack(alignment: .center) {
                        Button(action: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundColor(.black)
                                .frame(width: 25, height: 25)
                        } //: Back Button
                        
                        Spacer()
                    } //: HStack
                    .padding(.top, UIApplication.shared.getSafeAreaTop() - 10)
                    .padding(.leading, 20)
                    
                    Spacer(minLength: keyboardHeight > 0 ? 250 : .nan)
                
                    
                    SignUpContent(presentation: presentationMode, keyboardHeight: $keyboardHeight, showLoading: $isLoading)
                    
                }) //: VStack
            )
            
        } //: ZStack
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
}

// MARK: - SignUpContent
struct SignUpContent: View {
    // MARK: - PROPERTIES
    enum InputFields {
        case emailField, passwordField, rePasswordField
    }
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rePassword: String = ""
    @State private var disableButton = true
    @State private var passwordFieldForegroundColor: Color = .black
    @State private var emailFieldForegroundColor: Color = .black
    @State private var showMainView: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    
    @FocusState private var fieldFocus: InputFields?
    
    @Binding var presentation: PresentationMode
    @Binding var keyboardHeight: CGFloat
    @Binding var showLoading: Bool
    
    @EnvironmentObject private var authController: AuthenticationController
    
    // Check that text fields are empty.
    private var isEmptyFields : Bool {
        return email.isEmpty || password.isEmpty || rePassword.isEmpty
    }
    
    // Check that both password fields are matched.
    private var isPasswordMatched : Bool {
        return password == rePassword ? true : false
    }
    
    // Check the email validation
    private var isValiedEmail: Bool {
        if(email.range(of:"^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$", options: .regularExpression) != nil) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Sign Up")
                .font(.custom("InriaSans-Bold", size: 22))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(0)
                .padding(.top, 40)
            
            VStack(alignment: .center, spacing: 15) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("Email")
                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                        .foregroundColor(.black)
                    
                    ZStack(alignment: .leading) {
                        
                        if email.isEmpty {
                            Text("@gmail.com")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color.black.opacity(0.3))
                                .padding(.bottom, 8)
                                .padding(.leading, 6)
                        }
                        
                        TextField("", text: $email)
                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                            .foregroundColor(emailFieldForegroundColor)
                            .focused($fieldFocus, equals: .emailField)
                            .keyboardType(.emailAddress)
                            .frame(height: 35)
                            .autocorrectionDisabled()
                            .textFieldStyle(BottomLineTextFieldStyle(lineColor: fieldFocus == .emailField ? .accentColor : emailFieldForegroundColor))
                            .onSubmit {
                                if email.isEmpty {
                                    emailFieldForegroundColor = isValiedEmail ? .black : .red
                                }
                            }
                            .submitLabel(.next)
                    } //: ZStack
                } //: Email
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("Password")
                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    ZStack(alignment: .leading) {
                        if password.isEmpty {
                            Text("********")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color.black.opacity(0.3))
                                .padding(.bottom, 4)
                                .padding(.leading, 6)
                        }
                        
                        SecureField("", text: $password)
                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                            .foregroundColor(passwordFieldForegroundColor)
                            .focused($fieldFocus, equals: .passwordField)
                            .keyboardType(.default)
                            .frame(height: 35)
                            .textFieldStyle(BottomLineTextFieldStyle(lineColor: fieldFocus == .passwordField ? .accentColor : passwordFieldForegroundColor))
                            .onSubmit {
                                if password.count <= 5 {
                                    
                                    alertMessage = "The password must be 6 characters long or more."
                                    
                                    showAlert.toggle()
                                    
                                    password = ""
                                }
                            }
                            .submitLabel(.next)
                    }
                } //: Password
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("Re Password")
                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    ZStack(alignment: .leading) {
                        if rePassword.isEmpty {
                            Text("********")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color.black.opacity(0.3))
                                .padding(.bottom, 4)
                                .padding(.leading, 6)
                        }
                        
                        SecureField("", text: $rePassword)
                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                            .foregroundColor(passwordFieldForegroundColor)
                            .focused($fieldFocus, equals: .rePasswordField)
                            .keyboardType(.default)
                            .frame(height: 35)
                            .textFieldStyle(BottomLineTextFieldStyle(lineColor: fieldFocus == .rePasswordField ? .accentColor : passwordFieldForegroundColor))
                            .onSubmit {
                                if !isEmptyFields && isValiedEmail {
                                    disableButton = !isPasswordMatched
                                }
                                
                                if isPasswordMatched {
                                    passwordFieldForegroundColor = .black
                                } else {
                                    passwordFieldForegroundColor = .red
                                }
                            }
                            .submitLabel(.done)
                    }
                } //: Re password
                
                Button(action: {
                    fetchData()
                }) {
                    HStack {
                        
                        Spacer()
                        
                        Text("Sign Up")
                            .font(.custom("Inter-VariableFont_slnt,wght", size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                        
                        Spacer()
                    }
                } //: Sign Up Button
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.accentColor)
                )
                .padding(.top, 10)
                .disabled(disableButton)
            } //: VStack
            .padding(.horizontal, 38)
            .padding(.top, 30)
            .padding(.bottom, keyboardHeight)
            
            HStack(alignment: .center, spacing: 2) {
                
                Text("Do you have a account?")
                    .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                    .foregroundColor(.black)
                
                Button(action: {
                    presentation.dismiss()
                }) {
                    Text("Sign In")
                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                        .foregroundColor(.accentColor)
                }
            } //: HStack
            .padding(.vertical, 36)
        } //: VStack
        .frame(maxWidth: .infinity)
        .background(
            Color.white
                .clipShape(CustomShape())
        )
        .fullScreenCover(isPresented: $showMainView) {
            MainView()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Warning"), message: Text(alertMessage), dismissButton: .cancel())
        }
    }
    
    // MARK: - FUNCTION
    
    private func fetchData(){
        Task {
            showLoading = true
            
            do {
                
                authController.user.email = email
                authController.user.password = password
                
                let result = try await authController.createUser()
                
                if !result.uid.isEmpty {
                    
                    showMainView.toggle()
                    
                    showLoading = false
                    
                } else {
                    alertMessage = "User Not Created."
                    
                    showAlert.toggle()
                    
                    clearAllFields()
                }
            } catch {
                
                showLoading = false
                
                alertMessage = error.localizedDescription
                
                showAlert.toggle()
                
                clearAllFields()
            }
        }
    }
    
    private func clearAllFields(){
        email = ""
        password = ""
        rePassword = ""
        disableButton.toggle()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
