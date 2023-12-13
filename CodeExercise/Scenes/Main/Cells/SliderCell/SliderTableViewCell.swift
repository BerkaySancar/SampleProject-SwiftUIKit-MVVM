//
//  SliderTableViewCell.swift
//  
//
//  Created by Berkay Sancar on 17.11.2023.
//

import UIKit

class SliderTableViewCell: UITableViewCell {
    
    static let identifier = "SliderTableViewCell"

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var viewModel: SliderCellViewModel? {
        didSet {
            collectionView.reloadData()
            pageControl.numberOfPages = viewModel?.numberOfRows ?? 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: "NowPlayingCell", bundle: nil), forCellWithReuseIdentifier: NowPlayingCell.identifier)
    }
}

extension SliderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel?.numberOfRows ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCell.identifier, for: indexPath) as! NowPlayingCell
        cell.viewModel = viewModel?.getViewModel(indexPath: indexPath) as? NowPlayingCellVM
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: self.frame.width, height: 256)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
