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

    static func fake(
        category: String = "Category",
        division: String = "Division",
        rankings: [Athlete] = [ Athlete.fake() ]
    ) -> RankingListing {
        self.init(category: category, division: division, rankings: rankings)
    }
}

extension Athlete {
    static func fake(
        firstName: String = "John",
        lastName: String = "Appleseed",
        headshot: URL = URL(fileURLWithPath: "/path/to/headshot"),
        country: String = "Country",
        countryFlag: URL = URL(fileURLWithPath: "/path/to/flag"),
        currentRank: UInt = 2,
        currentPointsTotal: Double = 72.27
    ) -> Athlete {
        self.init(
            firstName: firstName,
            lastName: lastName,
            headshot: headshot,
            country: country,
            countryFlag: countryFlag,
            currentRank: currentRank,
            currentPointsTotal: currentPointsTotal)
    }
}
