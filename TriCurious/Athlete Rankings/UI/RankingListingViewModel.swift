//
//  RankingListingViewModel.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/1/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Foundation

protocol RankingListingViewModel {
    var numberOfRankingCategories: Int { get }
    func titleForRankingCategory(at index: Int) -> String
    func nameOfAthlete(rankIndex: Int, categoryIndex: Int) -> String
}

protocol AthleteViewModel {
    var fullName: String { get }
}

extension Array : RankingListingViewModel where Element == RankingListing{
    var numberOfRankingCategories: Int { count }

    func titleForRankingCategory(at index: Int) -> String {
        guard index < count else { return "" }
        return self[index].category
    }

    func nameOfAthlete(rankIndex: Int, categoryIndex: Int) -> String {
        guard categoryIndex < count, rankIndex <  self[categoryIndex].rankings.count else {
            return ""
        }

        return self[categoryIndex].rankings[rankIndex].fullName
    }
}

extension Athlete : AthleteViewModel {
    var fullName: String { "\(firstName) \(lastName)" }
}
