// MARK: - MovieModel
struct UPComingModel: Codable {
    let dates: Dates?
    let page: Int?
    let results: [ResultUP]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum: String?
    let minimum: String?
}

// MARK: - ResultMovie
struct ResultUP: Codable {
    let id: Int?
    let title, originalTitle, overview, posterPath: String?
    let backdropPath: String?
    let mediaType: String?
    let originalLanguage: String?
    let popularity: Double?
    let releaseDate: String?
    let voteAverage, voteCount: Double?
    let genreIds: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case popularity
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
    }
}
