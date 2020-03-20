//
//  Ranking.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/19/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Foundation

struct Ranking {
    var rank: UInt
    var pointsTotal: Double
    var athlete: Athlete
}

extension Ranking : Equatable {}
