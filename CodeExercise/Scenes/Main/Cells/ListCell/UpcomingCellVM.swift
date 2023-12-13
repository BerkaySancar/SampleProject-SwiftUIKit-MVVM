//
//  UpcomingCellVM.swift
//  
//
//  Created by Berkay Sancar on 18.11.2023.
//

import Foundation

final class UpcomingCellVM: BaseCellVM {
    
    var movie: Movie?
    
    var title: String {
        return movie?.title ?? ""
    }
    
    var overview: String {
        return movie?.overview ?? ""
    }
    
    var releaseDate: String {
        return movie?.releaseDate?.dateWithDots ?? ""
    }
    
    var posterPath: String {
        return movie?.posterPath ?? ""
    }
    
    init(_ movie: Movie? = nil) {
        self.movie = movie
    }
}
