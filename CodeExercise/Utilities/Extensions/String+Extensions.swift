//
//  String+Extensions.swift
//  
//
//  Created by Berkay Sancar on 18.11.2023.
//

import Foundation

extension String {
    var dateWithDots: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "dd.MM.yyyy"
        
        if let date = formatter.date(from: self) {
            return formatter2.string(from: date)
        }
        return ""
    }
}
