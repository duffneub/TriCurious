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

struct Ranking {
    var rank: UInt
    var pointsTotal: Double
    var athlete: Athlete
}

struct Athlete {
    let id: UInt
    var firstName: String
    var lastName: String
    var headshot: URL?
    var country: String
    var countryFlag: URL
    var biography: String?
    var stats: Stats?
}

extension Athlete {
    struct Stats {
        var starts: UInt
        var finishes: UInt
        var podiums: UInt
        var wins: UInt
    }
}

extension RankingListing : Equatable {}
extension Ranking : Equatable {}
extension Athlete : Equatable {}
extension Athlete.Stats : Equatable {}

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
