//
//  UpcomingCell.swift
//  
//
//  Created by Berkay Sancar on 18.11.2023.
//

import UIKit

final class UpcomingCell: UITableViewCell {
    
    static let identifier = "UpcomingCell"

    @IBOutlet private weak var movieDateLabel: UILabel!
    @IBOutlet private weak var movieDescriptionLabel: UILabel!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!
    
    var viewModel: UpcomingCellVM? {
        didSet {
            configureCell()
        }
    }
    
    private func configureCell() {
        movieTitleLabel.text = viewModel?.title
        movieDescriptionLabel.text = viewModel?.overview
        movieDateLabel.text = viewModel?.releaseDate
        let imageURL = Router.imageUrl(posterPath: viewModel?.posterPath ?? "")
        movieImageView.sd_setImage(with: imageURL.urlRequest().url)
    }
}
