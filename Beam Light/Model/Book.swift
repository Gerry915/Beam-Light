//
//  Book.swift
//  Beam Light
//
//  Created by Gerry Gao on 28/2/2022.
//

import Foundation

struct Book: Codable {
    
    var coverSmall: String { return Book.processCoverUrl(url: artworkUrl100, size: 200) }
    var coverLarge: String { return Book.processCoverUrl(url: artworkUrl100, size: 900) }
    
    let fileSizeBytes: Int?
    let formattedPrice, trackCensoredName: String?
    let artistViewURL, trackViewURL: String
    let artworkUrl60, artworkUrl100: String
    let releaseDate: String
    let trackName: String
//    let artistIDS: [Int]
//    let trackID: Int
//    let genreIDS: [String]
    let currency: String
    let bookDescription: String
    let artistID: Int
    let artistName: String
//    let genres: [String]
    let price: Double?
//    let kind: String
    let averageUserRating: Double?
    let userRatingCount: Int?

    enum CodingKeys: String, CodingKey {
        case fileSizeBytes, formattedPrice, trackCensoredName
        case artistViewURL = "artistViewUrl"
        case trackViewURL = "trackViewUrl"
        case artworkUrl60, artworkUrl100
//        case trackID = "trackId"
//        case artistIDS = "artistIds"
//        case genreIDS = "genreIds"
        case releaseDate
        case trackName
        case currency
        case bookDescription = "description"
        case artistID = "artistId"
        case artistName
        case price
//        case genres
//        case kind
        case averageUserRating
        case userRatingCount
    }
    
    // MARK: - Helper
    
    /// Returns the book cover URL with a given `size`
    static func processCoverUrl(url: String?, size: Int) -> String {
        guard let url = url else { return "" }
        let endIndex = url.index(url.endIndex, offsetBy: -13)
        return url[...endIndex] + "\(size)x\(size).jpg"
    }
}
