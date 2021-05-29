//
//  ModalView.swift
//  PizzaPrezzo
//
//  Created by Lars Lorenz on 29.05.21.
//

import SwiftUI

struct ModalView<Content: View>: View {
    let content: Content

    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 60, height: 6)
                    .cornerRadius(.infinity)
                    .foregroundColor(Color(UIColor.systemGray4))
                Spacer()
            }
            .padding(.top)
            .padding(.bottom, 50)
            content
        }
    }
}
struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView({})
    }
}
