//
//  AlertManager.swift
//  
//
//  Created by Berkay Sancar on 2.12.2023.
//

import Foundation
import UIKit

final class AlertManager {
    
    static let shared = AlertManager()
    
    private var keyWindow: UIWindow? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
    
    private init() {}
    
    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let title,
           title == NetworkError.noConnection.rawValue {
            let settingAction = UIAlertAction(title: "Settings", style: .default) { action in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }
            }
            alertController.addAction(settingAction)
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        keyWindow?.rootViewController?.present(alertController, animated: true)
    }
}
