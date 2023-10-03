//
//  OnboardView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 03/10/2023.
//

import SwiftUI

struct OnboardView: View {
    
    // MARK: - PROPERTIES
    var intru: Intraduction
    
    // MARK: - BODY
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 0) {
                Image(intru.image)
                    .resizable()
                    .scaledToFit()
                
                Text(intru.description)
                    .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .frame(alignment: .center)
            } //: VStack
            .background(Color.accentColor)
            .padding(.horizontal, 33)
        } //: ZStack
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView(intru: intraductions[0])
            .previewLayout(.sizeThatFits)
    }
}
