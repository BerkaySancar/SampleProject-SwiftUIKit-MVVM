//
//  MovieDetailRouter.swift
//  
//
//  Created by Berkay Sancar on 18.11.2023.
//

import Foundation
import UIKit.UIViewController
import SafariServices

protocol MovieDetailRouterProtocol {
    func toImdbWebSite(with id: String)
    func popToMain()
}

final class MovieDetailRouter {
    
    private weak var view: UIViewController?
    
    init(view: UIViewController? = nil) {
        self.view = view
    }
    
    static func startMovieDetail(with movieId: Int) -> MovieDetailVC {
        let view = MovieDetailVC(nibName: "MovieDetailView", bundle: nil)
        let router = MovieDetailRouter(view: view)
        let viewModel = MovieDetailVM(view: view, router: router, movieId: movieId)
        
        view.viewModel = viewModel
        
        return view
    }
}

extension MovieDetailRouter: MovieDetailRouterProtocol {
    func toImdbWebSite(with id: String) {
        let url = Router.imdbWebsite(id: id)
        let safariVC = SFSafariViewController(url: url.urlRequest().url!)
        self.view?.present(safariVC, animated: true)
    }
    
    func popToMain() {
        self.view?.navigationController?.popToRootViewController(animated: true)
    }
}
