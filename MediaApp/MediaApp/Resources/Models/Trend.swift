//
//  Trend.swift
//  MediaApp
//
//  Created by 황민채 on 6/10/24.
//

import Foundation

struct TrendMovie: Decodable {
    let page: Int
    let results: [MovieDetail]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieDetail: Decodable {
    let backdropPath: String
    let id: Int
    let originalTitle: String?
    let overview, posterPath: String
    let adult: Bool
    let title: String?
    let genreIDS: [Int]?
    let popularity: Double
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    let originalName, name, firstAirDate: String?
    let originCountry: [String]?
    let runtime: Int?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case adult, title
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originalName = "original_name"
        case name
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case runtime
    }
}
