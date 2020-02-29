//
//  AthleteRankingsTestUtilities.swift
//  TriCuriousTests
//
//  Created by Duff Neubauer on 2/29/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

@testable import TriCurious

import Foundation

extension RankingListing {
    static var fake: RankingListing {
        .init(category: "Category", division: "Division", rankings: [.fake])
    }
}

extension Athlete {
    fileprivate static var fake: Athlete {
        .init(
            firstName: "John",
            lastName: "Appleseed",
            headshot: URL(fileURLWithPath: "/path/to/headshot"),
            country: "Country",
            countryFlag: URL(fileURLWithPath: "/path/to/flag"),
            currentRank: 2,
            currentPointsTotal: 72.27)
    }
}
