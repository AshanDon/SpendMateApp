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
    
    @AppStorage("ProfileComplete") private var isProfileComplete: Bool = false
    @AppStorage("CurrentUser") private var currentUser: String?
    
    @EnvironmentObject private var profileController: ProfileController
    
    // MARK: - BODY
    var body: some View {
        TabView(selection: $currentTab) {
            ExpensesView()
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
        .onAppear{
            
            if isProfileComplete == false {
                isCompleteProfile()
            }
            
            currentTab = isProfileComplete ? "Settings" : "Expenses"
        }
    }
    
    
    // MARK: - FUNCTION
    private func isCompleteProfile(){
        Task {
            guard let userId = currentUser else {
                return
            }
            
            do {
                let profile = try await profileController.getProfile(userId: userId)
                
                if !profile.first_name.isEmpty {
                    
                    isProfileComplete = false
                    
                    currentTab = "Expenses"
                }
            } catch {
                
                isProfileComplete = true
                
                currentTab = "Settings"
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
