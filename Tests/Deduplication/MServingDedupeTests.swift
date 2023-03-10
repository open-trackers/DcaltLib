//
//  MServingDedupeTests.swift
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

final class MServingDedupeTests: TestBase {
    let catArchiveID1 = UUID()
    let catArchiveID2 = UUID()
    let servArchiveID1 = UUID()
    let servArchiveID2 = UUID()

    let date1Str = "2023-01-02T21:00:01Z"
    var date1: Date!
    let date2Str = "2023-01-02T21:00:02Z"
    var date2: Date!

    override func setUpWithError() throws {
        try super.setUpWithError()

        date1 = df.date(from: date1Str)
        date2 = df.date(from: date2Str)
    }

    func testDifferentArchiveID() throws {
        let c1 = MCategory.create(testContext, userOrder: 10, archiveID: catArchiveID1, createdAt: date1)
        let s1 = MServing.create(testContext, category: c1, userOrder: 4, archiveID: servArchiveID1, createdAt: date1)
        let s2 = MServing.create(testContext, category: c1, userOrder: 8, archiveID: servArchiveID2, createdAt: date2)
        try testContext.save() // needed for fetch request to work properly

        try MServing.dedupe(testContext, categoryArchiveID: catArchiveID1, servingArchiveID: servArchiveID1)

        XCTAssertFalse(c1.isDeleted)
        XCTAssertFalse(s1.isDeleted)
        XCTAssertFalse(s2.isDeleted)
    }

    func testSameArchiveIdWithinCategory() throws {
        let c1 = MCategory.create(testContext, userOrder: 10, archiveID: catArchiveID1, createdAt: date1)
        let s1 = MServing.create(testContext, category: c1, userOrder: 4, archiveID: servArchiveID1, createdAt: date1)
        let s2 = MServing.create(testContext, category: c1, userOrder: 8, archiveID: servArchiveID1, createdAt: date2)
        try testContext.save() // needed for fetch request to work properly

        try MServing.dedupe(testContext, categoryArchiveID: catArchiveID1, servingArchiveID: servArchiveID1)

        XCTAssertFalse(c1.isDeleted)
        XCTAssertFalse(s1.isDeleted)
        XCTAssertTrue(s2.isDeleted)
    }

    func testSameArchiveIdOutsideCategory() throws {
        let c1 = MCategory.create(testContext, userOrder: 10, archiveID: catArchiveID1, createdAt: date1)
        let c2 = MCategory.create(testContext, userOrder: 11, archiveID: catArchiveID2, createdAt: date2)
        let s1 = MServing.create(testContext, category: c1, userOrder: 4, archiveID: servArchiveID1, createdAt: date1)
        let s2 = MServing.create(testContext, category: c2, userOrder: 8, archiveID: servArchiveID1, createdAt: date2)
        try testContext.save() // needed for fetch request to work properly

        try MServing.dedupe(testContext, categoryArchiveID: catArchiveID1, servingArchiveID: servArchiveID1)

        XCTAssertFalse(c1.isDeleted)
        XCTAssertFalse(c2.isDeleted)
        XCTAssertFalse(s1.isDeleted)
        XCTAssertFalse(s2.isDeleted)
    }
}
