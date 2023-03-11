//
//  TransferTests.swift
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

final class TransferTests: TestBase {
    let categoryArchiveID = UUID()
    let servingArchiveID = UUID()

//    let dayStartHour: Int = 3
//    let dayStartMinute: Int = 0
    let startOfDay = StartOfDay._0300

    let nowStr = "2023-01-13T21:00:00Z"
    var now: Date!

    let tz: TimeZone = .init(abbreviation: "MST")!

    override func setUpWithError() throws {
        try super.setUpWithError()

        now = df.date(from: nowStr)
    }

    func testCategory() throws {
        _ = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore))

        try transferToArchive(testContext, mainStore: mainStore, archiveStore: archiveStore, startOfDay: startOfDay, now: now, tz: tz)
        try testContext.save()

        XCTAssertNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
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

        try transferToArchive(testContext, mainStore: mainStore, archiveStore: archiveStore, startOfDay: startOfDay, now: now, tz: tz)
        try testContext.save()

        XCTAssertNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: archiveStore))
    }

    func testCategoryWithServingAndServingRun() throws {
        let consumedAt = Date()
        let (consumedDay, consumedTime) = splitDateLocal(consumedAt)!
        let intensity: Int16 = 30
        let sr = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        let se = ZServing.create(testContext, zCategory: sr, servingArchiveID: servingArchiveID, servingName: "bleh", toStore: mainStore)
        let dr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 2392, toStore: mainStore)
        _ = ZServingRun.create(testContext, zDayRun: dr, zServing: se, consumedTime: consumedTime, calories: intensity, toStore: mainStore)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: mainStore))

        try transferToArchive(testContext, mainStore: mainStore, archiveStore: archiveStore, startOfDay: startOfDay, now: now, tz: tz)
        try testContext.save()

        XCTAssertNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))
        XCTAssertNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: mainStore))
        XCTAssertNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: mainStore))

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: archiveStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: archiveStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: archiveStore))
    }

    func testIncludesCopyOfServingRunWhereUserRemoved() throws {
        let consumedDay = "2022-12-20"
        let consumedTime3 = "16:03"
        let consumedTime5 = "16:05"
        let consumedTime7 = "16:07"
        let sr = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        let se = ZServing.create(testContext, zCategory: sr, servingArchiveID: servingArchiveID, servingName: "bleh", toStore: mainStore)
        let dr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 2392, toStore: mainStore)
        _ = ZServingRun.create(testContext, zDayRun: dr, zServing: se, consumedTime: consumedTime3, calories: 3, toStore: mainStore)
        let sr5 = ZServingRun.create(testContext, zDayRun: dr, zServing: se, consumedTime: consumedTime5, calories: 5, toStore: mainStore)
        _ = ZServingRun.create(testContext, zDayRun: dr, zServing: se, consumedTime: consumedTime7, calories: 7, toStore: mainStore)
        sr5.userRemoved = true
        try testContext.save()

        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime3, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime5, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime7, inStore: mainStore))

        try transferToArchive(testContext, mainStore: mainStore, archiveStore: archiveStore, startOfDay: startOfDay, now: now, tz: tz)
        try testContext.save()

        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime3, inStore: archiveStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime5, inStore: archiveStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime7, inStore: archiveStore))
    }

    func testIncludesCopyOfDayRunWhereUserRemoved() throws {
        let consumedDay = "2022-12-20"
        let dr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 2392, toStore: mainStore)
        dr.userRemoved = true
        try testContext.save()

        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: mainStore))

        try transferToArchive(testContext, mainStore: mainStore, archiveStore: archiveStore, startOfDay: startOfDay, now: now, tz: tz)
        try testContext.save()

        guard let ddr = try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: archiveStore)
        else { XCTFail(); return }

        XCTAssertNotNil(ddr)
        XCTAssertTrue(ddr.userRemoved)
    }
}
