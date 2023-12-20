//
//  CategoryHeaderCell.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 18/12/2023.
//

import SwiftUI

struct CategoryHeaderCell: View {
    
    // MARK: - PROPERTIES
    @AppStorage("CurrentUser") private var currentUser: String?
    
    @State private var isTapImportant: Bool = false
    
    var categoryData: Category
    
    @Binding var isViewUpdated: Bool
    
    @EnvironmentObject private var categoryController: CategoryController
    
    // MARK: - BODY
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Button(action: {
                
                isTapImportant.toggle()
                
                DispatchQueue.main.async {
                    if let categoryId = categoryData.id {
                        manageImportantTag(categoryId: categoryId)
                    }
                }
            }) {
                Image(systemName: isTapImportant ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(isTapImportant ? .orange : .black)
            } //: Important Button
            .buttonStyle(ScaleButtonStyle())
            .onAppear {
                isTapImportant = categoryData.important ?? false
            }
            
            Text(categoryData.categoryName)
            
            Spacer()
            
            // Tag Circle
            Circle()
                .fill(Color.init(hex: tagList[categoryData.tagId ?? 0].hex_code))
                .frame(width: 15, height: 15)
        }
    }
    
    // MARK: - FUNCTION
    private func manageImportantTag(categoryId: String){
        Task {
            do {
                if let userId = currentUser {
                    
                    try await categoryController.manageImportant(userId: userId, categoryId: categoryId, isAdd: isTapImportant)
                    
                    feedback.impactOccurred()
                    isViewUpdated.toggle()
                }
            } catch {
                print("Add Important Error")
            }
        }
    }
}

struct CategoryHeaderCell_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHeaderCell(categoryData: Category(categoryName: ""), isViewUpdated: .constant(false))
    }
}
