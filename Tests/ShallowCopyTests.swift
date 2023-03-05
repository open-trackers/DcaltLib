//
//  ShallowCopyTests.swift
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

final class ShallowCopyTests: TestBase {
    let categoryArchiveID = UUID()
    let servingArchiveID = UUID()

    let createdAt1Str = "2023-01-01T05:00:00Z"
    var createdAt1: Date!
    let createdAt2Str = "2023-01-02T05:00:00Z"
    var createdAt2: Date!
    let createdAt3Str = "2023-01-03T05:00:00Z"
    var createdAt3: Date!
    let createdAt4Str = "2023-01-04T05:00:00Z"
    var createdAt4: Date!

    override func setUpWithError() throws {
        try super.setUpWithError()

        createdAt1 = df.date(from: createdAt1Str)
        createdAt2 = df.date(from: createdAt2Str)
        createdAt3 = df.date(from: createdAt3Str)
        createdAt4 = df.date(from: createdAt4Str)
    }

    func testReadOnly() throws {
        XCTAssertFalse(mainStore.isReadOnly)
        XCTAssertFalse(archiveStore.isReadOnly)
    }

    func testCategory() throws {
        let sr = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", createdAt: createdAt1, toStore: mainStore)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore))

        _ = try sr.shallowCopy(testContext, toStore: archiveStore)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        let dr: ZCategory? = try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore)
        XCTAssertNotNil(dr)
        XCTAssertEqual(createdAt1, dr?.createdAt)
    }

    func testCategoryWithServing() throws {
        let sr = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", createdAt: createdAt1, toStore: mainStore)
        let se = ZServing.create(testContext, zCategory: sr, servingArchiveID: servingArchiveID, servingName: "bleh", createdAt: createdAt2, toStore: mainStore)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))

        XCTAssertNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore))
        XCTAssertNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: archiveStore))

        // category needs to get to archive first
        _ = try sr.shallowCopy(testContext, toStore: archiveStore)
        try testContext.save()
        guard let dr = try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore)
        else { XCTFail(); return }

        // now the serving copy
        _ = try se.shallowCopy(testContext, dstCategory: dr, toStore: archiveStore)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))

        let dc: ZCategory? = try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore)
        XCTAssertNotNil(dc)
        XCTAssertEqual(createdAt1, dc?.createdAt)
        let ds: ZServing? = try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: archiveStore)
        XCTAssertNotNil(ds)
        XCTAssertEqual(createdAt2, ds?.createdAt)
    }

    func testCategoryWithServingAndServingRun() throws {
        let consumedAt = Date()
        let (consumedDay, consumedTime) = splitDate(consumedAt)!
        let calories: Int16 = 30
        let sc = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", createdAt: createdAt1, toStore: mainStore)
        let ss = ZServing.create(testContext, zCategory: sc, servingArchiveID: servingArchiveID, servingName: "bleh", createdAt: createdAt2, toStore: mainStore)
        let sdr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 2392, createdAt: createdAt3, toStore: mainStore)
        let ssr = ZServingRun.create(testContext, zDayRun: sdr, zServing: ss, consumedTime: consumedTime, calories: calories, createdAt: createdAt4, toStore: mainStore)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: mainStore))

        // category needs to get to archive first
        _ = try sc.shallowCopy(testContext, toStore: archiveStore)
        try testContext.save()
        guard let dr = try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore)
        else { XCTFail(); return }

        // and serving too
        _ = try ss.shallowCopy(testContext, dstCategory: dr, toStore: archiveStore)
        try testContext.save()
        guard let de = try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: archiveStore)
        else { XCTFail(); return }

        // and day too
        _ = try sdr.shallowCopy(testContext, toStore: archiveStore)
        try testContext.save()
        guard let ddr = try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: archiveStore)
        else { XCTFail(); return }

        // and finally copy the serving run
        _ = try ssr.shallowCopy(testContext, dstDayRun: ddr, dstServing: de, toStore: archiveStore)
        try testContext.save()

        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: mainStore))

        let dc: ZCategory? = try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore)
        XCTAssertNotNil(dc)
        XCTAssertEqual(createdAt1, dc?.createdAt)
        let ds: ZServing? = try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: archiveStore)
        XCTAssertNotNil(ds)
        XCTAssertEqual(createdAt2, ds?.createdAt)
        let ddr2: ZDayRun? = try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: archiveStore)
        XCTAssertNotNil(ddr2)
        XCTAssertEqual(createdAt3, ddr2?.createdAt)
        let dsr: ZServingRun? = try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: archiveStore)
        XCTAssertNotNil(dsr)
        XCTAssertEqual(createdAt4, dsr?.createdAt)
    }

    func testServingRunIncludesUserRemoved() throws {
        let consumedAt = Date()
        let (consumedDay, consumedTime) = splitDate(consumedAt)!
        let calories: Int16 = 30
        let sc = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", createdAt: createdAt1, toStore: mainStore)
        let ss = ZServing.create(testContext, zCategory: sc, servingArchiveID: servingArchiveID, servingName: "bleh", createdAt: createdAt2, toStore: mainStore)
        let sdr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 2392, createdAt: createdAt3, toStore: mainStore)
        let ssr = ZServingRun.create(testContext, zDayRun: sdr, zServing: ss, consumedTime: consumedTime, calories: calories, createdAt: createdAt4, toStore: mainStore)
        ssr.userRemoved = true
        try testContext.save()

        _ = try sc.shallowCopy(testContext, toStore: archiveStore)
        try testContext.save()
        guard let dr = try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore)
        else { XCTFail(); return }

        _ = try sdr.shallowCopy(testContext, toStore: archiveStore)
        try testContext.save()
        guard let ddr = try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: archiveStore)
        else { XCTFail(); return }

        _ = try ss.shallowCopy(testContext, dstCategory: dr, toStore: archiveStore)
        try testContext.save()
        guard let de = try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: archiveStore)
        else { XCTFail(); return }

        _ = try ssr.shallowCopy(testContext, dstDayRun: ddr, dstServing: de, toStore: archiveStore)
        try testContext.save()

        let dsr: ZServingRun? = try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime, inStore: archiveStore)
        XCTAssertNotNil(dsr)
        XCTAssertTrue(dsr!.userRemoved)
    }

    func testDayRunIncludesUserRemoved() throws {
        let consumedAt = Date()
        let (consumedDay, _) = splitDate(consumedAt)!
        let sdr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 2392, createdAt: createdAt3, toStore: mainStore)
        sdr.userRemoved = true
        try testContext.save()

        _ = try sdr.shallowCopy(testContext, toStore: archiveStore)
        try testContext.save()
        guard let ddr = try ZDayRun.get(testContext, consumedDay: consumedDay, inStore: archiveStore)
        else { XCTFail(); return }

        XCTAssertNotNil(ddr)
        XCTAssertTrue(ddr.userRemoved)
    }
}
