//
//  NetworkManager.swift
//  
//
//  Created by Berkay Sancar on 17.11.2023.
//

import Alamofire
import Foundation


enum NetworkError: String, Error {
    case noConnection = "Cellular Data is Turned Off"
    case noConnectionSub = "Turn on cellular data or use Wi-Fi to access data."
    case requestFailed = "Request failed."
    case unauthorized = "Unauthorized request."
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let reachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    
    var isNetworkReachable: Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    private init() {}
    
    func request<T: Codable>(_ router: Router, type: T.Type, completion: @escaping (T?) -> Void) {
        if isNetworkReachable {
            ActivityIndicatorManager.shared.startActivity()
            AF.request(router.urlRequest()).responseDecodable(of: T.self) { response in
                ActivityIndicatorManager.shared.endActivity()
                if let statusCode = response.response?.statusCode {
                    if 200...299 ~= statusCode, response.error == nil,
                       let result = response.value {
                        completion(result)
                    } else if statusCode == 401 {
                        completion(nil)
                        AlertManager.shared.showAlert(title: "Error", message: NetworkError.unauthorized.rawValue)
                        print(router.urlRequest(), "|||status code: 401|||")
                    } else {
                        completion(nil)
                        AlertManager.shared.showAlert(title: "Error", message: NetworkError.requestFailed.rawValue)
                        print(router.urlRequest(), "|||status code: \(statusCode)|||")
                    }
                }
            }
        } else {
            completion(nil)
            AlertManager.shared.showAlert(title: NetworkError.noConnection.rawValue, message: NetworkError.noConnectionSub.rawValue)
        }
    }
}
