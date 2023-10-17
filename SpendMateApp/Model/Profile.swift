//
//  Profile.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 14/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Profile {
    var user_id: String
    let first_name: String
    let last_name: String
    let profile_image: Data
    let date_created: Date
}
