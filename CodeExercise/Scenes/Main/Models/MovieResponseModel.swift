//
//  MovieResponseModel.swift
//  
//
//  Created by Berkay Sancar on 17.11.2023.
//

import Foundation

struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let imdbID: String?
    let title: String?
    let posterPath: String?
    let overview: String?
    let releaseDate: String?
    let voteAverage: Float?
    
    private enum CodingKeys: String, CodingKey {
        case id, overview, title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case imdbID = "imdb_id"
    }
}
