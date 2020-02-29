//
//  XCTest+Utilities.swift
//  TriCuriousTests
//
//  Created by Duff Neubauer on 2/28/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import XCTest

extension XCTestCase {
    enum FakeError : Swift.Error {
        case error
    }

    var dummyError: Swift.Error {
        return FakeError.error
    }
}

extension Publisher {
    /// Asserts that the upstream publisher fails with the specified error.
    func assertFailure(_ expectedError: Failure, file: StaticString = #file, line: UInt = #line) {
        let expecation = XCTestExpectation(description: "Publisher to fail.")
        var actualError: Failure?
        _ = sink(receiveCompletion: { completion in
            guard case let .failure(error) = completion else { return }
            actualError = error
            expecation.fulfill()
        }, receiveValue: { _ in })

        XCTWaiter().wait(for: [expecation], timeout: 0)
        XCTAssertEqual(
            expectedError.localizedDescription,
            actualError?.localizedDescription,
            file: file,
            line: line)
    }
}

extension Publisher where Output : Equatable {
    /// Asserts that the upstream publisher finishes with the specified output.
    func assertFinished(_ expectedOuput: Output, file: StaticString = #file, line: UInt = #line) {
        let expecation = XCTestExpectation(description: "Publisher to finish.")
        var actualOutput: Output?
        _ = sink(receiveCompletion: { completion in
            guard case .finished = completion else { return }
            expecation.fulfill()
        }, receiveValue: { actualOutput = $0 })

        XCTWaiter().wait(for: [expecation], timeout: 0)
        XCTAssertEqual(expectedOuput, actualOutput, file: file, line: line)
    }
}
