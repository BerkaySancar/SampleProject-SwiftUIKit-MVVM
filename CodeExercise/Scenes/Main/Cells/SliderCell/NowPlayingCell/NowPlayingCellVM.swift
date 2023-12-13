//
//  NowPlayingCellVM.swift
//  
//
//  Created by Berkay Sancar on 18.11.2023.
//

import Foundation

final class NowPlayingCellVM: BaseCellVM {
    
    var movie: Movie?
    
    var title: String {
        return movie?.title ?? ""
    }
    
    var overview: String {
        return movie?.overview ?? ""
    }
    
    var posterPath: String {
        return movie?.posterPath ?? ""
    }
    
    init(_ movie: Movie? = nil) {
        self.movie = movie
    }
}
