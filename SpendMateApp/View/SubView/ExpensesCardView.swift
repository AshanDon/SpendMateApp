//
//  ExpensesCardView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 27/10/2023.
//

import SwiftUI

struct ExpensesCardView: View {
    
    // MARK: - PROPERTIES
    var expenses: Expense
    
    @AppStorage("isLocalCurrency") var isLocalCurrency: String?
    
    // MARK: - BODY
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0) {
                Text(expenses.title)
                    .font(.custom("Roboto-Bold", size: 16))
                    .foregroundColor(.black)
                    .lineSpacing(10)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 5)
                
                Text(expenses.description)
                    .font(.custom("Roboto-Regular", size: 12))
                    .foregroundColor(.black)
                    .lineSpacing(0)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 5)
                
                Text(expenses.category)
                    .font(.custom("Roboto-Bold", size: 12))
                    .foregroundColor(.white)
                    .lineSpacing(10)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.accentColor)
                    )
                    .padding(.vertical, 8)
            } //: VStack
            .padding(.leading, 5)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            
            Spacer()
            
            Text("\(isLocalCurrency ?? localeCurrencyType) \(expenses.amount, specifier: "%.2f")")
                .font(.custom("Roboto-Bold", size: 18))
                .foregroundColor(.black)
                .lineSpacing(10)
                .multilineTextAlignment(.center)
                .padding(.trailing, 7)
        } //: HStack
    }
}

struct ExpensesCardView_Previews: PreviewProvider {
    static var previews: some View {
        let data = Expense(title: "Majic Mouse", description: "Bought a mouse at the Apple Store", amount: 250, date: Date(), category: "Apple Product")
        ExpensesCardView(expenses: data)
            .previewLayout(.sizeThatFits)
    }
}
