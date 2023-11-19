//
//  TabView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 04/10/2023.
//

import SwiftUI

struct MainView: View {
    
    // MARK: - PROPERTIES
    @State private var currentTab: String = "Expenses"

    // MARK: - BODY
    var body: some View {
        TabView(selection: $currentTab) {
            ExpensesView(currentTab: $currentTab)
                .tag("Expenses")
                .tabItem {
                    Image(systemName: "creditcard")
                    Text("Expenses")
                }
            
            CategoriesView()
                .tag("Category")
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("Category")
                }
            
            SettingsView()
                .tag("Settings")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        } //: TabView
    }
    
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
