//
//  MainViewController.swift
//  
//
//  Created by Berkay Sancar on 17.11.2023.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    private lazy var refreshControl = UIRefreshControl()
    
    var viewModel: MainViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad()
    }
    
    @objc
    private func pullToRefreshActivated(_ sender: UIRefreshControl) {
        viewModel.pullToRefreshActivated()
    }
}

//MARK: - ViewModel Outputs
extension MainViewController: MainViewModelOutputs {
  
    func prepareTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.contentInsetAdjustmentBehavior = .never
        mainTableView.register(.init(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: SliderTableViewCell.identifier)
        mainTableView.register(.init(nibName: "UpcomingCell", bundle: nil), forCellReuseIdentifier: UpcomingCell.identifier)
        mainTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullToRefreshActivated), for: .valueChanged)
    }
    
    func dataRefreshed() {
        mainTableView.reloadData()
    }
        
    func endRefreshing() {
        self.refreshControl.endRefreshing()
    }
}

//MARK: - TableViewDelegates
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch MainViewCellType.getSection(indexPath.section) {
        case .nowPlaying:
            let cell = tableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.identifier, for: indexPath) as! SliderTableViewCell
            cell.viewModel = viewModel.getCellVM(indexPath: indexPath) as? SliderCellViewModel
            cell.selectionStyle = .none
            return cell
        case .upcoming:
            let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingCell.identifier, for: indexPath) as! UpcomingCell
            cell.viewModel = viewModel.getCellVM(indexPath: indexPath) as? UpcomingCellVM
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            
            viewModel.loadMoreMovieIfNeeded(indexPath: indexPath)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRowAt(indexPath: indexPath)
    }
}
