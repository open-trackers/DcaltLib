//
//  DeleteLogRecordTests.swift
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

final class DeleteLogRecordTests: TestBase {
    let categoryArchiveID = UUID()
    let servingArchiveID = UUID()

    func testZServingRunFromBothStores() throws {
        let startedAt = Date.now
        let consumedAt = startedAt + 1000
        let (consumedDay, consumedTime) = consumedAt.splitToLocal()!
        let r = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        let e = ZServing.create(testContext, zCategory: r, servingArchiveID: servingArchiveID, servingName: "bleh", toStore: mainStore)
        let dr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 2392, toStore: mainStore)
        _ = ZServingRun.create(testContext, zDayRun: dr, zServing: e, consumedTime: consumedTime, calories: 1, toStore: mainStore)
        // try testContext.save()
        _ = try deepCopy(testContext, fromStore: mainStore, toStore: archiveStore)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: archiveStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: archiveStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: archiveStore))

        try ZServingRun.userRemove(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: nil)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: archiveStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: archiveStore))
        let a = try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: mainStore)
        XCTAssertTrue(a!.userRemoved)
        let b = try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: archiveStore)
        XCTAssertTrue(b!.userRemoved)
    }
}
