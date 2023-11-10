//
//  EditCategoryView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 26/10/2023.
//

import SwiftUI
import Combine

struct EditCategoryView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var cateController: CategoryController
    
    @Binding var isUpdate: Bool
    @Binding var category: Category?
    
    @State private var editCategoryName: String = ""
    
    @FocusState private var textFocus: Bool
    
    @AppStorage("CurrentUser") private var currentUser: String?
    
    private var enableEditButton: Bool {
        return editCategoryName.isEmpty
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Section("Title") {
                    TextField(category!.categoryName, text: $editCategoryName)
                        .keyboardType(.namePhonePad)
                        .focused($textFocus)
                        .submitLabel(.done)
                        .textInputAutocapitalization(.words)
                        .onSubmit {
                            if var category = category {
                                category.categoryName = editCategoryName
                                self.category = category
                            }
                        
                        }
                }
                .padding(.horizontal, 20)
            } //: VStack
            .navigationTitle("Edit Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Update", role: .none) {
                        updateCategory()
                    }
                    .tint(.blue)
                    .disabled(enableEditButton)
                }
            } //: Tool Bar
        } //: Navigation Stack
        .presentationDetents([.height(180)])
        .presentationCornerRadius(20)
        .interactiveDismissDisabled()
    }
    
    // MARK: - FUNCTION
    private func updateCategory(){
        Task {
            do {
                if let userId = currentUser, let editCategory = category {
                    try await cateController.updateCategory(userId: userId, category: editCategory)
                    
                    isUpdate.toggle()
                    // Haptic Feedback
                    feedback.impactOccurred()
                    
                    dismiss()
                }
            } catch {
                print("Category Update Error:- \(error.localizedDescription)")
            }
        }
    }
}

struct EditCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        EditCategoryView(isUpdate: .constant(false), category: .constant(Category(categoryName: "")))
    }
}
