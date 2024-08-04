//
//  IdeariumApp.swift
//  Idearium
//
//  Created by Patrick Kühn on 21.06.24.

import SwiftUI
import SwiftData

@main
struct IdeariumApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {}

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.context)
        }
        .modelContainer(sharedModelContainer)
    }
}
