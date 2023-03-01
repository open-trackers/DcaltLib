//
//  ZServingDedupeTests.swift
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

final class ZServingDedupeTests: TestBase {
    let catArchiveID1 = UUID()
    let catArchiveID2 = UUID()
    let servArchiveID1 = UUID()
    let servArchiveID2 = UUID()

    let date1Str = "2023-01-02T21:00:01Z"
    var date1: Date!
    let date2Str = "2023-01-02T21:00:02Z"
    var date2: Date!
    let name1 = "blah1"
    let name2 = "blah2"
    let consumedDay = "2023-01-02"

    override func setUpWithError() throws {
        try super.setUpWithError()

        date1 = df.date(from: date1Str)
        date2 = df.date(from: date2Str)
    }

    func testDifferentArchiveID() throws {
        let c1 = ZCategory.create(testContext, categoryArchiveID: catArchiveID1, categoryName: "blah", createdAt: date1, toStore: mainStore)
        let s1 = ZServing.create(testContext, zCategory: c1, servingArchiveID: servArchiveID1, servingName: "bleh1", createdAt: date1, toStore: mainStore)
        let s2 = ZServing.create(testContext, zCategory: c1, servingArchiveID: servArchiveID2, servingName: "bleh2", createdAt: date2, toStore: mainStore)
        try testContext.save() // needed for fetch request to work properly

        try ZServing.dedupe(testContext, categoryArchiveID: catArchiveID1, servingArchiveID: servArchiveID1, inStore: mainStore)

        XCTAssertFalse(c1.isDeleted)
        XCTAssertFalse(s1.isDeleted)
        XCTAssertFalse(s2.isDeleted)
    }

    func testSameArchiveIdWithinCategory() throws {
        let c1 = ZCategory.create(testContext, categoryArchiveID: catArchiveID1, categoryName: "blah", createdAt: date1, toStore: mainStore)
        let s1 = ZServing.create(testContext, zCategory: c1, servingArchiveID: servArchiveID1, servingName: "bleh1", createdAt: date1, toStore: mainStore)
        let s2 = ZServing.create(testContext, zCategory: c1, servingArchiveID: servArchiveID1, servingName: "bleh2", createdAt: date2, toStore: mainStore)
        try testContext.save() // needed for fetch request to work properly

        try ZServing.dedupe(testContext, categoryArchiveID: catArchiveID1, servingArchiveID: servArchiveID1, inStore: mainStore)

        XCTAssertFalse(c1.isDeleted)
        XCTAssertFalse(s1.isDeleted)
        XCTAssertTrue(s2.isDeleted)
    }

    func testSameArchiveIdOutsideCategory() throws {
        let c1 = ZCategory.create(testContext, categoryArchiveID: catArchiveID1, categoryName: "blah1", createdAt: date1, toStore: mainStore)
        let c2 = ZCategory.create(testContext, categoryArchiveID: catArchiveID2, categoryName: "blah2", createdAt: date2, toStore: mainStore)
        let s1 = ZServing.create(testContext, zCategory: c1, servingArchiveID: servArchiveID1, servingName: "bleh1", createdAt: date1, toStore: mainStore)
        let s2 = ZServing.create(testContext, zCategory: c2, servingArchiveID: servArchiveID1, servingName: "bleh2", createdAt: date2, toStore: mainStore)
        try testContext.save() // needed for fetch request to work properly

        try ZServing.dedupe(testContext, categoryArchiveID: catArchiveID1, servingArchiveID: servArchiveID1, inStore: mainStore)

        XCTAssertFalse(c1.isDeleted)
        XCTAssertFalse(c2.isDeleted)
        XCTAssertFalse(s1.isDeleted)
        XCTAssertFalse(s2.isDeleted)
    }

    func testDupeConsolidateServingRuns() throws {
        let c1 = ZCategory.create(testContext, categoryArchiveID: catArchiveID1, categoryName: name1, createdAt: date1, toStore: mainStore)

        // same servingArchiveID
        let s1 = ZServing.create(testContext, zCategory: c1, servingArchiveID: servArchiveID1, servingName: name1, createdAt: date1, toStore: mainStore)
        let s2 = ZServing.create(testContext, zCategory: c1, servingArchiveID: servArchiveID1, servingName: name1, createdAt: date2, toStore: mainStore)

        // note: does not dedupe serving runs; it only consolidates them
        let dr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 1000, toStore: mainStore)
        let r1 = ZServingRun.create(testContext, zDayRun: dr, zServing: s1, consumedTime: "01:00", calories: 10, toStore: mainStore)
        let r2 = ZServingRun.create(testContext, zDayRun: dr, zServing: s1, consumedTime: "01:01", calories: 11, toStore: mainStore)
        try testContext.save() // needed for fetch request to work properly

        try ZServing.dedupe(testContext, categoryArchiveID: catArchiveID1, servingArchiveID: servArchiveID1, inStore: mainStore)

        XCTAssertFalse(s1.isDeleted)
        XCTAssertTrue(s2.isDeleted)
        XCTAssertFalse(r1.isDeleted)
        XCTAssertFalse(r2.isDeleted)

        XCTAssertEqual(2, s1.zServingRuns?.count) // consolidated
        XCTAssertEqual(0, s2.zServingRuns?.count)
    }
}
