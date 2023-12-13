//
//  Router.swift
//  
//
//  Created by Berkay Sancar on 17.11.2023.
//

import Foundation

enum Router: EndpointProtocol {
    
    case upcomingMovies(page: Int)
    case nowPlayingMovies(page: Int)
    case movieDetail(id: Int)
    case imageUrl(posterPath: String)
    case imdbWebsite(id: String)
    
    private var apiKey: String {
        "3d4171de9e5ec5cba7e23c76ec870a0a"
    }
    
    var baseURL: URL {
        switch self {
        case .upcomingMovies:
            return URL(string: "https://api.themoviedb.org/3/movie")!
        case .nowPlayingMovies:
            return URL(string: "https://api.themoviedb.org/3/movie")!
        case .movieDetail:
            return URL(string: "https://api.themoviedb.org/3/movie")!
        case .imageUrl:
            return URL(string: "https://image.tmdb.org/t/p/w500/")!
        case .imdbWebsite:
            return URL(string: "https://www.imdb.com")!
        }
    }
    
    var path: String {
        switch self {
        case .upcomingMovies:
            return "upcoming"
        case .nowPlayingMovies:
            return "now_playing"
        case .movieDetail(let id):
            return "\(id)"
        case .imageUrl(let posterPath):
            return "\(posterPath)"
        case .imdbWebsite(let id):
            return "title/\(id)"
        }
    }
    
    var httpMethod: HTTPMethods {
        switch self {
        case .upcomingMovies:
            return .get
        case .nowPlayingMovies:
            return .get
        case .movieDetail:
            return .get
        case .imageUrl:
            return .get
        case .imdbWebsite:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .upcomingMovies(let page):
            ["page": page,
             "api_key": apiKey]
        case .nowPlayingMovies(let page):
            ["page": page,
             "api_key": apiKey]
        case .movieDetail:
            ["api_key": apiKey]
        case .imageUrl:
            nil
        case .imdbWebsite:
            nil
        }
    }
}
