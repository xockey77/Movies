//
//  Movie.swift
//  CollectionsView
//
//  Created by Andrey Belov on 14.02.2022.
//

import Foundation

import Foundation
struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String?
    let popularity: Double
    let voteAverage: Double
    let video: Bool
    let adult: Bool
    let voteCount: Int
    let genreIds: [Int]?
    let genres: [Genre]?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?

    var posterUrl: URL? {
        guard let posterPath = posterPath else {
            return nil
        }
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        return url
    }

    var backdropUrl: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")
    }

    var releaseYearToString: String {
        return releaseDate?.split(separator: "-").map(String.init).first ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case popularity
        case voteAverage = "vote_average"
        case video
        case adult
        case voteCount = "vote_count"
        case genres
        case genreIds = "genre_ids"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
    }
}
