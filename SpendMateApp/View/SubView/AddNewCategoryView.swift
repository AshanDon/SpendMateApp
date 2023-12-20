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
    @State private var selectedTagId: Int = 0
    
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
                } //: Title Section
                
                Section("Tags") {
                    HStack(alignment: .firstTextBaseline, spacing: 20) {
                        ForEach(tagList) { tag in
                            Circle()
                                .fill(Color.init(hex: tag.hex_code))
                                .frame(width: 20, height: 20, alignment: .center)
                                .overlay {
                                    Circle()
                                        .stroke(selectedTagId == tag.id ? Color.init(hex: tag.hex_code) : .clear, lineWidth: 1.5)
                                        .frame(width: 25, height: 25, alignment: .center)
                                }
                                .onTapGesture {
                                    self.selectedTagId = tag.id
                                }
                            
                        } //: Loop
                    }
                } //: Tags Section
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
        .presentationDetents([.height(280)])
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
                let category = Category(categoryName: category, tagId: selectedTagId)
                
                if let userId = currentUser {
                    try await categoryController.addNewCategory(userId: userId, category: category)
                }
                
                isReloadList.toggle()
                // Haptic Feedback
                feedback.impactOccurred()
                
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
