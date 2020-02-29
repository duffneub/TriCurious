//
//  Athlete.swift
//  TriCurious
//
//  Created by Duff Neubauer on 2/29/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Foundation

struct Athlete {
    var firstName: String
    var lastName: String
    var headshot: URL
    var country: String
    var countryFlag: URL
    var currentRank: UInt
    var currentPointsTotal: Double
}

extension Athlete : Equatable {}
