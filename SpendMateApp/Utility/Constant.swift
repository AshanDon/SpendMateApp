//
//  Constant.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 03/10/2023.
//

import Foundation
import SwiftUI


// MARK: - Data
let intraductions: [Intraduction] = Bundle.main.decode("Intraduction.json")
let feedback: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)



// MARK: - UI
struct BottomLineTextFieldStyle: TextFieldStyle {
    var lineColor: Color
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack() {
            configuration
                .padding(.leading, 6)
            
            Rectangle()
                .frame(height: 1, alignment: .bottom)
                .foregroundColor(lineColor)
                .padding(.top, 0)
            
        } //: VStack
    }
}
