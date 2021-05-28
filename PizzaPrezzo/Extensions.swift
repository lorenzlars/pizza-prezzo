//
//  Extensions.swift
//  Pizza Calculator
//
//  Created by Lars Lorenz on 19.05.21.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
