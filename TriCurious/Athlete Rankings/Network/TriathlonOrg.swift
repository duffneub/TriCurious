//
//  TriathlonOrg.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/1/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import Foundation

struct TriathlonOrg {
    let session = URLSession(configuration: .default)

    fileprivate func rankingsListings() -> AnyPublisher<[RankingsListing], Error> {
        fetch(path: "rankings")
    }

    fileprivate func ranking(listing: RankingsListing) -> AnyPublisher<Ranking, Error> {
        fetch(path: "rankings/\(listing.id)")
    }

    private func fetch<T : Decodable>(path: String, type: T.Type = T.self) -> AnyPublisher<T, Error> {
        let base = URL(string: "https://api.triathlon.org/v1/")!
        var request = URLRequest(url: base.appendingPathComponent(path))
        request.setValue("f86dd230f8dc41468044074f6c2eed73", forHTTPHeaderField: "apikey")

        return session
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Response<T>.self, decoder: JSONDecoder())
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

extension TriathlonOrg : AthleteRankingsStore {
    // TODO: Test
    // TODO: Support Team and Athlete rankings (and remove the "Mixed Replay" filter)
    func currentRankings() -> AnyPublisher<[Ranking], Error> {
        rankingsListings()
            .flatMap {
                $0.filter { $0.program != "Mixed Relay" }.map(self.ranking(listing:))
                    .publisher
                    .setFailureType(to: Error.self)
                    .flatMap { $0 } // Combine list publishers into single publisher
                    .collect()
                    .eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }

    func headshot(for athlete: Athlete) -> AnyPublisher<Data, Error> {
        guard let url = athlete.headshot else {
            return Empty<Data, Error>().eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func countryFlag(for athlete: Athlete) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: athlete.countryFlag)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

// MARK: - Network Models

extension TriathlonOrg {
    struct Response<T> {
        var data: T
    }
}

extension TriathlonOrg.Response : Decodable where T : Decodable {}

struct RankingsListing : Decodable {
    let id: Int
    let program: String

    enum CodingKeys : String, CodingKey {
        case id = "ranking_id"
        case program = "ranking_name"
    }
}

// MARK: - Core Models + Decodable

extension Ranking : Decodable {
    enum CodingKeys : String, CodingKey {
        case category = "ranking_cat_name"
        case division = "ranking_name"
        case rankings
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let category = try container.decode(String.self, forKey: .category)
        let division = try container.decode(String.self, forKey: .division)
        let rankings = try container.decode([Athlete].self, forKey: .rankings)

        self.init(category: category, division: division, rankings: rankings)
    }
}

extension Athlete : Decodable {
    enum CodingKeys : String, CodingKey {
        case firstName = "athlete_first"
        case lastName = "athlete_last"
        case headshot = "athlete_profile_image"
        case country = "athlete_country_name"
        case countryFlag = "athlete_flag"
        case currentRank = "rank"
        case currentPointsTotal = "total"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        let headshotRaw = try container.decode(String?.self, forKey: .headshot)
        let headshot = headshotRaw.map { URL(string: $0) } ?? nil
        let country = try container.decode(String.self, forKey: .country)
        let countryFlag = try container.decode(URL.self, forKey: .countryFlag)
        let currentRank = try container.decode(UInt.self, forKey: .currentRank)
        let currentPointsTotal = try container.decode(Double.self, forKey: .currentPointsTotal)

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
