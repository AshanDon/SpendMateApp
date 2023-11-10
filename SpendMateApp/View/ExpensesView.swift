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
    @State private var showAlertView: Bool = false
    @State private var alertTitle: AlertTitle = .success
    @State private var alertMessage: String = ""
    
    @EnvironmentObject private var expenseController: ExpenseController
    
    @AppStorage("CurrentUser") private var currentUser: String?
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            let filteredArray = expenseController.expenses.filter({ self.searchExpenses.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(self.searchExpenses)})
            
            if filteredArray.isEmpty && !searchExpenses.isEmpty{
                NoResultCell()
            } else {
                List(filteredArray, id: \.self) { expense in
                    Section("\(expense.cardTitle)") {
                        ExpensesCardView(expenses: expense)
                    } //: Section
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                                    
                        Button(role: .destructive) {
                            swipeSectionData = expense
                            alertTitle = .attention
                            alertMessage = "Are you sure you want to delete expenses?"
                            showAlertView.toggle()
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
                } //: List
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
            }
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
        .alert(isPresented: $showAlertView) {
            var alertView: Alert
            if alertTitle == .attention {
                alertView = Alert(title: Text(alertTitle.rawValue), message: Text(alertMessage), primaryButton: .destructive(Text("Yes")) {
                    DispatchQueue.main.async {
                        deleteExpense()
                    }
                }, secondaryButton: .cancel())
            } else {
                alertView = Alert(title: Text(alertTitle.rawValue), message: Text(alertMessage), dismissButton: .default(Text(alertTitle == .success ? "Ok" : "Cancel")))
            }
            return alertView
        } //: Alert
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
    
    private func deleteExpense(){
        Task {
            do {
                if let userId = currentUser, let deleteExpense = swipeSectionData {
                    try await expenseController.deleteExpense(userId: userId, expense: deleteExpense)
                    
                    alertTitle = .success
                    alertMessage = "The expense is successfully deleted."
                    showAlertView.toggle()
                    reloadExpensesList.toggle()
                    // Haptic Feedback
                    feedback.impactOccurred()
                }
            } catch {
                alertTitle = .error
                alertMessage = "Sorry, The expense was unsuccessfully deleted. Please try again."
                showAlertView.toggle()
            }
        }
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
    }
}
