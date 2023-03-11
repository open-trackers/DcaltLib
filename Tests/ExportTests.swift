//
//  ExportTests.swift
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

final class ExportTests: TestBase {
    let categoryArchiveID = UUID()
    let servingArchiveID = UUID()

    let createdAtStr = "2023-01-10T05:00:00Z"
    var createdAt: Date!
    let consumedAtStr = "2023-01-13T21:00:00Z"
    var consumedAt: Date!

    var consumedDay: String!
    var consumedTime: String!

    let weight_gStr = "324.0"
    var weight_g: Float!
    let volume_mLStr = "644.0"
    var volume_mL: Float!
    let lastIntensityStr = "1.6"
    var lastIntensity: Float!
    let caloriesStr = "105"
    var calories: Int16!
    let userOrderStr = "18"
    var userOrder: Int16!

    override func setUpWithError() throws {
        try super.setUpWithError()

        weight_g = Float(weight_gStr)
        volume_mL = Float(volume_mLStr)
        createdAt = df.date(from: createdAtStr)
        consumedAt = df.date(from: consumedAtStr)
        lastIntensity = Float(lastIntensityStr)
        calories = Int16(caloriesStr)
        userOrder = Int16(userOrderStr)

        (consumedDay, consumedTime) = splitDateLocal(consumedAt)!
    }

    func testZCategory() throws {
        _ = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", createdAt: createdAt, toStore: mainStore)
        try testContext.save()

        let request = makeRequest(ZCategory.self)
        let results = try testContext.fetch(request)
        let data = try exportData(results, format: .CSV)
        guard let actual = String(data: data, encoding: .utf8) else { XCTFail(); return }

        let expected = """
        name,createdAt,categoryArchiveID
        blah,\(createdAtStr),\(categoryArchiveID.uuidString)

        """

        XCTAssertEqual(expected, actual)
    }

    func testZServing() throws {
        let zr = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        _ = ZServing.create(testContext, zCategory: zr, servingArchiveID: servingArchiveID, servingName: "bleh", createdAt: createdAt, toStore: mainStore)
        try testContext.save()

        let request = makeRequest(ZServing.self)
        let results = try testContext.fetch(request)
        let data = try exportData(results, format: .CSV)
        guard let actual = String(data: data, encoding: .utf8) else { XCTFail(); return }

        let expected = """
        name,servingArchiveID,createdAt,categoryArchiveID
        bleh,\(servingArchiveID.uuidString),\(createdAtStr),\(categoryArchiveID.uuidString)

        """

        XCTAssertEqual(expected, actual)
    }

    func testZServingRun() throws {
        let zr = ZCategory.create(testContext, categoryArchiveID: categoryArchiveID, categoryName: "blah", toStore: mainStore)
        let ze = ZServing.create(testContext, zCategory: zr, servingArchiveID: servingArchiveID, servingName: "bleh", toStore: mainStore)
        let dr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 2392, toStore: mainStore)
        _ = ZServingRun.create(testContext, zDayRun: dr, zServing: ze, consumedTime: consumedTime, calories: calories, createdAt: createdAt, toStore: mainStore)
        try testContext.save()

        let request = makeRequest(ZServingRun.self)
        let results = try testContext.fetch(request)
        let data = try exportData(results, format: .CSV)
        guard let actual = String(data: data, encoding: .utf8) else { XCTFail(); return }

        let expected = """
        consumedTime,calories,userRemoved,createdAt,consumedDay,servingArchiveID
        \(consumedTime!),\(caloriesStr),false,\(createdAtStr),\(consumedDay!),\(servingArchiveID.uuidString)

        """

        XCTAssertEqual(expected, actual)
    }

    func testZDayRun() throws {
        let dr = ZDayRun.create(testContext, consumedDay: consumedDay, calories: 2392, createdAt: createdAt, toStore: mainStore)
        dr.userRemoved = true
        try testContext.save()

        let request = makeRequest(ZDayRun.self)
        let results = try testContext.fetch(request)
        let data = try exportData(results, format: .CSV)
        guard let actual = String(data: data, encoding: .utf8) else { XCTFail(); return }

        let expected = """
        consumedDay,calories,userRemoved,createdAt
        \(consumedDay!),2392,true,\(createdAtStr)

        """

        XCTAssertEqual(expected, actual)
    }

    func testCategory() throws {
        let r = MCategory.create(testContext, name: "bleh", userOrder: 1, archiveID: categoryArchiveID, createdAt: createdAt)
        r.userOrder = userOrder
        r.imageName = "bloop"
        r.lastCalories = 323
        r.lastConsumedAt = consumedAt
        // r.setColor(Color.red)
        try testContext.save()

        let request = makeRequest(MCategory.self)
        let results = try testContext.fetch(request)
        let data = try exportData(results, format: .CSV)
        guard let actual = String(data: data, encoding: .utf8) else { XCTFail(); return }

        let expected = """
        archiveID,imageName,name,color,userOrder,lastCalories,lastConsumedAt,createdAt
        \(categoryArchiveID.uuidString),bloop,bleh,,\(userOrderStr),323,\(consumedAtStr),\(createdAtStr)

        """

        XCTAssertEqual(expected, actual)
    }

    func testServing() throws {
        let r = MCategory.create(testContext, name: "bleh", userOrder: 1, archiveID: categoryArchiveID)
        r.userOrder = userOrder
        let e = MServing.create(testContext, category: r, userOrder: userOrder, name: "bleep", archiveID: servingArchiveID, createdAt: createdAt)
        e.weight_g = weight_g
        e.volume_mL = volume_mL
        e.calories = calories
        e.lastIntensity = lastIntensity
        // e.units = 2
        try testContext.save()

        let request = makeRequest(MServing.self)
        let results = try testContext.fetch(request)
        let data = try exportData(results, format: .CSV)
        guard let actual = String(data: data, encoding: .utf8) else { XCTFail(); return }

        let expected = """
        archiveID,weight_g,calories,lastIntensity,name,volume_mL,userOrder,createdAt,categoryArchiveID
        \(servingArchiveID.uuidString),\(weight_gStr),\(caloriesStr),\(lastIntensityStr),bleep,\(volume_mLStr),\(userOrderStr),\(createdAtStr),\(categoryArchiveID)

        """

        XCTAssertEqual(expected, actual)
    }

    func testCategoryJSON() throws {
        let r = MCategory.create(testContext, name: "bleh", userOrder: 1, archiveID: categoryArchiveID, createdAt: createdAt)
        r.userOrder = userOrder
        r.imageName = "bloop"
        r.lastCalories = 323
        r.lastConsumedAt = consumedAt
        // r.setColor(.red)
        try testContext.save()

        let request = makeRequest(MCategory.self)
        let results = try testContext.fetch(request)
        let data = try exportData(results, format: .JSON)
        guard let actual = String(data: data, encoding: .utf8) else { XCTFail(); return }

        let expected = """
        [{"name":"bleh","color":null,"lastConsumedAt":"\(consumedAtStr)","userOrder":\(userOrderStr),"createdAt":"\(createdAtStr)","lastCalories":323,"archiveID":"\(categoryArchiveID.uuidString)","imageName":"bloop"}]
        """

        XCTAssertEqual(expected, actual)
    }

    // TODO: JSON export for the other types
}
