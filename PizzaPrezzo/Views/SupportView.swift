//
//  SupportView.swift
//  PizzaPrezzo
//
//  Created by Lars Lorenz on 28.05.21.
//

import SwiftUI
import MessageUI

struct SupportView: View {
    @State private var showingSheet = false
    
    var body: some View {
        ModalView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("support")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("supportSubtitle")
                        .font(.title2)
                        
                    Spacer()
                }
                .padding(.bottom)
                Text("supportDescription")
                    .padding(.bottom)
                ButtonView {
                    HStack {
                        Image(systemName: "gift")
                            .foregroundColor(.black)
                        Text("buyMeAPizza")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 4)
                .onTapGesture {
                    if let url = URL(string: "https://www.buymeacoffee.com/larslorenz") {
                        UIApplication.shared.open(url)
                    }
                }
                ButtonView {
                    HStack {
                        Image(systemName: "hands.clap")
                            .foregroundColor(.black)
                        Text("feedback")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 4)
                .onTapGesture {
                    let email = "mail@larslorenz.dev"
                    
                    if let url = URL(string: "mailto:\(email)") {
                      if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                      } else {
                        UIApplication.shared.openURL(url)
                      }
                    }
                }
                ButtonView {
                    HStack {
                        Image(systemName: "questionmark.diamond")
                            .foregroundColor(.black)
                        Text("introduction")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                .onTapGesture {
                    self.showingSheet.toggle()
                }
                .padding(.bottom)
                HStack {
                    Spacer()
                    Button("aboutMe") {
                        if let url = URL(string: "https://larslorenz.dev/") {
                            UIApplication.shared.open(url)
                        }
                    }
                    .foregroundColor(Color("Button"))
                    Spacer()
                }
                Spacer()
            }
            .padding(.horizontal)
            .sheet(isPresented: self.$showingSheet, content: {
                IntroductionView {
                    showingSheet.toggle()
                }
            })
        }
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SupportView()
            SupportView()
                .preferredColorScheme(.dark)
        }
    }
}
