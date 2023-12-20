//
//  CategoryController.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 21/10/2023.
//

import Foundation
import FirebaseFirestore

class CategoryController: ObservableObject {
    
    @Published var categorys = [Category]()
    @Published var importantCount = 0
    
    private let db = Firestore.firestore()
    
    func addNewCategory(userId: String, category: Category) async throws {
        
        let documentId = db.collection("categorys").document().documentID
        
        let newCategory: [String:Any] = [
            "categoryId": documentId,
            "profileId": userId,
            "categoryName": category.categoryName,
            "createdDate": Timestamp(),
            "important": category.important ?? false,
            "tagId": category.tagId ?? 0
        ]
        
        try await db.collection("App").document(userId).collection("categorys").addDocument(data: newCategory)
    }
    
    func fetchCategory(userId: String) throws {
        
        db.collection("App")
          .document(userId)
          .collection("categorys")
          .getDocuments { [self] snapshot, error in
              guard let documents = snapshot?.documents else {
                print("No documents")
                return
              }
              
              self.categorys = documents.compactMap { queryDocumentSnapshot -> Category? in
                    return try? queryDocumentSnapshot.data(as: Category.self)
              }
        }
    }
    
    func updateCategory(userId: String, category: Category) async throws {
        let docRef = db.collection("App")
            .document(userId)
            .collection("categorys")
            .document(category.id!)
        
        let updateField: [String:Any] = [
            "categoryName": category.categoryName,
            "tagId": category.tagId!
        ]
        
        try await docRef.updateData(updateField)
    }
    
    func deleteCategory(userId: String, category: Category) async throws {
        let docRef = db.collection("App")
            .document(userId)
            .collection("categorys")
            .document(category.id!)
        
        try await docRef.delete()
    }
    
    func deleteAllData(userId: String) async throws {
        let docRef = db.collection("App")
            .document(userId)
            
        try await docRef.delete()
    }
    
    func manageImportant(userId: String, categoryId: String, isAdd: Bool) async throws{
        let docRef = db.collection("App")
            .document(userId)
            .collection("categorys")
            .document(categoryId)
        
        let updateField = [
            "important": isAdd
        ]
        
        try await docRef.updateData(updateField)
    }
    
    func getImportantCount(userId: String) {
        db.collection("App")
          .document(userId)
          .collection("categorys")
          .whereField("important", isEqualTo: true)
          .getDocuments { [self] snapshot, error in
              guard let documents = snapshot?.documents else {
                print("No documents")
                return
              }
              
              
              self.importantCount = documents.count
        }
    }
}
