//
//  NoResultCell.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 03/11/2023.
//

import SwiftUI

struct NoResultCell: View {
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            
            Spacer()
            
            VStack(alignment: .center) {
                Image(systemName: "binoculars.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
                Text("Sorry, We couldn't find any expense.")
                    .font(.custom("Roboto-Regular", size: 16))
                    .foregroundColor(.black)
                    .lineSpacing(10)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            } //: VStack
            .padding(.vertical, 10)
            
            Spacer()
        } //: HStack
    }
}

struct NoResultCell_Previews: PreviewProvider {
    static var previews: some View {
        NoResultCell()
            .previewLayout(.sizeThatFits)
    }
}
