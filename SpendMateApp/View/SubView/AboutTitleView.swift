//
//  AboutTitleView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 12/11/2023.
//

import SwiftUI

struct AboutTitleView: View {
    // MARK: - PROPERTIES
    var labelText: String
    var labelImage: String
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Text(labelText.uppercased()).fontWeight(.bold)
            Spacer()
            Image(systemName: labelImage)
        }
    }
}

struct AboutTitleView_Previews: PreviewProvider {
    static var previews: some View {
        AboutTitleView(labelText: "Application", labelImage: "")
    }
}
