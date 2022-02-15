
import Foundation

struct Genre: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
