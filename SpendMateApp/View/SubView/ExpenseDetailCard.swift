//
//  ExpenseDetailCard.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 03/11/2023.
//

import SwiftUI

struct ExpenseDetailCard: View {
    
    // MARK: - PROPERTIES
    var expens: Expense
    @AppStorage("isLocalCurrency") var isLocalCurrency: String?
    
    // MARK: - BODY
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text(expens.title)
                    .font(.custom("Roboto-Bold", size: 16))
                    .foregroundColor(.black)
                    .lineSpacing(10)
                    .multilineTextAlignment(.leading)
                
                Text(expens.description)
                    .font(.custom("Roboto-Regular", size: 12))
                    .foregroundColor(.black.opacity(0.8))
                    .lineSpacing(10)
                    .multilineTextAlignment(.leading)
            } //: VStack
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            
            Spacer()
            
            Text("\(isLocalCurrency ?? localeCurrencyType) \(expens.amount, specifier: "%.2f")")
                .font(.custom("Roboto-Bold", size: 18))
                .foregroundColor(.black)
                .lineSpacing(10)
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
                .padding(.trailing, 10)
        } //: HStack
        .padding(.vertical, 10)
        .background(Color.white)
    }
}

struct ExpenseDetailCard_Previews: PreviewProvider {
    static var previews: some View {
        let expens = Expense(title: "Majic Mose", description: "Bought a mouse at the apple store", amount: 150, date: Date(), category: "Apple Product")
        ExpenseDetailCard(expens: expens)
            .previewLayout(.sizeThatFits)
    }
}
