//
//  ZServingRunDedupeTests.swift
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

final class ZServingRunDedupeTests: TestBase {
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
    let consumedTime1 = "01:00"
    let consumedTime2 = "01:01"

    override func setUpWithError() throws {
        try super.setUpWithError()

        date1 = df.date(from: date1Str)
        date2 = df.date(from: date2Str)
    }

    func testDifferentConsumedTime() throws {
        let c1 = ZCategory.create(testContext, categoryArchiveID: catArchiveID1, categoryName: name1, createdAt: date1, toStore: mainStore)
        let s1 = ZServing.create(testContext, zCategory: c1, servingArchiveID: servArchiveID1, servingName: name1, createdAt: date1, toStore: mainStore)
        let dr1 = ZDayRun.create(testContext, consumedDay: consumedDay1, calories: 10, createdAt: date1, toStore: mainStore)

        let r1 = ZServingRun.create(testContext, zDayRun: dr1, zServing: s1, consumedTime: consumedTime1, calories: 10, createdAt: date1, toStore: mainStore)
        let r2 = ZServingRun.create(testContext, zDayRun: dr1, zServing: s1, consumedTime: consumedTime2, calories: 10, createdAt: date2, toStore: mainStore)
        try testContext.save() // needed for fetch request to work properly

        try ZServingRun.dedupe(testContext,
                               servingArchiveID: servArchiveID1,
                               consumedDay: consumedDay1,
                               consumedTime: consumedTime1,
                               inStore: mainStore)

        XCTAssertFalse(r1.isDeleted)
        XCTAssertFalse(r2.isDeleted)
    }

    func testSameConsumedTime() throws {
        let c1 = ZCategory.create(testContext, categoryArchiveID: catArchiveID1, categoryName: name1, createdAt: date1, toStore: mainStore)
        let s1 = ZServing.create(testContext, zCategory: c1, servingArchiveID: servArchiveID1, servingName: name1, createdAt: date1, toStore: mainStore)
        let dr1 = ZDayRun.create(testContext, consumedDay: consumedDay1, calories: 10, createdAt: date1, toStore: mainStore)

        let r1 = ZServingRun.create(testContext, zDayRun: dr1, zServing: s1, consumedTime: consumedTime1, calories: 10, createdAt: date1, toStore: mainStore)
        let r2 = ZServingRun.create(testContext, zDayRun: dr1, zServing: s1, consumedTime: consumedTime1, calories: 10, createdAt: date2, toStore: mainStore)
        try testContext.save() // needed for fetch request to work properly

        try ZServingRun.dedupe(testContext,
                               servingArchiveID: servArchiveID1,
                               consumedDay: consumedDay1,
                               consumedTime: consumedTime1,
                               inStore: mainStore)

        XCTAssertFalse(r1.isDeleted)
        XCTAssertTrue(r2.isDeleted)
    }
}
