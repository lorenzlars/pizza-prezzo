//
//  ResultLineView.swift
//  Pizza Calculator
//
//  Created by Lars Lorenz on 16.05.21.
//

import SwiftUI

struct ResultLineView: View {
    var price: String
    var size: String
    var area: String
    var result: String
    
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    Text(self.size)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 10)
                }
                .background(Color(.white))
                .cornerRadius(8)
                .shadow(radius: 4)
                Spacer()
            }
            .zIndex(2)
            ResultLineDetails(price: self.price, size: self.size, area: self.area, result: self.result)
                .zIndex(1)
        }
    }
}

struct ResultLineDetails: View {
    
    var price: String
    var size: String
    var area: String
    var result: String
    
    var body: some View {
        HStack {
            Text(self.size)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.trailing, 15)
            VStack(alignment: .leading) {
                Text("price")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.systemGray3))
                Text("area")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.systemGray3))
            }
            VStack(alignment: .leading) {
                Text("\(self.price)")
                    .font(.caption)
                Text("\(self.area) \(Locale.current.usesMetricSystem ? "cm" : "in")\u{B2}")
                    .font(.caption)
            }
            Spacer()
            VStack {
                Text("\(self.result)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(UIColor.systemRed))
                Text("cent / \(Locale.current.usesMetricSystem ? "cm" : "in")\u{B2}")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.systemGray3))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(Color(.white))
        .cornerRadius(8)
    }
}

struct ResultLineView_Previews: PreviewProvider {
    static var previews: some View {
        ResultLineView(price: "7", size: "30 Ø", area: "200", result: "1,45")
            .previewLayout(.sizeThatFits)
            .background(Color(UIColor.systemBlue))
        ResultLineDetails(price: "7", size: "30 Ø", area: "200", result: "1,45")
            .previewLayout(.sizeThatFits)
            .background(Color(UIColor.systemBlue))
    }
}
