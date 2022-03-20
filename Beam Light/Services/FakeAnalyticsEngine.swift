//
//  FakeAnalyticsEngine.swift
//  Beam Light
//
//  Created by Gerry Gao on 17/3/2022.
//


class FakeAnalyticsEngine: AnalyticsEngine {
    func log(event: AnalyticsEvent) {
        print("Log Event: \(event.name)")
    }
}
