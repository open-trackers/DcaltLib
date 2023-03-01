//
//  ZServingTests.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

@testable import DcaltLib
import XCTest

final class ZServingTests: TestBase {
    let categoryArchiveID = UUID()
    let servingArchiveID = UUID()

    func testGetOrCreateUpdatesName() throws {
        let sr = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        _ = ZServing.create(testContext, zCategory: sr, servingArchiveID: servingArchiveID, servingName: "bleh", toStore: mainStore)
        try testContext.save()

        let se2 = try ZServing.getOrCreate(testContext, zCategory: sr, servingArchiveID: servingArchiveID, inStore: mainStore) { _, element in
            element.name = "bleh2"
        }
        try testContext.save()

        XCTAssertEqual("bleh2", se2.name)
        // XCTAssertEqual(Units.pounds.rawValue, se2.units)
    }
}
