import Foundation

// MARK: - MovieModel
struct MovieModel: Codable {
    let results: [ResultMovie]?
}

// MARK: - ResultMovie
struct ResultMovie: Codable {
    let id: Int?
    let title, originalTitle,originalName, overview, posterPath: String?
    let mediaType: String?
    let originalLanguage: String?
    let popularity: Double?
    let releaseDate: String?
    let voteAverage, voteCount: Double?

}
