//
//  PokemonAppApp.swift
//  PokemonApp
//
//  Created by 123 on 23.02.24.
//

import SwiftUI

@main
struct PokemonAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
