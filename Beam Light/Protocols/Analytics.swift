//
//  Analytics.swift
//  Beam Light
//
//  Created by Gerry Gao on 17/3/2022.
//

import Foundation

protocol AnalyticsEngine {
    func log(event: AnalyticsEvent)
}

protocol AnalyticsEvent {
    var name: String { get }
    var metaData: [String:String] { get }
}
