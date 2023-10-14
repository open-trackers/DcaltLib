//
//  Export-utils.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

#if !os(watchOS)
    public func dcaltCreateZipArchive(_ context: NSManagedObjectContext,
                                      mainStore: NSPersistentStore,
                                      archiveStore: NSPersistentStore,
                                      format: ExportFormat = .CSV) throws -> Data?
    {
        let entries: [(String, Data)] = try [
            makeDelimFile(AppSetting.self, context, format: format, inStore: mainStore),
            makeDelimFile(MCategory.self, context, format: format, inStore: mainStore),
            makeDelimFile(MFoodGroup.self, context, format: format, inStore: mainStore),
            makeDelimFile(MServing.self, context, format: format, inStore: mainStore),

            makeDelimFile(ZDayRun.self, context, format: format, inStore: archiveStore),
            makeDelimFile(ZCategory.self, context, format: format, inStore: archiveStore),
            makeDelimFile(ZServing.self, context, format: format, inStore: archiveStore),
            makeDelimFile(ZServingRun.self, context, format: format, inStore: archiveStore),
        ]

        return try createZipArchive(context, entries: entries)
    }
#endif
