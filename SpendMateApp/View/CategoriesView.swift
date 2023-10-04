//
//  CategoriesView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 04/10/2023.
//

import SwiftUI

struct CategoriesView: View {
    
    // MARK: - PROPERTIES
    @State private var showAddCategoryView: Bool = false
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                
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
                VStack {
                    Spacer()
                    AlertView(labelName: "No Categories")
                    Spacer()
                } //: VStack
            }
        } //: Navigation Stack
        .sheet(isPresented: $showAddCategoryView) {
            AddNewCategoryView()
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
