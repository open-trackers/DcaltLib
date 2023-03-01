//
//  ZDayRunDedupeTests.swift
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

final class ZDayRunDedupeTests: TestBase {
    let catArchiveID1 = UUID()
    let catArchiveID2 = UUID()
    let servArchiveID1 = UUID()
    let servArchiveID2 = UUID()

    let date1Str = "2023-01-02T21:00:00Z"
    var date1: Date!
    let date2Str = "2023-01-03T21:00:00Z"
    var date2: Date!
    let name1 = "blah1"
    let name2 = "blah2"
    let consumedDay1 = "2023-01-02"
    let consumedDay2 = "2023-01-03"

    override func setUpWithError() throws {
        try super.setUpWithError()

        date1 = df.date(from: date1Str)
        date2 = df.date(from: date2Str)
    }

    func testDifferentConsumedDay() throws {
        let dr1 = ZDayRun.create(testContext, consumedDay: consumedDay1, calories: 10, createdAt: date1, toStore: mainStore)
        let dr2 = ZDayRun.create(testContext, consumedDay: consumedDay2, calories: 10, createdAt: date2, toStore: mainStore)
        try testContext.save() // needed for fetch request to work properly

        try ZDayRun.dedupe(testContext, consumedDay: consumedDay1, inStore: mainStore)

        XCTAssertFalse(dr1.isDeleted)
        XCTAssertFalse(dr2.isDeleted)
    }

    func testSameConsumedDay() throws {
        let dr1 = ZDayRun.create(testContext, consumedDay: consumedDay1, calories: 10, createdAt: date1, toStore: mainStore)
        let dr2 = ZDayRun.create(testContext, consumedDay: consumedDay1, calories: 10, createdAt: date2, toStore: mainStore)
        try testContext.save() // needed for fetch request to work properly

        try ZDayRun.dedupe(testContext, consumedDay: consumedDay1, inStore: mainStore)

        XCTAssertFalse(dr1.isDeleted)
        XCTAssertTrue(dr2.isDeleted)
    }

    func testDupeConsolidateServingRuns() throws {
        // same consumedDay
        let dr1 = ZDayRun.create(testContext, consumedDay: consumedDay1, calories: 10, createdAt: date1, toStore: mainStore)
        let dr2 = ZDayRun.create(testContext, consumedDay: consumedDay1, calories: 10, createdAt: date2, toStore: mainStore)

        let c1 = ZCategory.create(testContext, categoryArchiveID: catArchiveID1, categoryName: name1, createdAt: date1, toStore: mainStore)
        let s1 = ZServing.create(testContext, zCategory: c1, servingArchiveID: servArchiveID1, servingName: name1, createdAt: date1, toStore: mainStore)
        let s2 = ZServing.create(testContext, zCategory: c1, servingArchiveID: servArchiveID2, servingName: name1, createdAt: date2, toStore: mainStore)

        // note: does not dedupe serving runs; it only consolidates them
        let r1 = ZServingRun.create(testContext, zDayRun: dr1, zServing: s1, consumedTime: "01:00", calories: 10, toStore: mainStore)
        let r2 = ZServingRun.create(testContext, zDayRun: dr2, zServing: s2, consumedTime: "01:01", calories: 11, toStore: mainStore)
        try testContext.save() // needed for fetch request to work properly

        try ZDayRun.dedupe(testContext, consumedDay: consumedDay1, inStore: mainStore)

        XCTAssertFalse(dr1.isDeleted)
        XCTAssertTrue(dr2.isDeleted)
        XCTAssertFalse(s1.isDeleted)
        XCTAssertFalse(s2.isDeleted)
        XCTAssertFalse(r1.isDeleted)
        XCTAssertFalse(r2.isDeleted)

        XCTAssertEqual(1, s1.zServingRuns?.count) // not touched
        XCTAssertEqual(1, s2.zServingRuns?.count)

        XCTAssertEqual(2, dr1.zServingRuns?.count) // consolidated
        XCTAssertEqual(0, dr2.zServingRuns?.count)
    }
}
