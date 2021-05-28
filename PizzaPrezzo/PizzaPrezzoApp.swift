//
//  Pizza_CalculatorApp.swift
//  Pizza Calculator
//
//  Created by Lars Lorenz on 02.05.21.
//

import SwiftUI

@main
struct PizzaPrezzoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CalculatorView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
