//
//  Athlete.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/19/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Foundation

struct Athlete {
    let id: UInt
    var firstName: String
    var lastName: String
    var headshotLocation: URL?
    var headshotData: Data?
    var country: String
    var countryFlagLocation: URL
    var countryFlagData: Data?
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

extension Athlete : Equatable {}
extension Athlete.Stats : Equatable {}
