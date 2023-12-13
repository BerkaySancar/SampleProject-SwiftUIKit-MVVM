//
//  MovieDetailVC.swift
//  
//
//  Created by Berkay Sancar on 18.11.2023.
//

import UIKit
import SDWebImage

final class MovieDetailVC: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var movieDescriptionLabel: UILabel!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieDateLabel: UILabel!
    @IBOutlet private weak var movieRateLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!
    
    var viewModel: MovieDetailVMProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        viewModel.viewDidLayoutSubviews()
    }
    
    @IBAction private func imdbButtonTapped(_ sender: Any) {
        viewModel.imdbButtonTapped()
    }
    
}

extension MovieDetailVC: MovieDetailVMOutput {
    
    func setNavTitle(title: String) {
        self.title = title
    }
    
    func configureUI() {
        if let movie = viewModel.movie {
            movieTitleLabel.text = movie.title
            movieDescriptionLabel.text = movie.overview
            movieRateLabel.text = "\(movie.voteAverage ?? 0)" + "/10"
            let imageURL = Router.imageUrl(posterPath: movie.posterPath ?? "")
            movieImageView.sd_setImage(with: imageURL.urlRequest().url)
            movieDateLabel.text = movie.releaseDate?.dateWithDots
        }
    }
}
