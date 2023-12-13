//
//  StorageManager.swift
//
//
//  Created by Berkay Sancar on 7.12.2023.
//

import Foundation

final class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    func addItem<T: Codable>(key: String, item: T) {
        removeItem(key: key)
        let encodedData = try? JSONEncoder().encode(item)
        userDefaults.set(encodedData, forKey: key)
    }
    
    func getItem<T: Codable>(key: String, type: T.Type) -> T? {
        if let data = userDefaults.data(forKey: key),
           let decodedItem = try? JSONDecoder().decode(type, from: data) {
            return decodedItem
        }
        return nil
    }
    
    private func removeItem(key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
