//
//  Ranking.swift
//  TriCurious
//
//  Created by Duff Neubauer on 2/29/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Foundation

struct Ranking {
    var category: String
    var division: String
    var rankings: [Athlete]
}

extension Ranking : Equatable {}

struct Athlete {
    var firstName: String
    var lastName: String
    var headshot: URL?
    var country: String
    var countryFlag: URL
    var currentRank: UInt
    var currentPointsTotal: Double
}

extension Athlete : Equatable {}
