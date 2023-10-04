//
//  AlertView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 04/10/2023.
//

import SwiftUI

struct AlertView: View {
    
    // MARK: - PROPERTIES
    var labelName: String
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("empty_inbox")

            Text(labelName)
                .font(.custom("InriaSans-Bold", size: 16))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

        } //: VStack
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(labelName: "No Expenses")
            .previewLayout(.sizeThatFits)
    }
}
