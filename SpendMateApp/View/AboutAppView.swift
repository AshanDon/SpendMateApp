//
//  AboutAppView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 12/11/2023.
//

import SwiftUI

struct AboutAppView: View {
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .center, spacing: 20) {
                    GroupBox(
                        label:
                            AboutTitleView(labelText: "SpendMate", labelImage: "info.circle")
                    ) {
                        Divider().padding(.vertical, 4)
                        
                        HStack(alignment: .top, spacing: 10) {
                           
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(9)
                            
                            Text("SpendMate is a user-friendly mobile app designed to help you stay on top of your expenses, no matter where life takes you. With its intuitive interface and powerful features, you can finally gain a clear understanding of your financial health and make informed decisions.")
                                .font(.footnote)
                        }
                    }
                    
                    GroupBox(
                        label:
                            AboutTitleView(labelText: "Application", labelImage: "apps.iphone"))
                    {
                        
                        ApplicationRowView(name: "Developer", content: "Ashan Anuruddika", linkName: nil, destination: nil)
                        ApplicationRowView(name: "Designer", content: "Ashan Anuruddika")
                        ApplicationRowView(name: "Compatibility", content: "iOS 16.4")
                        ApplicationRowView(name: "SwiftUI", content: "4.0")
                        ApplicationRowView(name: "Firebase", content: "10.16.0")
                        ApplicationRowView(name: "Version", content: "0.0.1")
                        ApplicationRowView(name: "GitHub", linkName: "AshanDon", destination: "github.com/AshanDon/SpendMateApp.git")
                        ApplicationRowView(name: "Linkedin", linkName: "Ashan Anuruddika", destination: "www.linkedin.com/in/ashan-anuruddika-464a87112/")
                        ApplicationRowView(name: "Instagram", linkName: "ash_iosdev", destination: "instagram.com/ash_iosdev?igshid=NzZlODBkYWE4Ng%3D%3D&utm_source=qr")
                        
                    }
                } //: VStack
                .padding(.horizontal, 10)
                .padding(.vertical, 20)
            } //: ScrollView
        } //: ZStack
        .navigationTitle("About app")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct AboutAppView_Previews: PreviewProvider {
    static var previews: some View {
        AboutAppView()
    }
}
