//
//  Currency.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 13/12/2023.
//

import Foundation

struct CurrencyType: Identifiable, Codable, Hashable{
    let id: Int
    let symbol: String
    let name: String
    let symbol_native: String
    let decimal_digits: Int
    let rounding: Double
    let code: String
    let name_plural: String
}
