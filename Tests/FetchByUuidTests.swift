//
//  FetchByUuidTests.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

@testable import DcaltLib
import XCTest

final class FetchByUuidTests: TestBase {
    let categoryArchiveID = UUID()

    func testArchiveIdCaseDoesNotMatter() throws {
        _ = MCategory.create(testContext, name: "blah", userOrder: 0, lastCalories: 0, archiveID: categoryArchiveID)
        try testContext.save()

        XCTAssertNotNil(try MCategory.get(testContext, archiveID: categoryArchiveID))

        let low = categoryArchiveID.uuidString.lowercased()

        XCTAssertNotNil(try MCategory.get(testContext, archiveID: UUID(uuidString: low)!))

        let up = categoryArchiveID.uuidString.uppercased()

        XCTAssertNotNil(try MCategory.get(testContext, archiveID: UUID(uuidString: up)!))
    }
}
