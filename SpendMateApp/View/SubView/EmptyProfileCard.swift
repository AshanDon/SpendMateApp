//
//  EmptyProfileView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 13/10/2023.
//

import SwiftUI

struct EmptyProfileCard: View {
    
    // MARK: - PROPERTIES
    @EnvironmentObject private var authController: AuthenticationController
    
    @State private var email: String = ""
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100, alignment: .center)
                
                Spacer()
                
            } //: HStack
            
            Text(verbatim: email)
                .font(.custom("Roboto-Regular", size: 12))
                .foregroundColor(.black)
                .opacity(0.6)
                .lineSpacing(41)
                .frame(height: 22)
                .padding(.top, 10)
            
            Button(action: {}) {
                Text("Complete Profile")
                    .font(.custom("Roboto-Bold", size: 12))
                    .foregroundColor(.white)
                    .lineSpacing(20)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 43)
            } //: Complete Button
            .background {
                Rectangle()
                    .fill(Color.accentColor)
            }
        } //: VStack
        .padding(.vertical, 30)
        .onAppear {
            getCurrentUserData()
        }
    }
    
    func getCurrentUserData(){
        do {
            let user = try authController.getCurrentUser()
            
            if !user.email.isEmpty {
                DispatchQueue.main.async {
                    self.email = user.email
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


struct EmptyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyProfileCard()
            .previewLayout(.sizeThatFits)
    }
}
