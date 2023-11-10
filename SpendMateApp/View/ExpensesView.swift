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
    @State private var showEditExpenseView: Bool = false
    @State private var swipeSectionData: Expense?
    
    @EnvironmentObject private var expenseController: ExpenseController
    
    @AppStorage("CurrentUser") private var currentUser: String?
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            let filteredArray = expenseController.expenses.filter({ self.searchExpenses.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(self.searchExpenses)})
            
            List(filteredArray, id: \.self) { expense in
                if filteredArray.isEmpty {
                     NoResultCell()
                } else {
                    Section("\(expense.cardTitle)") {
                        ExpensesCardView(expenses: expense)
                    } //: Section
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                                    
                        Button(role: .destructive) {
                            swipeSectionData = expense
                        } label: {
                            Label("Delete", systemImage: "trash")
                        } //: Delete Category Button
                        
                        Button(role: .none) {
                            swipeSectionData = expense
                            showEditExpenseView.toggle()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        } //: Edit Category Button
                        .tint(.yellow)
                        
                    } //: Swipe Action
                }
            }
            .navigationTitle("Expenses")
            .listStyle(InsetGroupedListStyle())
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
        .searchable(text: $searchExpenses, placement: .navigationBarDrawer, prompt: Text("Search expenses"))
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
        .sheet(isPresented: $showEditExpenseView) {
            EditExpenseView(expense: $swipeSectionData, isUpdated: $reloadExpensesList)
        } //: Sheet
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
