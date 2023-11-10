//
//  EditExpenseView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 05/11/2023.
//

import SwiftUI

struct EditExpenseView: View {
    
    enum InputField {
        case titleField, descriptionField, amountField
    }
    
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var expenseController: ExpenseController
    
    @FocusState private var keyboardFocus: InputField?
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var amount: Double = 0.0
    @State private var date: Date = Date()
    @State private var categoryName: String = ""
    @State private var showAlertView: Bool = false
    @State private var alertTitle: AlertTitle = .success
    @State private var alertMessage: String = ""
    
    @Binding var expense: Expense?
    @Binding var isUpdated: Bool
    
    @AppStorage("CurrentUser") private var currentUser: String?
    
    private var disableDoneButton: Bool {
        return title.isEmpty || description.isEmpty || amount <= 0
    }
    
    // Decimal Formatter
    var formatter: NumberFormatter {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                Section("Title") {
                    TextField("Apple Product's", text: $title)
                        .keyboardType(.namePhonePad)
                        .focused($keyboardFocus, equals: .titleField)
                } //: Title Section
                
                Section("Description") {
                    TextField("Bought a mouse at the Apple Store", text: $description)
                        .keyboardType(.namePhonePad)
                        .focused($keyboardFocus, equals: .descriptionField)
                } //: Description Section
                
                Section("Amount Spent") {
                    HStack(spacing: 4) {
                        Text("QAR")
                            .fontWeight(.semibold)
                        
                        TextField("0.00", value: $amount, formatter: formatter)
                            .keyboardType(.numberPad)
                            .focused($keyboardFocus, equals: .amountField)
                            .toolbar {
                                if InputField.amountField == keyboardFocus {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        
                                        Button("Done") {
                                            keyboardFocus = nil
                                        } //: Cancel Button
                                        .tint(.black)
                                    }
                                }
                            }
                    }
                } //: Spent Amount Section
                
                Section("Date") {
                    DatePicker("", selection: $date, in: ...Date(), displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                } //: Date Section
                
                HStack {
                    Text("Category")
                    
                    Spacer()
                    
                    Text("\(categoryName)")
                        .font(.custom("Roboto-Bold", size: 14))
                        .foregroundColor(.accentColor)
                    
                } //: HStack
            } //: List
            .navigationTitle("Edit Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                } //: Cancel Button
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        updateExpense()
                    }
                    .tint(.blue)
                    .disabled(disableDoneButton)
                }
            } //: Toolbar
        } //: NavigationStack
        .onAppear {
            setData()
        }
        .alert(isPresented: $showAlertView) {
            Alert(title: Text(alertTitle.rawValue), message: Text(alertMessage), dismissButton: .default(Text(alertTitle == .success ? "Ok" : "Cancel").foregroundColor(.black)) {
                if alertTitle == .success {
                    isUpdated.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        dismiss()
                    }
                }
            })
        } //: Alert View
    }
    
    // MARK: - FUNCTION
    private func setData(){
        if let expense = expense {
            title = expense.title
            description = expense.description
            amount = expense.amount
            date = expense.date
            categoryName = expense.category
        }
    }
    
    private func updateExpense(){
        Task {
            do {
                if let userId = currentUser, var expense = expense {
                    
                    expense = Expense(id: expense.id, title: title, description: description, amount: amount, date: date, category: categoryName)
                    
                    try await expenseController.updateExpense(userId: userId, expense: expense)
                    
                    alertTitle = .success
                    alertMessage = "Your expense were successfully updated."
                    showAlertView.toggle()
                }
            } catch {
                alertTitle = .error
                alertMessage = "Unsuccessfully updated. Please try again."
                showAlertView.toggle()
            }
        }
    }
}

struct EditExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        EditExpenseView(expense: .constant(Expense(title: "", description: "", amount: 0.0, date: Date(), category: "")), isUpdated: .constant(false))
    }
}
