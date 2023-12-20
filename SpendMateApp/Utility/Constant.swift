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
let currencyList: [CurrencyType] = Bundle.main.decode("Currency.json")
let tagList: [Tag] = Bundle.main.decode("Tags.json")

// MARK: - System
let feedback: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
let localeCurrencyType: String = Locale.current.currency!.identifier


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

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.5 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
