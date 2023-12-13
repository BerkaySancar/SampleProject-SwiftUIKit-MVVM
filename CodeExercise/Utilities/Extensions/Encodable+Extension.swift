//
//  Encodable+Extension.swift
//  
//
//  Created by Berkay Sancar on 18.11.2023.
//

import Foundation

extension Encodable {
    func convertToDictionary() -> [String: Any]? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                return nil
            }
            return jsonObject
        } catch {
            print("JSON encoding error: \(error)")
            return nil
        }
    }
}
