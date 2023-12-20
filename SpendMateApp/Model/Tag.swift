//
//  Tag.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 18/12/2023.
//

import Foundation

struct Tag: Codable, Identifiable {
    let id: Int
    let hex_code: String

    enum CodingKeys: String, CodingKey {
        case id
        case hex_code
    }
}
