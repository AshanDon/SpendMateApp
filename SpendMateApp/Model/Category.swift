//
//  Category.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 21/10/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Category: Codable, Hashable{
    
    @DocumentID var id: String?
    var categoryName: String
    var createdDate: Date?
    var important: Bool?
    var tagId: Int?
    var expenses: [Expense]?
    
}
