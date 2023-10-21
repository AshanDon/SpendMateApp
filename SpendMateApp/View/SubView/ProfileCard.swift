//
//  ProfileCard.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 13/10/2023.
//

import SwiftUI

struct ProfileCard: View {
    
    // MARK: - PROPERTIES
    @State private var userName: String = ""
    @State private var imageData: Data?
    @State private var showAlertMessage: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: AlertTitle = .success
    @State private var emailVerifyAlert: Bool = false
    
    @Binding var userId: String
    @Binding var email: String
    @Binding var viewOpacitiy: Double
    @Binding var showVerifyEmailButton: Bool
    
    @EnvironmentObject private var profileController: ProfileController
    @EnvironmentObject private var authController: AuthenticationController
    
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                
                if let imageData = imageData,
                   let uiImage = UIImage(data: imageData){
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipShape(Circle())
                }
                
                Spacer()
                
            } //: HStack
            
            Text(userName)
                .font(.custom("Roboto-Bold", size: 22))
                .foregroundColor(.black)
                .lineSpacing(10)
                .padding(.top, 5)
            
            Text(verbatim: email)
                .font(.custom("Roboto-Regular", size: 12))
                .foregroundColor(.black)
                .opacity(0.6)
                .lineSpacing(5)
            
            if !showVerifyEmailButton {
                Button(action: {
                    sendEmailToVerify()
                }) {
                    HStack(alignment: .center, spacing: 5) {
                        Text("Verify Email")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.white)
                            .lineSpacing(5)
                        
                        Image(systemName: "xmark.seal.fill")
                            .font(Font.footnote.weight(.regular))
                            .imageScale(.medium)
                            .foregroundColor(.white)
                    } //: HStack
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                } //: Verify Email Button
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.accentColor)
                )
                .padding(.top, 5)
                .zIndex(1)
                .alert(isPresented: $emailVerifyAlert) {
                    Alert(title: Text(alertTitle.rawValue),
                          message: Text(alertMessage),
                          dismissButton: .destructive(Text("Ok")){
                        
                        }
                    )
                }
            }
        } //: VStack
        .opacity(viewOpacitiy)
        .padding(.vertical, 30)
        .zIndex(0)
        .onAppear {
            DispatchQueue.global(qos: .background).async {
                loadCurrentUserData()
            }
        }
        .alert(isPresented: $showAlertMessage) {
            Alert(title: Text(alertTitle.rawValue), message: Text(alertMessage), dismissButton: .cancel())
        }
    }
    
    
    // MARK: - FUNCTION
    private func loadCurrentUserData(){
        Task {
            do {
                let profile = try await profileController.getProfile(userId: userId)
                self.userName = "\(profile.first_name) \(profile.last_name)"
                self.imageData = profile.profile_image
                self.viewOpacitiy = 1
            } catch {
                alertTitle = .error
                alertMessage = "Please wait a few minutes before you try again."
                showAlertMessage.toggle()
            }
        }
    }
    
    private func sendEmailToVerify(){
        Task {
            do {
                try await authController.sendEmailVerificationLink()
                
                alertTitle = .attention
                alertMessage = "Sent the verification link to the “\(email)” via the email."
                emailVerifyAlert.toggle()
    
            } catch {
                print(error.localizedDescription)
                alertTitle = .error
                alertMessage = error.localizedDescription
                showAlertMessage.toggle()
                
            }
        }
    }
}

struct ProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCard(userId: .constant(""), email: .constant(""), viewOpacitiy: .constant(1), showVerifyEmailButton: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
