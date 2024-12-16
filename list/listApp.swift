//
//  listApp.swift
//  list
//
//  Created by student on 16.12.2024.
//

import SwiftUI

@main
struct listApp: App {
    let persistenceController = PersistenceController.shared
    @State private var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            ListView(listController: ListController.shared)
                .environment(networkMonitor)
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
