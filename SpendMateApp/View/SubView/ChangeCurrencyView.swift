//
//  ChangeCurrencyView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 13/12/2023.
//

import SwiftUI

struct ChangeCurrencyView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @Environment(\.dismissSearch) var dismissSearch
    
    @State private var selectCurrency: String = ""
    @State private var currencyName: String = ""
    @State private var showLoadingView: Bool = false
    
    @AppStorage("isLocalCurrency") var isLocalCurrency: String?
    
    var enableSaveButton: Bool {
        return selectCurrency == isLocalCurrency ?? localeCurrencyType ? true : false
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                
                Section(header: Text("Do you want to change the currency?")) {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .center, spacing: 10) {
                            
                            let filteredCurrencyList = currencyList.filter({ self.currencyName.isEmpty ? true : $0.code.localizedCaseInsensitiveContains(self.currencyName) || $0.name.localizedCaseInsensitiveContains(self.currencyName)})
                            
                            if filteredCurrencyList.isEmpty && !currencyName.isEmpty{
                                NoResultCell()
                            } else {
                                ForEach(filteredCurrencyList) { currency in
                                    CurrencyCell(currency: currency, selectedCurrency: selectCurrency)
                                        .onTapGesture {
                                            self.selectCurrency = currency.code
                                            
                                            dismissSearch()
                                            hideKeyboard()
                                        }
                                } //: Loop
                            }
                        } //: VStack
                        .padding(.top, 5)
                    } //: ScrollView
                } //: Currency Section
                .font(.custom("Roboto-Regular", size: 16))
                .foregroundColor(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .textInputAutocapitalization(.sentences)
                .padding(.top, 5)
            } //: VStack
            .padding(.horizontal, 10)
            .searchable(text: $currencyName, placement: .toolbar, prompt: Text("Search Currency"))
            .onSubmit(of: .search) {
                dismissSearch()
            }
        } //: NavigationStack
        .navigationTitle("Currency")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showLoadingView.toggle()
                    saveSelectedCurrency()
                }) {
                    Text("Save")
                }
                .tint(.accentColor)
                .disabled(enableSaveButton)
            }
        } //: Toolbar
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            selectCurrency = isLocalCurrency ?? localeCurrencyType
        }
        .overlay {
            if showLoadingView {
                LoadingView()
            }
        }
    }
    
    
    // MARK: - FUNCTION
    
    private func saveSelectedCurrency(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            isLocalCurrency = selectCurrency
            showLoadingView.toggle()
            dismiss()
        }
    }
}

struct ChangeCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeCurrencyView()
    }
}

struct CurrencyCell: View {
    
    // MARK: - PROPERTIES
    var currency: CurrencyType
    var selectedCurrency: String
    
    // MARK: - BODY
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("\(currency.code) -  \(currency.name)")
                .font(.custom("Roboto-Regular", size: 16))
                .foregroundColor(currency.code == selectedCurrency ? .accentColor : .black)
                .lineSpacing(0.5)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Spacer()
    
            if currency.code == selectedCurrency {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.accentColor)
                    .shadow(radius: 1)
            }
        } //: HStack
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
}
