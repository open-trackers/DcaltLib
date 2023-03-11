//
//  LogCaloriesTests.swift
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

final class LogCaloriesTests: TestBase {
    let categoryArchiveID = UUID()
    let serving1ArchiveID = UUID()
    let serving2ArchiveID = UUID()

    let day1Str = "2023-01-13T21:00:00Z"
    var day1: Date!
    let day2Str = "2023-01-14T21:10:00Z"
    var day2: Date!
    let day3Str = "2023-01-15T21:00:00Z"
    var day3: Date!

    var consumedDay1: String!
    var consumedTime1: String!

    var consumedDay2: String!
    var consumedTime2: String!

    let calories1Str = "105"
    var calories1: Int16!
    let calories2Str = "55"
    var calories2: Int16!
    let caloriesStepStr = "3.3"
    var caloriesStep: Float!
    let userOrder1Str = "18"
    var userOrder1: Int16!
    let userOrder2Str = "20"
    var userOrder2: Int16!

//    let dayStartHour = 3
//    let dayStartMinute = 0
    let startOfDay = StartOfDay._0300

    let tz: TimeZone = .init(abbreviation: "MST")!

    override func setUpWithError() throws {
        try super.setUpWithError()

        day1 = df.date(from: day1Str)
        day2 = df.date(from: day2Str)
        day3 = df.date(from: day3Str)
        calories1 = Int16(calories1Str)
        calories2 = Int16(calories2Str)
        caloriesStep = Float(caloriesStepStr)
        userOrder1 = Int16(userOrder1Str)
        userOrder2 = Int16(userOrder2Str)

        (consumedDay1, consumedTime1) = splitDateLocal(day1)!
        (consumedDay2, consumedTime2) = splitDateLocal(day2)!
    }

