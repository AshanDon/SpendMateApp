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
    
    @Binding var userId: String
    @Binding var email: String
    @Binding var viewOpacitiy: Double
    
    @EnvironmentObject private var profileController: ProfileController
    
    
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
                .foregroundColor(.accentColor)
                .lineSpacing(10)
                .padding(.top, 5)
            
            Text(verbatim: email)
                .font(.custom("Roboto-Regular", size: 12))
                .foregroundColor(.black)
                .opacity(0.6)
                .lineSpacing(5)
        } //: VStack
        .opacity(viewOpacitiy)
        .padding(.vertical, 30)
        .onAppear {
            DispatchQueue.global(qos: .background).async {
                loadCurrentUserData()
            }
        }
        .alert(isPresented: $showAlertMessage) {
            Alert(title: Text("System Error!"), message: Text("Please wait a few minutes before you try again."), dismissButton: .cancel())
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
                showAlertMessage.toggle()
            }
        }
    }
}

struct ProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCard(userId: .constant(""), email: .constant(""), viewOpacitiy: .constant(1))
            .previewLayout(.sizeThatFits)
    }
}
