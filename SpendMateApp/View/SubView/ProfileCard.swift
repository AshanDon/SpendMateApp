//
//  ProfileCard.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 13/10/2023.
//

import SwiftUI

struct ProfileCard: View {
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
            
            Text("Ashan Anuruddika")
                .font(.custom("Roboto-Bold", size: 22))
                .foregroundColor(.accentColor)
                .lineSpacing(10)
                .padding(.top, 5)
            
            Text(verbatim: "ashan.anuruddika@gmail.com")
                .font(.custom("Roboto-Regular", size: 12))
                .foregroundColor(.black)
                .opacity(0.6)
                .lineSpacing(5)
        } //: VStack
        .padding(.vertical, 30)
    }
}

struct ProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCard()
            .previewLayout(.sizeThatFits)
    }
}
