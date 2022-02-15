
import Foundation

struct Movie: Hashable, Decodable {
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
    
    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    var posterUrl: URL? {
        guard let posterPath = posterPath else { return nil }
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        return url
    }
    
    var backdropUrl: URL? {
        guard let backdropPath = backdropPath else { return nil }
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")
        return url
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
