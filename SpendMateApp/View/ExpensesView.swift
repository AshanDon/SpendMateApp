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
    @State private var reloadExpensesList: Bool = false
    
    @EnvironmentObject private var expenseController: ExpenseController
    
    @AppStorage("CurrentUser") private var currentUser: String?
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                if !expenseController.expenses.isEmpty {
                    ForEach(expenseController.expenses, id: \.self) { expenses in
                        Section("\(expenses.cardTitle)") {
                            ExpensesCardView(expenses: expenses)
                        }
                    }
                }
            } //: List
            .navigationTitle("Expenses")
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddExpenseView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)

                    } //: Add Expense Button
                } //: ToolbarItem
            } //: Toolbar
            .overlay(content: {
                if expenseController.expenses.isEmpty {
                    VStack(alignment: .center) {
                        Spacer()
                        AlertView(labelName: "No Expenses")
                        Spacer()
                    } //: No expenses view
                }
            })
        } //: Navigation Stack
        .searchable(text: $searchExpenses)
        .sheet(isPresented: $showAddExpenseView) {
            AddNewExpensesView(isSaveExpense: $reloadExpensesList)
        }
        .onAppear {
            DispatchQueue.main.async {
                loadExpenses()
            }
        }
        .onChange(of: reloadExpensesList) { isReaload in
            if isReaload {
                loadExpenses()
            }
            
            reloadExpensesList = false
        }
    }
    
    // MARK: - FUNCTION
    private func loadExpenses() {
        do {
            if let userId = currentUser {
                try expenseController.fetchExpenses(userId: userId)
            }
        } catch {
            print("Fetching expenses error:- \(error.localizedDescription)")
        }
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
    }
}
