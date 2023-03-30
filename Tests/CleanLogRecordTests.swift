//
//  CleanLogRecordTests.swift
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

final class CleanLogRecordTests: TestBase {
    let categoryArchiveID = UUID()
    let servingArchiveID = UUID()

    let date1Str = "2023-01-01T21:00:00Z"
    var date1: Date!
    let date2Str = "2023-01-02T21:00:00Z"
    var date2: Date!
    let date3Str = "2023-01-03T21:00:00Z"
    var date3: Date!

    var day1: String!
    var time1: String!

    var day2: String!
    var time2: String!

    var day3: String!
    var time3: String!

    let startOfDay = StartOfDay._0300

    // let tz: TimeZone = .init(abbreviation: "MST")!

    override func setUpWithError() throws {
        try super.setUpWithError()

        date1 = df.date(from: date1Str)
        date2 = df.date(from: date2Str)
        date3 = df.date(from: date3Str)

        (day1, time1) = date1.splitToLocal()!
        (day2, time2) = date2.splitToLocal()!
        (day3, time3) = date3.splitToLocal()!
    }

    func testSimple() throws {
        // we're logging on the second day
        let c = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        let s = ZServing.create(testContext, zCategory: c, servingArchiveID: servingArchiveID, servingName: "bleh", toStore: mainStore)
        let dr = ZDayRun.create(testContext, consumedDay: day2, calories: 100, toStore: mainStore)
        _ = ZServingRun.create(testContext, zDayRun: dr, zServing: s, consumedTime: time2, calories: 50, toStore: mainStore)
        try testContext.save()

        // keep since the first day
        try cleanLogRecords(testContext, keepSinceDay: day1, inStore: mainStore)
        try testContext.save()
        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: day2, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: day2, consumedTime: time2, inStore: mainStore))

        // keep since the second day (the day we logged)
        try cleanLogRecords(testContext, keepSinceDay: day2, inStore: mainStore)
        try testContext.save()
        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: day2, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: day2, consumedTime: time2, inStore: mainStore))

        // discard if keeping since the third day
        try cleanLogRecords(testContext, keepSinceDay: day3, inStore: mainStore)
        try testContext.save()
        XCTAssertNotNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNotNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: mainStore))
        XCTAssertNil(try ZDayRun.get(testContext, consumedDay: day2, inStore: mainStore))
        XCTAssertNil(try ZServingRun.get(testContext, servingArchiveID: servingArchiveID, consumedDay: day2, consumedTime: time2, inStore: mainStore))
    }
}
