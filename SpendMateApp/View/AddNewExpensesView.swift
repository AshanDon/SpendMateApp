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
    @FocusState private var keyboardFocus: InputField?
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var amount: Float = 0
    @State private var date: Date = .init()
    @State private var category: String = ""
    
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
                    
                    Picker("", selection: $category) {
                        
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
                        
                    } //: Add Button
                    .disabled(disableAddButton)
                }
            }
        } //: Navigation Stack
    }
    
    
    // Decimal Formatter
    var formatter: NumberFormatter {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    // Enable add button
    var disableAddButton: Bool {
        return title.isEmpty || description.isEmpty || amount == .zero
    }
}

struct AddNewExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewExpensesView()
    }
}
