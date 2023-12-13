//
//  MainViewModel.swift
//  
//
//  Created by Berkay Sancar on 17.11.2023.
//

import Foundation

enum MainViewCellType: CaseIterable {
    case nowPlaying, upcoming
    
    static func numberOfSections() -> Int {
        return self.allCases.count
    }
    
    static func getSection(_ section: Int) -> MainViewCellType {
        return self.allCases[section]
    }
}

protocol MainViewModelOutputs: AnyObject {
    func prepareTableView()
    func dataRefreshed()
    func endRefreshing()
}

protocol MainViewModelProtocol {
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func heightForRowAt(indexPath: IndexPath) -> CGFloat
    func getCellVM(indexPath: IndexPath) -> BaseCellVM
    func didSelectItemAt(indexPath: IndexPath)
    func loadMoreMovieIfNeeded(indexPath: IndexPath)
    func pullToRefreshActivated()
}

final class MainViewModel {
    
    private weak var view: MainViewModelOutputs?
    private let router: MainViewRouterProtocol?
    private let dispatchGroup: DispatchGroup
    
    private var nowPlayings: [Movie] = []
    private var upcomings: [Movie] = []
    
    private var upcomingsPage = 1
    private var upcomingsShouldPagination = false
    
    private var selectedMovieId: Int?
        
    init(view: MainViewModelOutputs, router: MainViewRouterProtocol, dispatchGroup: DispatchGroup = .init()) {
        self.view = view
        self.router = router
        self.dispatchGroup = dispatchGroup
    }
    
    private func getMovies() {
        self.nowPlayings = StorageManager.shared.getItem(key: "nowPlayings", type: [Movie].self) ?? []
        self.upcomings = StorageManager.shared.getItem(key: "upcomings", type: [Movie].self) ?? []
        
        self.dispatchGroup.enter()
        NetworkManager.shared.request(.nowPlayingMovies(page: 1), type: MoviesResponse.self) { [weak self] response in
            guard let self,
                  let response else { return }
            self.dispatchGroup.leave()
            
            StorageManager.shared.addItem(key: "nowPlayings", item: response.results)
            self.nowPlayings = response.results
        }
        
        self.dispatchGroup.enter()
        NetworkManager.shared.request(.upcomingMovies(page: upcomingsPage), type: MoviesResponse.self) { [weak self] response in
            guard let self,
                  let response else { return }
            self.dispatchGroup.leave()
            
            StorageManager.shared.addItem(key: "upcomings", item: response.results)
            self.upcomings = response.results
        }
        
        self.dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.view?.dataRefreshed()
        }
    }
}

extension MainViewModel: MainViewModelProtocol {
 
    func viewDidLoad() {
        getMovies()
        view?.prepareTableView()
    }
    
    func getCellVM(indexPath: IndexPath) -> BaseCellVM {
        switch MainViewCellType.getSection(indexPath.section) {
        case .nowPlaying:
            let viewModel = SliderCellViewModel(self.nowPlayings)
            viewModel.delegate = self
            return viewModel
        case .upcoming:
            return UpcomingCellVM(self.upcomings[indexPath.item])
        }
    }
    
    func numberOfSections() -> Int {
        MainViewCellType.numberOfSections()
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch MainViewCellType.getSection(section) {
        case .nowPlaying:
            1
        case .upcoming:
            upcomings.count
        }
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        switch MainViewCellType.getSection(indexPath.section) {
        case .nowPlaying:
            self.selectedMovieId = self.nowPlayings[indexPath.item].id
        case .upcoming:
            self.selectedMovieId = self.upcomings[indexPath.item].id
        }
        
        if let selectedMovieId {
            router?.toDetail(movieId: selectedMovieId)
        }
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        switch MainViewCellType.getSection(indexPath.section) {
        case .nowPlaying:
            256
        case .upcoming:
            136
        }
    }
    
    func loadMoreMovieIfNeeded(indexPath: IndexPath) {
        if indexPath.item == self.upcomings.count - 1, !self.upcomingsShouldPagination {
            self.upcomingsShouldPagination = true
            self.upcomingsPage += 1
            NetworkManager.shared.request(.upcomingMovies(page: upcomingsPage), type: MoviesResponse.self) { [weak self] response in
                guard let self,
                      let response else { return }
                self.upcomings.append(contentsOf: response.results)
                self.view?.dataRefreshed()
            }
            self.upcomingsShouldPagination = false
        }
    }
    
    func pullToRefreshActivated() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            self.upcomingsPage = 1
            self.getMovies()
            self.view?.endRefreshing()
        }
    }
}

extension MainViewModel: SliderCellDelegate {
    func didSelectMovie(with id: Int) {
        router?.toDetail(movieId: id)
    }
}
