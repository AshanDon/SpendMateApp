//
//  AddNewCategoryView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 04/10/2023.
//

import SwiftUI

struct AddNewCategoryView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.dismiss) private var dismiss
    @State private var category: String = ""
    @FocusState private var keyboardFocus: Bool
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                Section("Title") {
                    TextField("Apple Product's", text: $category)
                        .keyboardType(.namePhonePad)
                        .focused($keyboardFocus)
                }
            } //: List
            .navigationTitle("Add Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                } //: Cancel Button
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        
                    }
                    .tint(.blue)
                    .disabled(disableAddButton)
                }
            }
        } //: Navigation Stack
        .presentationDetents([.height(180)])
        .presentationCornerRadius(20)
        .interactiveDismissDisabled()
        
        // Disable add button
        var disableAddButton: Bool {
            return category.isEmpty
        }
    }
}

struct AddNewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCategoryView()
    }
}
