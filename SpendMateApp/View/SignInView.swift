//
//  SignInView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 05/10/2023.
//

import SwiftUI
import Combine

struct SignInView: View {
    
    enum InputFields {
        case emailField, passwordField
    }
    
    // MARK: - PROPERTIES
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var keyboardHeight: CGFloat = 0
    @State private var isHidePassword = false
    @State private var showSignUpView: Bool = false
    
    @FocusState private var fieldfocus: InputFields?
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                Image("backgroundImage")
                    .resizable()
                    .scaledToFit()
                    .background(Color.accentColor)
                
                Spacer()
                
                
            } //: VStack
            .overlay {
                VStack {
                    Spacer(minLength: keyboardHeight > 0 ? 400 : .nan)
                    
                    Group {
                        VStack(alignment: .center, spacing: 0) {
                            
                            Text("Sign In")
                                .font(.custom("InriaSans-Bold", size: 22))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .lineLimit(0)
                                .padding(.top, 40)
                            
                            VStack(alignment: .leading, spacing: 7) {
                                Text("Email")
                                    .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                    .foregroundColor(.black)
                                    
                                ZStack(alignment: .leading) {
                                    if email.isEmpty {
                                        Text("@gmail.com")
                                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                            .foregroundColor(Color.black.opacity(0.3))
                                            .padding(.bottom, 6)
                                            .padding(.leading, 4)
                                    }
                                    
                                    TextField("", text: $email)
                                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                        .keyboardType(.emailAddress)
                                        .focused($fieldfocus, equals: .emailField)
                                        .textFieldStyle(BottomLineTextFieldStyle(lineColor: fieldfocus == .emailField ? .accentColor : .black))
                                }
                            } //: Email Group
                            .padding(.top, 30)
                            
                            VStack(alignment: .leading, spacing: 7) {
                                Text("Password")
                                    .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                    .foregroundColor(.black)
                                    
                                if isHidePassword {
                                    TextField("", text: $password)
                                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                        .focused($fieldfocus, equals: .passwordField)
                                        .textFieldStyle(BottomLineTextFieldStyle(lineColor: fieldfocus == .passwordField ? .accentColor : .black))
                                        .overlay {
                                            HStack {
                                                Spacer()
                                                
                                                Button(action: {
                                                    isHidePassword.toggle()
                                                }) {
                                                    Image(systemName:isHidePassword ? "eye.fill" : "eye.slash.fill")
                                                        .imageScale(.medium)
                                                        .foregroundColor(isHidePassword ? .accentColor : .black.opacity(0.5))
                                                } // Right Button
                                                .padding(.trailing, 10)
                                                .padding(.bottom, 5)
                                            }
                                        }
                                } else {
                                    ZStack(alignment: .leading) {
                                        if password.isEmpty {
                                            Text("********")
                                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                                .foregroundColor(Color.black.opacity(0.3))
                                                .padding(.bottom, 6)
                                                .padding(.leading, 6)
                                        }
                                        
                                        SecureField("", text: $password)
                                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                            .focused($fieldfocus, equals: .passwordField)
                                            .textFieldStyle(BottomLineTextFieldStyle(lineColor: fieldfocus == .passwordField ? .accentColor : .black))
                                            .overlay {
                                                HStack {
                                                    Spacer()
                                                    
                                                    Button(action: {
                                                        isHidePassword.toggle()
                                                    }) {
                                                        Image(systemName:isHidePassword ? "eye.fill" : "eye.slash.fill")
                                                            .imageScale(.medium)
                                                            .foregroundColor(isHidePassword ? .accentColor : .black.opacity(0.5))
                                                    } // Right Button
                                                    .padding(.trailing, 10)
                                                    .padding(.bottom, 5)
                                                }
                                            }
                                    }
                                    }
                                  
                            } //: Password Group
                            .padding(.top, 30)
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("Forgot password?")
                                        .font(.custom("Inter-VariableFont_slnt,wght", size: 11))
                                        .foregroundColor(.black)
                                } //: Forgot Password Button
                            } //: HStack
                            .padding(.top, 10)
                            
                            Button(action: {}) {
                                Text("Sign In")
                                    .font(.custom("Inter-VariableFont_slnt,wght", size: 20))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                            } //: SignIn Button
                            .frame(maxWidth: .infinity, minHeight: 55)
                            .background(
                                RoundedRectangle(cornerRadius: 5.0)
                                    .fill(Color.accentColor)
                            )
                            .disabled(disableSignInButton)
                            .padding(.top, 20)
                            
                            HStack(alignment: .center, spacing: 4) {
                                
                                Spacer()
                                
                                Text("I'm a new user")
                                    .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                    .foregroundColor(.black)
                                
                                Button("Sign Up") {
                                    showSignUpView.toggle()
                                } //: SignUp Button
                                .font(
                                    .custom("Inter-VariableFont_slnt,wght", size: 14)
                                    .bold()
                                )
                                .tint(Color.accentColor)
                                
                                Spacer()
                                
                            } //: HStack
                            .padding(.vertical, 40)
                        } //: VStack
                        .padding(.horizontal, 38)
                        .padding(.bottom, keyboardHeight)
                    } //: Group
                    .background(
                        Color.white
                            .clipShape(CustomShape())
                    )
                }
            }
        } //: ZStack
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
        .fullScreenCover(isPresented: $showSignUpView) {
            SignUpView()
        }
    }
    
    
    // Disable SignIn Button
    var disableSignInButton: Bool{
        return email.isEmpty || password.isEmpty
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
