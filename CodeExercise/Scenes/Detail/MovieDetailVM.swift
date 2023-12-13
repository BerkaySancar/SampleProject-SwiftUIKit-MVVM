//
//  MovieDetailVM.swift
//  
//
//  Created by Berkay Sancar on 18.11.2023.
//

import Foundation

protocol MovieDetailVMOutput: AnyObject {
    func configureUI()
    func setNavTitle(title: String)
}

protocol MovieDetailVMProtocol {
    var movie: Movie? { get }
    func viewDidLoad()
    func viewDidLayoutSubviews()
    func imdbButtonTapped()
}

final class MovieDetailVM {
    
    private weak var view: MovieDetailVMOutput?
    private let router: MovieDetailRouterProtocol?
    private let movieId: Int
    
    private(set) var movie: Movie? {
        didSet {
            view?.configureUI()
        }
    }
    
    init(view: MovieDetailVMOutput? = nil, router: MovieDetailRouterProtocol, movieId: Int) {
        self.view = view
        self.router = router
        self.movieId = movieId
    }
    
    private func getMovie() {
        NetworkManager.shared.request(.movieDetail(id: movieId), type: Movie.self) { [weak self] response in
            guard let self else { return }
            if let movie = response {
                self.movie = movie
            } else {
                router?.popToMain()
            }
        }
    }
}

extension MovieDetailVM: MovieDetailVMProtocol {
    
    func viewDidLoad() {
        getMovie()
    }
    
    func viewDidLayoutSubviews() {
        view?.setNavTitle(title: movie?.title ?? "")
    }
    
    func imdbButtonTapped() {
        router?.toImdbWebSite(with: movie?.imdbID ?? "")
    }
}
