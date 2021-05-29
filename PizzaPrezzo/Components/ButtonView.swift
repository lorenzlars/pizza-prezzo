//
//  ButtonView.swift
//  PizzaPrezzo
//
//  Created by Lars Lorenz on 29.05.21.
//

import SwiftUI

struct ButtonView<Content: View>: View {
    let content: Content

    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
        .frame(height: 50)
        .background(Color("AccentColor"))
        .foregroundColor(Color(UIColor.label))
        .cornerRadius(12)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView({})
    }
}
