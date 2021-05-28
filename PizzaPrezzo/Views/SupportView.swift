//
//  SupportView.swift
//  PizzaPrezzo
//
//  Created by Lars Lorenz on 28.05.21.
//

import SwiftUI
import MessageUI

struct SupportView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 60, height: 6)
                    .cornerRadius(.infinity)
                    .foregroundColor(Color(UIColor.systemGray4))
                Spacer()
            }
            .padding(.bottom, 50)
            HStack {
                Spacer()
                Text("Support")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            HStack {
                Spacer()
                Text("Hi, my name is Lars Lorenz")
                    .font(.title2)
                    .padding(.bottom)
                Spacer()
            }
            Text("I am a software architect and developer specializing in Web-Development. Passionate about creating remarkable user experiences, designing beautiful API and user interfaces, and writing maintainable, structured, and best-practice orientated code. Continuously trying to improve skills and learn new technologies.")
                .padding(.bottom)
            HStack {
                Spacer()
                Image(systemName: "gift")
                    .foregroundColor(.black)
                Text("Buy me a pizza")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(height: 50)
            .background(Color("AccentColor"))
            .foregroundColor(Color(UIColor.label))
            .cornerRadius(12)
            .padding(.bottom, 4)
            .onTapGesture {
                if let url = URL(string: "https://www.buymeacoffee.com/larslorenz") {
                    UIApplication.shared.open(url)
                }
            }
            HStack {
                Spacer()
                Image(systemName: "hands.clap")
                    .foregroundColor(.black)
                Text("Feedback")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(height: 50)
            .background(Color("AccentColor"))
            .foregroundColor(Color(UIColor.label))
            .cornerRadius(12)
            .padding(.bottom)
            .onTapGesture {
                EmailHelper.shared.send(subject: "Feedback", body: "", to: ["mail@larslorenz.dev"])
            }
            HStack {
                Spacer()
                Button("About me") {
                    if let url = URL(string: "https://larslorenz.dev/") {
                        UIApplication.shared.open(url)
                    }
                }
                .foregroundColor(Color("Button"))
                Spacer()
            }
            Spacer()
        }
        .padding()
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
