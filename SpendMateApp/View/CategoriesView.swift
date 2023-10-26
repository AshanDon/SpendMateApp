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
    
    @EnvironmentObject private var categoryController: CategoryController
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                if !categoryController.categorys.isEmpty {
                    ForEach(categoryController.categorys, id: \.self) { categoryData in
                        DisclosureGroup {
                
                        } label: {
                            Text(categoryData.categoryName)
                        } //: DisclosureGroup
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                
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
                        }
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
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
