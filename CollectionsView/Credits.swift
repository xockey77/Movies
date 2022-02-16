
import Foundation


struct Credits: Decodable {
    let id: Int
    let cast: [Cast]?
}

struct Cast: Hashable, Decodable {
    
    let id: Int
    let name: String
    let character: String
    let order: Int
    let profilePath: String?

    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: Cast, rhs: Cast) -> Bool {
      lhs.identifier == rhs.identifier
    }
    
    var profileUrl: URL? {
        guard let profilePath = profilePath else { return nil }
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")
        return url
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case order
        case profilePath = "profile_path"
    }
}
