//
//  ExpensesView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 03/10/2023.
//

import SwiftUI
import FirebaseAuth

struct ExpensesView: View {
    
    // MARK: - PROPERTIES
    @State private var searchExpenses: String = ""
    @State private var showAddExpenseView: Bool = false
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ZStack {
                List {

                } //: List
                .navigationTitle("Expenses")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            //showAddExpenseView.toggle()
                            do {
                                try Auth.auth().signOut()
                            } catch {
                                
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)

                        } //: Add Expense Button
                    } //: ToolbarItem
                } //: Toolbar
                .overlay {
                    VStack(alignment: .center) {
                        Spacer()
                        AlertView(labelName: "No Expenses")
                        Spacer()
                    } //: No expenses view
                } //: Overlay
            } //: ZStack
        } //: Navigation Stack
        .searchable(text: $searchExpenses)
        .sheet(isPresented: $showAddExpenseView) {
            AddNewExpensesView()
        }
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
    }
}
