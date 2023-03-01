//
//  DeepCopyTests.swift
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

final class DeepCopyTests: TestBase {
    let categoryArchiveID = UUID()
    let servingArchiveID = UUID()

    func testCategory() throws {
        let sr = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore))

        let result = try deepCopy(testContext, fromStore: mainStore, toStore: archiveStore)
        try testContext.save()

        XCTAssertEqual([sr], result.0)
        XCTAssertEqual([], result.1)

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore))
    }

    func testCategoryWithServing() throws {
        let sr = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        _ = ZServing.create(testContext, zCategory: sr, servingArchiveID: servingArchiveID, servingName: "bleh", toStore: mainStore)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))

        XCTAssertNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore))
        XCTAssertNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: archiveStore))

        let result = try deepCopy(testContext, fromStore: mainStore, toStore: archiveStore)
        try testContext.save()

        XCTAssertEqual([sr], result.0)
        XCTAssertEqual([], result.1)

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: archiveStore))
    }

    func testCategoryWithServingAndServingRun() throws {
        let consumedAt = Date()
        let (consumedDay, consumedTime) = splitDate(consumedAt)!
        let calories: Int16 = 30
        let sr = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        let se = ZServing.create(testContext, zCategory: sr, servingArchiveID: servingArchiveID, servingName: "bleh", toStore: mainStore)
        let dr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 2392, toStore: mainStore)
        _ = ZServingRun.create(testContext, zDayRun: dr, zServing: se, consumedTime: consumedTime, calories: calories, toStore: mainStore)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: mainStore))

        let result = try deepCopy(testContext, fromStore: mainStore, toStore: archiveStore)
        try testContext.save()

        XCTAssertEqual([sr], result.0)
        XCTAssertEqual([dr], result.1)

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: mainStore))

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: archiveStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: archiveStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: archiveStore))
    }
}
