//
//  ActivityIndicatorManager.swift
//  
//
//  Created by Berkay Sancar on 18.11.2023.
//

import Foundation
import UIKit

final class ActivityIndicatorManager {
    
    static let shared = ActivityIndicatorManager()
    
    private lazy var aiv = UIActivityIndicatorView()
    
    private var keyWindow: UIWindow? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
    
    private init() {}
    
    private func configure() {
        if let keyWindow {
            keyWindow.addSubview(self.aiv)
            aiv.startAnimating()
            aiv.style = .medium
            aiv.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate(
                [aiv.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor),
                 aiv.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor)]
            )
        }
    }
    
    func startActivity() {
        DispatchQueue.main.async { [weak self] in
            self?.configure()
        }
    }
    
    func endActivity() {
        DispatchQueue.main.async { [weak self] in
            self?.aiv.removeFromSuperview()
        }
    }
}
