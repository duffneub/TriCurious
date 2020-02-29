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
    var rankings: [Athlete]
}

extension RankingListing : Equatable {}
