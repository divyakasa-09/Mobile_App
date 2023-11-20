//
//  Swift_UI_AppApp.swift
//  Swift_UI_App
//
//  Created by Divya Kasa on 11/19/23.
//

import SwiftUI

@main
struct Swift_UI_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
