//
//  MediasApp.swift
//  Medias
//
//  Created by App Designer2 on 28.01.22.
//

import SwiftUI

@main
struct MediasApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.managedObjectContext) private var moc
    var body: some Scene {
        WindowGroup {
            ContentView(comment: Comment(context: self.moc))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
