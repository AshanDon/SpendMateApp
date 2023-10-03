//
//  Extension.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 03/10/2023.
//

import Foundation

// MARK: - Bundle
extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) in bundle.")
        }
        
        guard let decodeData = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) in bundle.")
        }
        
        return decodeData
    }
}
