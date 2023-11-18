//
//  VerifyEmailView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 14/11/2023.
//

import SwiftUI

struct VerifyEmailView: View {
    
    // MARK: - PROPERTIES
    @Binding var presentation: PresentationMode
    @Binding var email: String
    
    @State private var alertTitle: AlertTitle = .success
    @State private var showAlertView: Bool = false
    @State private var alertMessage: String = ""
    
    @EnvironmentObject private var authController: AuthenticationController
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Image("EmailVerification")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 200)
                
                Text("Confirm your email address")
                    .font(.custom("Roboto-Bold", size: 18))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .lineSpacing(10)
                    .padding(.vertical, 10)
                
                Text("We send a confimation email to:")
                    .font(.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .lineSpacing(10)
                    .padding(.vertical, 10)
                
                Text(email)
                    .font(.custom("Roboto-Bold", size: 14))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .lineSpacing(10)
                
                Text("Check your email and click on the \n confirmation link to continue")
                    .font(.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
                
                Button {
                    sendVerificationEmail()
                } label: {
                    Text("Resend Email")
                        .font(.custom("InriaSans-Bold", size: 18))
                        .foregroundColor(.white)
                        .lineSpacing(10)
                        .padding(.vertical, 15)
                } //: Resend email button
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accentColor)
                )
                .padding(.top, 20)
                
                Spacer()
        
            } //: VStack
            .padding(.horizontal, 20)
        } //: ZStack
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    presentation.dismiss()
                }
                .tint(.black)
            }
        } //: Toolbar
        .onAppear {
            sendVerificationEmail()
        }
        .alert(isPresented: $showAlertView) {
            Alert(title: Text(alertTitle.rawValue), message: Text(alertMessage), dismissButton: .default(Text(alertTitle == .success ? "Sign In" : "Cancel")){
                if alertTitle == .success {
                    presentation.dismiss()
                }
            })
        }
    }
    
    // MARK: - FUNCTION
    private func sendVerificationEmail(){
        Task {
            do {
                try await authController.sendEmailVerificationLink()
            } catch {
                print("Sending email error:- \(error.localizedDescription)")
            }
        }
    }
}

struct VerifyEmailView_Previews: PreviewProvider {
    static var previews: some View {
        @Environment(\.presentationMode) var presentationMode
        VerifyEmailView(presentation: presentationMode, email: .constant(""))
    }
}
