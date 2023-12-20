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
    @EnvironmentObject private var expenseController: ExpenseController
    
    @Binding var isUpdate: Bool
    @Binding var category: Category?
    
    @State private var editCategoryName: String = ""
    @State private var oldCategoryName: String = ""
    @State private var selectedTagId: Int = 0
    @State private var oldTagId: Int = 0
    
    @FocusState private var textFocus: Bool
    
    @AppStorage("CurrentUser") private var currentUser: String?
    
    private var enableEditButton: Bool {
        return selectedTagId == oldTagId  ? editCategoryName.isEmpty ? true : false : false
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                Section("Title") {
                    TextField(category!.categoryName, text: $editCategoryName)
                        .keyboardType(.namePhonePad)
                        .focused($textFocus)
                        .submitLabel(.done)
                        .textInputAutocapitalization(.words)
                        .onSubmit {
                            if var category = category, !editCategoryName.isEmpty {
                                category.categoryName = editCategoryName
                                self.category = category
                            }
                        
                        }
                } //: Title Section
                
                Section("Tags") {
                    HStack(alignment: .firstTextBaseline, spacing: 20) {
                        ForEach(tagList) { tag in
                            Circle()
                                .fill(Color.init(hex: tag.hex_code))
                                .frame(width: 20, height: 20, alignment: .center)
                                .overlay {
                                    Circle()
                                        .stroke(category!.tagId ?? 0 == tag.id ? Color.init(hex: tag.hex_code) : .clear, lineWidth: 1.5)
                                        .frame(width: 25, height: 25, alignment: .center)
                                }
                                .onTapGesture {
                                    self.selectedTagId = tag.id
                                    
                                    if var category = category {
                                        category.tagId = self.selectedTagId
                                        self.category = category
                                    }
                                }
                            
                        } //: Loop
                    }
                } //: Tags Section
            } //: List
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
            .onAppear {
                if let category = category {
                    oldCategoryName = category.categoryName
                    oldTagId = category.tagId ?? 0
                }
            }
        } //: Navigation Stack
        .presentationDetents([.height(280)])
        .presentationCornerRadius(20)
        .interactiveDismissDisabled()
    }
    
    // MARK: - FUNCTION
    private func updateCategory(){
        Task {
            do {
                if let userId = currentUser, let editCategory = category {
                    try await cateController.updateCategory(userId: userId, category: editCategory)
                    
                    try await expenseController.updateExpenseCategoryName(userId: userId, oldCategoryName: oldCategoryName, newCategoryName: editCategoryName)
                    
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
