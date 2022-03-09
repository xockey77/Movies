
import Foundation

struct MovieCollection: Hashable {
    var title: String = ""
    var movies: [Movie] = []

    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: MovieCollection, rhs: MovieCollection) -> Bool {
      lhs.identifier == rhs.identifier
    }
}
