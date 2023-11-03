//
//  ExpenseController.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 27/10/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ExpenseController: ObservableObject {
    
    private let db = Firestore.firestore()
    
    @Published var expenses = [Expense]()
    @Published var expensesWithCate = [Category]()
    
    func saveExpense(userId: String, expense: Expense) async throws {
        let docRef = db.collection("App")
            .document(userId)
            .collection("expenses")
        
        try docRef.addDocument(from: expense)
            
    }
    
    func fetchExpenses(userId: String) throws {
        db.collection("App")
          .document(userId)
          .collection("expenses")
          .order(by: "date", descending: true)
          .getDocuments { [self] snapshot, error in
              guard let documents = snapshot?.documents else {
                print("No documents")
                return
              }
              
              self.expenses = documents.compactMap { queryDocumentSnapshot -> Expense? in
                    return try? queryDocumentSnapshot.data(as: Expense.self)
              }
        }
    }
}
