//
//  SearchResultPresentable.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/3/2022.
//

import Foundation

protocol SearchResultPresentable {
    var title: String { get }
    var author: String { get }
    var content: String { get }
    var coverSmall: String { get }
    var coverLarge: String { get }
    var ratingCount: Int? { get }
    var averageRating: Double? { get }
}
