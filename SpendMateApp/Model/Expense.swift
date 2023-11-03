//
//  Expense.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 27/10/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Expense: Codable, Hashable {
    
    @DocumentID var id: String?
    var title: String
    var description: String
    var amount: Double
    var date: Date
    var category: String
    
    // Expenses card title
    var cardTitle: String {
        let calender = Calendar.current
        
        if calender.isDateInToday(date) {
            return "Today"
        } else if calender.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}
