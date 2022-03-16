//
//  SearchResultPresentable.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/3/2022.
//

import Foundation

protocol SearchResultPresentable {
    var trackName: String { get }
    var artistName: String { get }
    var bookDescription: String { get }
    var releaseDate: String { get }
    var coverSmall: String { get }
    var coverLarge: String { get }
    var userRatingCount: Int? { get }
    var averageUserRating: Double? { get }
}

extension Book: SearchResultPresentable {}
