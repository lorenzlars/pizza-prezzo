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
    
    @State private var showingSheet = false

    var body: some Scene {
        WindowGroup {
            CalculatorView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .sheet(isPresented: self.$showingSheet, content: {
                    IntroductionView {
                        showingSheet.toggle()
                    }
                })
                .onAppear() {
                    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
                    if !launchedBefore  {
                        showingSheet.toggle()
                        UserDefaults.standard.set(true, forKey: "launchedBefore")
                    }
                }
        }
    }
}
