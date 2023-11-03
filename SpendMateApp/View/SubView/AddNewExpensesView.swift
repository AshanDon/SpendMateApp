//
//  AddNewExpensesView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 04/10/2023.
//

import SwiftUI

struct AddNewExpensesView: View {
    
    enum InputField {
        case titleField, descriptionField, amountField
    }
    
    // MARK: - PROPERTIES
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var expenseController: ExpenseController
    @EnvironmentObject private var cateController: CategoryController
    
    @FocusState private var keyboardFocus: InputField?
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var amount: Double = 0.0
    @State private var date: Date = .init()
    @State private var categoryName: String = ""
    @State private var alertTitle: AlertTitle = .success
    @State private var showAlertView: Bool = false
    @State private var alertMessage: String = ""
    
    @Binding var isSaveExpense: Bool
    
    @AppStorage("CurrentUser") private var currentUser: String?
    
    // Decimal Formatter
    var formatter: NumberFormatter {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    // Enable add button
    var disableAddButton: Bool {
        return title.isEmpty || description.isEmpty || amount == .zero || categoryName.isEmpty
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                Section("Title") {
                    TextField("Magic Mouse", text: $title)
                        .keyboardType(.namePhonePad)
                        .focused($keyboardFocus, equals: .titleField)
                }
                
                Section("Description") {
                    TextField("Bought a mouse at the Apple Store", text: $description)
                        .keyboardType(.namePhonePad)
                        .focused($keyboardFocus, equals: .descriptionField)
                }
                
                Section("Amount Spent") {
                    HStack(spacing: 4) {
                        Text("QAR")
                            .fontWeight(.semibold)
                        
                        TextField("0.0", value: $amount, formatter: formatter)
                            .keyboardType(.numberPad)
                            .focused($keyboardFocus, equals: .amountField)
                            .toolbar {
                                if InputField.amountField == keyboardFocus {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        
                                        Button("Cancel") {
                                            keyboardFocus = nil
                                        } //: Cancel Button
                                        .tint(.black)
                                    }
                                }
                            }
                    }
                }
                
                Section("Date") {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                
                HStack {
                    Text("Category")
                    
                    Spacer()
                    
                    Picker("", selection: $categoryName) {
                        Text("").tag("")
                        ForEach(cateController.categorys, id: \.self) { data in
                            Text(data.categoryName).tag(data.categoryName)
                        }
                    } //: Category Picker
                    .pickerStyle(.menu)
                    .labelsHidden()
                } //: HStack
            } //: List
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    } //: Cancel Button
                    .tint(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        saveExpense()
                    } //: Add Button
                    .disabled(disableAddButton)
                }
            }
        } //: Navigation Stack
        .onAppear {
            DispatchQueue.main.async {
                fetchCategory()
            }
        }
        .alert(isPresented: $showAlertView) {
            Alert(title: Text(alertTitle.rawValue), message: Text(alertMessage), dismissButton: .default(Text("Ok")){
                isSaveExpense.toggle()
                dismiss()
            })
        }
    }
    
    
    // MARK: - FUNCTION
    private func fetchCategory(){
        do {
            if let userId = currentUser {
                try cateController.fetchCategory(userId: userId)
            }
        } catch {
            print("Fetching Category Error:- \(error.localizedDescription)")
        }
    }
    
    private func saveExpense(){
        Task {
            do {
                if let userId = currentUser {
                    let newExpense = Expense(title: title, description: description, amount: amount, date: date, category: categoryName)
                    
                    try await expenseController.saveExpense(userId: userId, expense: newExpense)
                    
                    alertTitle = .success
                    alertMessage = "Your expense were successfully saved."
                    showAlertView.toggle()
                    
                }
            } catch {
                print("Save Error:- \(error.localizedDescription)")
            }
        }
    }
}

struct AddNewExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewExpensesView(isSaveExpense: .constant(false))
    }
}
