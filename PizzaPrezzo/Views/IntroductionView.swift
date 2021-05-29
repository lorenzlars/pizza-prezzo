//
//  IntroductionView.swift
//  PizzaPrezzo
//
//  Created by Lars Lorenz on 29.05.21.
//

import SwiftUI

struct IntroductionView: View {
    var callback: () -> Void
    
    var body: some View {
        ModalView {
            VStack {
                Text("introductionTitle")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                Text("introductionDescription")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40)
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(Color("AccentColor"))
                        .frame(width: 45, height: 45)
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("createSize")
                            .fontWeight(.semibold)
                        Text("createSizeDescription")
                    }
                    Spacer()
                }
                .padding(.bottom)
                HStack {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .foregroundColor(Color("AccentColor"))
                        .frame(width: 45, height: 45)
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("editSize")
                            .fontWeight(.semibold)
                        Text("editSizeDescription")
                    }
                    Spacer()
                }
                .padding(.bottom, 50)
                ButtonView {
                    HStack {
                        Text("close")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                .onTapGesture {
                    callback()
                }
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IntroductionView {}
            IntroductionView(callback: {})
                .preferredColorScheme(.dark)
        }
    }
}
