//
//  TriathlonOrg.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/1/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import Foundation

class TriathlonOrg {
    let session = URLSession(configuration: .default)
    var c: AnyCancellable?

    fileprivate func rankingsListings() -> AnyPublisher<[RankingListing], Error> {
        fetch(path: "rankings")
    }

    fileprivate func ranking(listing: RankingListing) -> AnyPublisher<RankingListing, Error> {
        fetch(path: "rankings/\(listing.id)")
    }

    fileprivate func athletes(id: UInt) -> AnyPublisher<Athlete, Error> {
        fetch(path: "athletes/\(id)")
    }

    private func fetch<T : Decodable>(path: String, type: T.Type = T.self) -> AnyPublisher<T, Error> {
        let base = URL(string: "https://api.triathlon.org/v1/")!
        var request = URLRequest(url: base.appendingPathComponent(path))
        request.setValue("f86dd230f8dc41468044074f6c2eed73", forHTTPHeaderField: "apikey")

        return session
            .dataTaskPublisher(for: request)
            .map { print(String(data: $0.data, encoding: .utf8)!) ; return $0.data }
            .decode(type: Response<T>.self, decoder: JSONDecoder())
            .mapError { print("Error: \($0)") ; return $0 }
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

extension TriathlonOrg : RankingsListStore, RankingsStore {
    // TODO: Test
    // TODO: Support Team and Athlete rankings (and remove the "Mixed Replay" filter)
    func currentRankings() -> AnyPublisher<[RankingListing], Error> {
        rankingsListings()
            .flatMap {
                $0.filter { $0.division != "Mixed Relay" }.map(self.ranking(listing:))
                    .publisher
                    .setFailureType(to: Error.self)
                    .flatMap { $0 } // Combine list publishers into single publisher
                    .collect()
                    .eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }

    func loadCurrentRankings() -> AnyPublisher<[RankingListing], Error> {
        rankingsListings()
            .flatMap {
                $0.filter { $0.division != "Mixed Relay" }.map(self.ranking(listing:))
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

    func details(for athlete: Athlete) -> AnyPublisher<Athlete, Error> {
        athletes(id: athlete.id)
    }
}

// MARK: - Network Models

extension TriathlonOrg {
    struct Response<T> {
        var data: T
    }
}

extension TriathlonOrg.Response : Decodable where T : Decodable {}

// MARK: - Core Models + Decodable

extension RankingListing : Decodable {
    enum CodingKeys : String, CodingKey {
        case id = "ranking_id"
        case category = "ranking_cat_name"
        case division = "ranking_name"
        case rankings
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UInt.self, forKey: .id)
        self.category = try container.decode(String.self, forKey: .category)
        self.division = try container.decode(String.self, forKey: .division)

        var rankings: [Ranking] = []
        if container.contains(.rankings) {
            rankings = try container.decode([Ranking].self, forKey: .rankings)
        }
        self.rankings = rankings
    }
}

extension Ranking : Decodable {
    enum CodingKeys : String, CodingKey {
        case rank
        case pointsTotal = "total"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.rank = try container.decode(UInt.self, forKey: .rank)
        self.pointsTotal = try container.decode(Double.self, forKey: .pointsTotal)
        self.athlete = try Athlete(from: decoder)
    }
}

extension Athlete : Decodable {
    enum CodingKeys : String, CodingKey {
        case id = "athlete_id"
        case firstName = "athlete_first"
        case lastName = "athlete_last"
        case headshot = "athlete_profile_image"
        case country = "athlete_country_name"
        case countryFlag = "athlete_flag"
        case biography = "biography"
        case stats = "stats"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UInt.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.country = try container.decode(String.self, forKey: .country)
        self.countryFlag = try container.decode(URL.self, forKey: .countryFlag)

        let headshotRaw = try container.decode(String?.self, forKey: .headshot)
        self.headshot = headshotRaw.map { URL(string: $0) } ?? nil

        var biography: String?
        if container.contains(.biography) {
            biography = try container.decode(String?.self, forKey: .biography)
        }
        self.biography = biography

        var stats: Stats?
        if container.contains(.stats) {
            stats = try container.decode(Stats.self, forKey: .stats)
        }
        self.stats = stats
    }
}

extension Athlete.Stats : Decodable {
    enum CodingKeys : String, CodingKey {
        case starts = "race_starts"
        case finishes = "race_finishes"
        case podiums = "race_podiums"
        case wins = "race_wins"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.starts = try container.decode(UInt.self, forKey: .starts)
        self.finishes = try container.decode(UInt.self, forKey: .finishes)
        self.podiums = try container.decode(UInt.self, forKey: .podiums)
        self.wins = try container.decode(UInt.self, forKey: .wins)
    }
}
