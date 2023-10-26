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
    
    @AppStorage("CurrentUser") private var currentUser: String?
    
    @EnvironmentObject private var categoryController: CategoryController
    
    @Binding var isReloadList: Bool
    
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
                        DispatchQueue.main.async {
                            saveNewCategory()
                        }
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
    
    // FUNCTION
    private func saveNewCategory(){
        Task {
            do {
                let category = Category(categoryName: category)
                
                if let userId = currentUser {
                    try await categoryController.addNewCategory(userId: userId, category: category)
                }
                
                isReloadList.toggle()
                
                dismiss()
                
            } catch {
                print("New Category Error :- \(error.localizedDescription)")
            }
        }
    }
}

struct AddNewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCategoryView(isReloadList: .constant(false))
    }
}
