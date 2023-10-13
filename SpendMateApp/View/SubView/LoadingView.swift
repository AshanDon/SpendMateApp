//
//  LoadingView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 12/10/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Color.black
                .opacity(0.7)
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                
                Spacer()
                
                Group {
                    ProgressView()
                        .tint(.accentColor)
                        .scaleEffect(3)
                        .progressViewStyle(CircularProgressViewStyle())
                } //: Background
                .frame(width: 80, height: 80, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.white)
                )
                
                Spacer()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
