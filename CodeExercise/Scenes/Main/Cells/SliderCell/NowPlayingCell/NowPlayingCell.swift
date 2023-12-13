//
//  NowPlayingCell.swift
//  
//
//  Created by Berkay Sancar on 17.11.2023.
//

import UIKit
import SDWebImage

final class NowPlayingCell: UICollectionViewCell {
    
    static let identifier = "NowPlayingCell"

    @IBOutlet private weak var movieDescriptionLabel: UILabel!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!
    
    var viewModel: NowPlayingCellVM? {
        didSet {
            configureCell()
        }
    }
    
    private func configureCell() {
        movieTitleLabel.text = viewModel?.title
        movieDescriptionLabel.text = viewModel?.overview
        let imageBaseURL = Router.imageUrl(posterPath: viewModel?.posterPath ?? "")
        movieImageView.sd_setImage(with: imageBaseURL.urlRequest().url)
    }
}
