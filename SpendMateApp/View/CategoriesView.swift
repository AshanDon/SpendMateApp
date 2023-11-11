//
//  CategoriesView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 04/10/2023.
//

import SwiftUI

struct CategoriesView: View {
    
    // MARK: - PROPERTIES
    @AppStorage("CurrentUser") private var currentUser: String?
    
    @State private var showAddCategoryView: Bool = false
    @State private var reloadList: Bool = false
    @State private var showEditCategoryView: Bool = false
    @State private var selectedRowData: Category?
    @State private var showDeleteConformation: Bool = false
    @State private var alertTitle: AlertTitle = .success
    @State private var showAlertView: Bool = false
    @State private var alertMessage: String = ""
    
    @EnvironmentObject private var categoryController: CategoryController
    @EnvironmentObject private var expenseController: ExpenseController
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                if !categoryController.categorys.isEmpty {
                    ForEach(categoryController.categorys, id: \.self) { categoryData in
                        DisclosureGroup {
                            ForEach(expenseController.expenses, id: \.self) { expenseData in
                                
                                if categoryData.categoryName == expenseData.category {
                                    ExpenseDetailCard(expens: expenseData)
                                }
                            }
                        } label: {
                            Text(categoryData.categoryName)
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        selectedRowData = categoryData
                                        alertTitle = .warning
                                        showDeleteConformation.toggle()
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    } //: Delete Category Button
                                    
                                    Button(role: .none) {
                                        selectedRowData = categoryData
                                        showEditCategoryView.toggle()
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    } //: Edit Category Button
                                    .tint(.yellow)
                                } //: Swipe Action
                        } //: DisclosureGroup
                    }
                }
            } //: List
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddCategoryView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)

                    } //: Add category button
                }
            } //: Toolbar
            .overlay {
                if categoryController.categorys.isEmpty {
                    VStack {
                        Spacer()
                        AlertView(labelName: "No Categories")
                        Spacer()
                    } //: VStack
                }
            }
            .alert(isPresented: $showDeleteConformation) {
                Alert(title: Text(alertTitle.rawValue), message: Text("Are you sure you want to delete this category?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete")){
                    deleteCategory()
                })
            } //: Alert View
        } //: Navigation Stack
        .sheet(isPresented: $showAddCategoryView) {
            AddNewCategoryView(isReloadList: $reloadList)
        }
        .onAppear{
            DispatchQueue.main.async {
                fetchCategory()
            }
        }
        .onDisappear {
            categoryController.categorys = []
        }
        .onChange(of: reloadList) { isReload in
            if isReload {
                DispatchQueue.main.async {
                    fetchCategory()
                }
                
                self.reloadList.toggle()
            }
        }
        .sheet(isPresented: $showEditCategoryView) {
            EditCategoryView(isUpdate: $reloadList, category: $selectedRowData)
        }
        .alert(isPresented: $showAlertView) {
            Alert(title: Text(alertTitle.rawValue), message: Text(alertMessage), dismissButton: .cancel(Text("Ok")))
        }
    }
    
    
    // MARK: - FUNCTION
    private func fetchCategory(){
        Task {
            do {
                if let userId = currentUser {
                    try categoryController.fetchCategory(userId: userId)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteCategory(){
        Task {
            do {
                if let userId = currentUser, let category = selectedRowData {
                    try await categoryController.deleteCategory(userId: userId, category: category)
                    
                    try await expenseController.deleteExpenseByCategory(userId: userId, categoryName: category.categoryName)
                    
                    reloadList.toggle()
                    
                    alertTitle = .success
                    alertMessage = "The category was successfully deleted."
                    showAlertView.toggle()
                    // Haptic Feedback
                    feedback.impactOccurred()
                }
            } catch {
                alertTitle = .error
                alertMessage = "The category deleting failed. Please try again."
                showAlertView.toggle()
                
                print("Delete Category Error:- \(error.localizedDescription)")
            }
        }
    }
    
    private func loadExpenses(){
        Task {
            do {
                if let userId = currentUser {
                   try expenseController.fetchExpenses(userId: userId)
                }
            } catch {
                print("fetching error:- \(error.localizedDescription)")
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
