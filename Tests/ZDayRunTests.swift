//
//  ZDayRunTests.swift
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

final class ZDayRunTests: TestBase {
    let categoryArchiveID = UUID()
    let servingArchiveID = UUID()

    func testUpdateCalories() throws {
        let consumedDay = "2022-12-20"
        let consumedTime3 = "16:03"
        let consumedTime5 = "16:05"
        let consumedTime7 = "16:07"
        let sr = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        let se = ZServing.create(testContext, zCategory: sr, servingArchiveID: servingArchiveID, servingName: "bleh", toStore: mainStore)
        let dr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 2392, toStore: mainStore)
        let sr3 = ZServingRun.create(testContext, zDayRun: dr, zServing: se, consumedTime: consumedTime3, calories: 3, toStore: mainStore)
        let sr5 = ZServingRun.create(testContext, zDayRun: dr, zServing: se, consumedTime: consumedTime5, calories: 5, toStore: mainStore)
        let sr7 = ZServingRun.create(testContext, zDayRun: dr, zServing: se, consumedTime: consumedTime7, calories: 7, toStore: mainStore)
        try testContext.save()

        XCTAssertEqual(2392, dr.calories)

        dr.updateCalories()

        XCTAssertEqual(15, dr.calories)

        sr3.userRemoved = true
        dr.updateCalories()

        XCTAssertEqual(12, dr.calories)

        sr5.userRemoved = true
        dr.updateCalories()

        XCTAssertEqual(7, dr.calories)

        sr7.userRemoved = true
        dr.updateCalories()

        XCTAssertEqual(0, dr.calories)
    }

    func testUpdateCalorieFailsIfDayRunRemoved() throws {
        let consumedDay = "2022-12-20"
        let consumedTime3 = "16:03"
        let sr = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        let se = ZServing.create(testContext, zCategory: sr, servingArchiveID: servingArchiveID, servingName: "bleh", toStore: mainStore)
        let dr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 2392, toStore: mainStore)
        _ = ZServingRun.create(testContext, zDayRun: dr, zServing: se, consumedTime: consumedTime3, calories: 3, toStore: mainStore)
        try testContext.save()

        XCTAssertEqual(2392, dr.calories)
        dr.updateCalories()
        XCTAssertEqual(3, dr.calories)

        dr.userRemoved = true
        dr.updateCalories()

        XCTAssertEqual(0, dr.calories)
    }
}
