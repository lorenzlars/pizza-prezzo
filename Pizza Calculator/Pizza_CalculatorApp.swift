//
//  Pizza_CalculatorApp.swift
//  Pizza Calculator
//
//  Created by Lars Lorenz on 02.05.21.
//

import SwiftUI

@main
struct Pizza_CalculatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
