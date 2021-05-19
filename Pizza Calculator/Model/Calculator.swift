//
//  Calculator.swift
//  Pizza Calculator
//
//  Created by Lars Lorenz on 08.05.21.
//

import Foundation
import SwiftUI
import CoreData

struct CalculatorResult: Identifiable {
    var id: String
    var title: String
    var value: String
    var area: String
    var price: String
    var rawValue: Double
}

class Calculator: ObservableObject {
    @Published var results: [CalculatorResult] = []
    
    static let shared = Calculator()
    
    private init() { }
    
    func deleteResult(size: Size) -> Void {
        self.results = self.results.filter { $0.id != size.id }
    }
    
    func calculateResult(size: Size, price: String) -> Void {
        let title = self.calcTitle(ofSize: size)
        let area = self.calcAreaWith(size: size)
        
        if let index = self.results.firstIndex(where: { result in
            result.id == size.id
        }) {
            if let price = Double(self.formatPriceString(price: price)) {
                let value = calculatePrice(price: price, area: area)
                
                self.results[index].title = title
                self.results[index].value = self.format(value: value)
                self.results[index].area = self.format(area: area)
                self.results[index].price = self.format(price: price)
                self.results[index].rawValue = value
            } else {
                self.results.remove(at: index)
            }
        } else if let price = Double(self.formatPriceString(price: price)) {
            let value = calculatePrice(price: price, area: area)
            
            self.results.append(CalculatorResult(id: size.id!,
                                                 title: title,
                                                 value: self.format(value: value),
                                                 area: self.format(area: area),
                                                 price: self.format(price: price),
                                                 rawValue: price))
        }
        
        self.results.sort { a, b in
            return a.rawValue < b.rawValue
        }
    }
    
    private func formatPriceString(price: String) -> String {
        return price.replacingOccurrences(of: ",", with: ".")
    }
    
    private func calculatePrice(price: Double, area: Double) -> Double {
        return price / area * 100
    }
    
    private func format(value: Double) -> String {
        let formatter = NumberFormatter()
        
        formatter.usesGroupingSeparator = false
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.locale = Locale.current
        
        return formatter.string(from: NSNumber(value: value))!
    }
    
    private func format(area: Double) -> String {
        let formatter = NumberFormatter()
        
        formatter.usesGroupingSeparator = false
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        return formatter.string(from: NSNumber(value: area))!
    }
    
    private func format(price: Double) -> String {
        let formatter = NumberFormatter()
        
        formatter.usesGroupingSeparator = false
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        return formatter.string(from: NSNumber(value: price))!
    }
    
    private func calcTitle(ofSize size: Size) -> String {
        if let radius = size.diameter {
            return "\(radius) Ø"
        }
        
        if let width = size.width, let height = size.height {
            return "\(width) x \(height)"
        }
        
        return ""
    }
    
    private func calcAreaWith(size: Size) -> Double {
        if let diameter = size.diameter {
            return Double.pi * pow(Double(truncating: diameter) / 2, 2)
        }

        if let width = size.width, let heigth = size.height {
            return Double(truncating: width) * Double(truncating: heigth)
        }
        
        return 0
    }
}
