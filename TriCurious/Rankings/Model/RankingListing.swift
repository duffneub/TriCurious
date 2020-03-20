//
//  RankingListing.swift
//  TriCurious
//
//  Created by Duff Neubauer on 2/29/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Foundation

struct RankingListing {
    let id: UInt
    var category: String
    var division: String
    var rankings: [Ranking]
}

extension RankingListing : Equatable {}

extension RankingListing : Comparable {
    private var isRegional: Bool {
        category.contains("Regional")
    }

    private var isPhysicallyImpaired: Bool {
        category.contains("Paralympics") || category.contains("Paratriathlon")
    }

    // Order from last to first: regional, physically imparied, everything else
    static func < (lhs: RankingListing, rhs: RankingListing) -> Bool {
        guard lhs.category != rhs.category else { return true }

        if lhs.isRegional && rhs.isRegional {
            return lhs.category < rhs.category
        }
        if lhs.isRegional || rhs.isRegional {
            return !lhs.isRegional
        }

        if lhs.isPhysicallyImpaired && rhs.isPhysicallyImpaired {
            return lhs.category < rhs.category
        }
        if lhs.isPhysicallyImpaired || rhs.isPhysicallyImpaired {
            return !lhs.isPhysicallyImpaired
        }

        if lhs.category == rhs.category {
            return lhs.division < rhs.division
        }

        return lhs.category < rhs.category
    }
}
