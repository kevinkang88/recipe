//
//  RecipeListApp.swift
//  RecipeList
//
//  Created by Dong Kevin Kang on 1/27/25.
//

import SwiftUI

@main
struct RecipeListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
