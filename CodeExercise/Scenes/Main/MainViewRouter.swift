//
//  MainViewRouter.swift
//  
//
//  Created by Berkay Sancar on 17.11.2023.
//

import Foundation
import UIKit.UIViewController

protocol MainViewRouterProtocol: AnyObject {
    func toDetail(movieId: Int)
}

final class MainViewRouter {
    
    private weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    static func startMainView() -> MainViewController {
        let view = MainViewController(nibName: "MainView", bundle: nil)
        let router = MainViewRouter(view: view)
        let viewModel = MainViewModel(view: view, router: router)
        
        view.viewModel = viewModel
        
        return view
    }
}

extension MainViewRouter: MainViewRouterProtocol {
    func toDetail(movieId: Int) {
        let detailVC = MovieDetailRouter.startMovieDetail(with: movieId)
        view?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
