//
//  RankingListing.swift
//  TriCurious
//
//  Created by Duff Neubauer on 2/29/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Foundation

struct RankingListing {
    var category: String
    var division: String
    var rankings: [Ranking]
}

extension RankingListing : Equatable {}

struct Ranking {
    var rank: UInt
    var pointsTotal: Double
    var athlete: Athlete
}

extension Ranking : Equatable {}

struct Athlete {
    var firstName: String
    var lastName: String
    var headshot: URL?
    var country: String
    var countryFlag: URL
}

extension Athlete : Equatable {}
