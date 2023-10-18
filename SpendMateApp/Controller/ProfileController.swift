//
//  ProfileController.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 14/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage

class ProfileController: ObservableObject {
    
    let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private var profileImageReference: StorageReference {
        return storage.reference().child("profileImage")
    }
    
    
    func createProfile(profile: Profile) async throws{
        
        let profileData: [String:Any] = [
            "profile_id": profile.user_id,
            "first_name": profile.first_name,
            "last_name": profile.last_name,
            "image_url": "\(profile.user_id).jpeg",
            "date_created": Timestamp()
        ]
        
        let isSaveImage = try await saveProfileImage(userId: profile.user_id, data: profile.profile_image)
        
        if isSaveImage {
            try await db.collection("profile")
                .document(profile.user_id)
                .setData(profileData, merge: false)
        }
    }
    
    func getProfile(userId: String) async throws -> Profile {
        
        let snapshot = try await db.collection("profile")
            .document(userId)
            .getDocument()
        
        guard let data = snapshot.data(),
              let profileId = data["profile_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let firstName = data["first_name"] as! String
        let lastName = data["last_name"] as! String
        let createdDate = data["date_created"] as! Timestamp
        let profileImage = data["image_url"] as! String
        
        let profileImageData = try await getProfileImage(imagePath: profileImage)
        
        return Profile(user_id: profileId, first_name: firstName, last_name: lastName, profile_image: profileImageData, date_created: createdDate.dateValue())
    }
    
    private func saveProfileImage(userId: String, data: Data) async throws -> Bool{
     
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(userId).jpeg"
        
        let returnMetaData = try await profileImageReference
            .child(path)
            .putDataAsync(data, metadata: meta)
        
        guard let path = returnMetaData.path else {
            throw URLError(.badServerResponse)
        }
        
        return path.isEmpty ? false : true
    }
    
    private func getProfileImage(imagePath: String) async throws -> Data {
        try await profileImageReference.child(imagePath).data(maxSize: 3 * 1024 * 1024)
    }
    
    private func updateProfileImage(userId: String, imageData: Data) async throws -> Bool {
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(userId).jpeg"
        
        let returnMetaData = try await profileImageReference
            .child(path)
            .putDataAsync(imageData, metadata: meta)
        
        guard let path = returnMetaData.path else {
            throw URLError(.badServerResponse)
        }
        
        return path.isEmpty ? false : true
    }
    
    func updateProfileData(profile: Profile) async throws {
        
        let updateProfile = try await updateProfileImage(userId: profile.user_id, imageData: profile.profile_image)
        
        if updateProfile {
            
            let profileData: [String:Any] = [
                "profile_id": profile.user_id,
                "first_name": profile.first_name,
                "last_name": profile.last_name,
                "image_url": "\(profile.user_id).jpeg",
                "date_created": Timestamp()
            ]
            
            let mergeFields: [String] = [
                "first_name",
                "last_name",
                "image_url",
                "date_created"
            ]
            
            try await db.collection("profile")
                .document(profile.user_id)
                .setData(profileData, mergeFields: mergeFields)
        }
    }
}