    func testSimple() throws {
        let r = MCategory.create(testContext, name: "bleh", userOrder: 1, archiveID: categoryArchiveID)
        let s = MServing.create(testContext, category: r, userOrder: userOrder1, name: "bleep", archiveID: serving1ArchiveID)
        try testContext.save()

        XCTAssertNil(try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore))
        XCTAssertNil(try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: serving1ArchiveID, inStore: mainStore))
        XCTAssertNil(try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: mainStore))
        XCTAssertNil(try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: mainStore))

        try MServing.logCalories(testContext, category: r, mainStore: mainStore, servingArchiveID: s.archiveID!, servingName: s.wrappedName, netCalories: calories1, startOfDay: startOfDay, now: day1)
        try testContext.save()

        let zr = try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: mainStore)
        XCTAssertNotNil(zr)
        XCTAssertEqual(r.name, zr?.name)

        let ze = try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: serving1ArchiveID, inStore: mainStore)
        XCTAssertNotNil(ze)
        XCTAssertEqual(s.name, ze?.name)

        let zdr = try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: mainStore)
        XCTAssertNotNil(zdr)

        let zer = try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: mainStore)
        XCTAssertNotNil(zer)
        XCTAssertEqual(consumedTime1, zer?.consumedTime)
        XCTAssertEqual(calories1, zer?.calories)
    }

    func testEnsureFreshDayRunPreservedInMain() throws {
        let r = MCategory.create(testContext, name: "bleh", userOrder: 1, archiveID: categoryArchiveID)
        let e1 = MServing.create(testContext, category: r, userOrder: userOrder1, name: "bleep", archiveID: serving1ArchiveID)

        _ = MServing.create(testContext, category: r, userOrder: userOrder2, name: "blort", archiveID: serving2ArchiveID)
        try testContext.save()

        try MServing.logCalories(testContext, category: r, mainStore: mainStore, servingArchiveID: e1.archiveID!, servingName: e1.wrappedName, netCalories: calories1, startOfDay: startOfDay, now: day1)
        try testContext.save()

        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: mainStore))
        XCTAssertNil(try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: archiveStore))

        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: mainStore))
        XCTAssertNil(try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: archiveStore))

        // first with same day (day1)
        try transferToArchive(testContext, mainStore: mainStore, archiveStore: archiveStore, startOfDay: startOfDay, now: day1, tz: tz)
        try testContext.save()

        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: archiveStore))

        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: archiveStore))

        // and now one day later (day2) - main should be cleared
        try transferToArchive(testContext, mainStore: mainStore, archiveStore: archiveStore, startOfDay: startOfDay, now: day2, tz: tz)
        try testContext.save()

        XCTAssertNil(try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: archiveStore))

        XCTAssertNil(try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: archiveStore))
    }

    func testServingRunAfterTransfer() throws {
        let r = MCategory.create(testContext, name: "bleh", userOrder: 1, archiveID: categoryArchiveID)
        let e1 = MServing.create(testContext, category: r, userOrder: userOrder1, name: "bleep", archiveID: serving1ArchiveID)

        let e2 = MServing.create(testContext, category: r, userOrder: userOrder2, name: "blort", archiveID: serving2ArchiveID)
        try testContext.save()

        try MServing.logCalories(testContext, category: r, mainStore: mainStore, servingArchiveID: e1.archiveID!, servingName: e1.wrappedName, netCalories: calories1, startOfDay: startOfDay, now: day1)
        try testContext.save()

        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: mainStore))
        XCTAssertNil(try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: archiveStore))

        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: mainStore))
        XCTAssertNil(try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: archiveStore))

        try transferToArchive(testContext, mainStore: mainStore, archiveStore: archiveStore, startOfDay: startOfDay, now: day3, tz: tz)
        try testContext.save()

        XCTAssertNil(try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: archiveStore))

        XCTAssertNil(try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: archiveStore))

        try MServing.logCalories(testContext, category: r, mainStore: mainStore, servingArchiveID: e2.archiveID!, servingName: e2.wrappedName, netCalories: calories2, startOfDay: startOfDay, now: day2)
        try testContext.save()

        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay2, inStore: mainStore))
        XCTAssertNil(try ZDayRun.get(testContext, consumedDay: consumedDay2, inStore: archiveStore))

        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: serving2ArchiveID, consumedDay: consumedDay2, consumedTime: consumedTime2, inStore: mainStore))
        XCTAssertNil(try ZServingRun.get(testContext, servingArchiveID: serving2ArchiveID, consumedDay: consumedDay2, consumedTime: consumedTime2, inStore: archiveStore))

        try transferToArchive(testContext, mainStore: mainStore, archiveStore: archiveStore, startOfDay: startOfDay, now: day3, tz: tz)
        try testContext.save()

        XCTAssertNil(try ZDayRun.get(testContext, consumedDay: consumedDay2, inStore: mainStore))
        XCTAssertNotNil(try ZDayRun.get(testContext, consumedDay: consumedDay2, inStore: archiveStore))

        XCTAssertNil(try ZServingRun.get(testContext, servingArchiveID: serving2ArchiveID, consumedDay: consumedDay2, consumedTime: consumedTime2, inStore: mainStore))
        XCTAssertNotNil(try ZServingRun.get(testContext, servingArchiveID: serving2ArchiveID, consumedDay: consumedDay2, consumedTime: consumedTime2, inStore: archiveStore))

        let zr = try ZCategory.get(testContext, categoryArchiveID: categoryArchiveID, inStore: archiveStore)
        XCTAssertNotNil(zr)
        XCTAssertEqual(r.name, zr?.name)

        let ze1 = try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: serving1ArchiveID, inStore: archiveStore)
        XCTAssertNotNil(ze1)
        XCTAssertEqual(e1.name, ze1?.name)
        let zer1 = try ZServingRun.get(testContext, servingArchiveID: serving1ArchiveID, consumedDay: consumedDay1, consumedTime: consumedTime1, inStore: archiveStore)
        XCTAssertNotNil(zer1)
        XCTAssertEqual(consumedDay1, zer1?.zDayRun?.consumedDay)
        XCTAssertEqual(consumedTime1, zer1?.consumedTime)
        XCTAssertEqual(calories1, zer1?.calories)

        let ze2 = try ZServing.get(testContext, categoryArchiveID: categoryArchiveID, servingArchiveID: serving2ArchiveID, inStore: archiveStore)
        XCTAssertNotNil(ze2)
        XCTAssertEqual(e2.name, ze2?.name)
        let zer2 = try ZServingRun.get(testContext, servingArchiveID: serving2ArchiveID, consumedDay: consumedDay2, consumedTime: consumedTime2, inStore: archiveStore)
        XCTAssertNotNil(zer2)
        XCTAssertEqual(consumedDay2, zer2?.zDayRun?.consumedDay)
        XCTAssertEqual(consumedTime2, zer2?.consumedTime)
        XCTAssertEqual(calories2, zer2?.calories)
    }

    func testRestoreDayRunAfterUserLogsServing() throws {
        let r = MCategory.create(testContext, name: "bleh", userOrder: 77, archiveID: categoryArchiveID)
        let e1 = MServing.create(testContext, category: r, userOrder: userOrder1, name: "bleep", archiveID: serving1ArchiveID)
        e1.calories = calories1
        try testContext.save()

        try e1.logCalories(testContext, mainStore: mainStore, now: day1, tz: tz)
        try testContext.save()

        guard let zrr1 = try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: mainStore)
        else { XCTFail(); return }
        XCTAssertEqual(calories1, zrr1.calories)

        // user removes ZDayRun (possibly from different device)

        zrr1.userRemoved = true
        try testContext.save()

        // user completes serving (possibly from different device)

        let e2 = MServing.create(testContext, category: r, userOrder: userOrder2, name: "blort", archiveID: serving1ArchiveID)
        e2.calories = calories2
        try e2.logCalories(testContext, mainStore: mainStore, now: day1, tz: tz)
        try testContext.save()

        guard let zrr2 = try ZDayRun.get(testContext, consumedDay: consumedDay1, inStore: mainStore)
        else { XCTFail(); return }

        // ensure that ZDayRun has been restored from the userRemove (possibly on another device)
        XCTAssertFalse(zrr2.userRemoved)
        XCTAssertEqual(calories2, zrr1.calories) // assume calories1 was cascaded
    }
}
