//
//  Calculator.swift
//  Pizza Calculator
//
//  Created by Lars Lorenz on 08.05.21.
//

import Foundation
import SwiftUI

struct CalculatorSize: Identifiable {
    var id = UUID()
    var title: String
    var value: Binding<String>
}

struct CalculatorResult: Identifiable {
    var id = UUID()
    var title: String
    var result: String
}

class Calculator: ObservableObject {
    // @Publisher observes all changes of all nested properties; You have nothing to do
    @Published var sizes: [CalculatorSize] = []
    @Published var results: [CalculatorResult] = []
    
    func clear() -> Void {
        self.sizes.removeAll()
        self.results.removeAll()
    }
    
    func add(size: Size, at index: Int) -> Void {
        let title: String = Calculator.calcTitle(ofSize: size)
        let calculatorResult: CalculatorResult = CalculatorResult(title: title, result: "")
        var value: String = ""
        
        results.insert(calculatorResult, at: index)
        
        let calculatorSize: CalculatorSize = CalculatorSize(title: title, value: Binding(get: {
            value
        }, set: { newValue in
            // This is where the magic happens
            // The bindable is is used to store the value and to calculate the result
            // The result needs to be wirtten direclty into the self property
            // so that the @Published can recognice the changes.
            value = newValue
            let pricePerArea = Calculator.calc(price: Double(newValue) ?? 0, perArea: Calculator.calcArea(ofSize: size))
            let formattedPrice = String(format: "%.2f", pricePerArea)
            self.results[index].result = formattedPrice
            self.results.sort { a, b in
                return Float(a.result) ?? 0 > Float(b.result) ?? 0
            }
        }))
        
        sizes.insert(calculatorSize, at: index)
    }
    
    private static func calc(price: Double, perArea area: Double) -> Double {
        return price / area * 1000
    }
    
    public static func calcTitle(ofSize size: Size) -> String {
        if let radius = size.radius {
            // TODO: i18n for radius
            return "Radius \(radius)"
        }
        
        if let width = size.width, let height = size.height {
            return "\(width) x \(height)"
        }
        
        return ""
    }
    
    private static func calcArea(ofSize size: Size) -> Double {
        if let radius = size.radius {
            return Double.pi * Double(truncating: radius) * Double(truncating: radius)
        }

        if let width = size.width, let heigth = size.height {
            return Double(truncating: width) * Double(truncating:heigth)
        }
        
        return 0
    }
}
