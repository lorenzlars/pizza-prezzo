//
//  TestView.swift
//  Pizza Calculator
//
//  Created by Lars Lorenz on 15.05.21.
//

import SwiftUI
import SwiftUITrackableScrollView

struct CalculatorView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Size.id, ascending: true)],
        animation: .default)
    private var sizes: FetchedResults<Size>
    
    @State private var isEditing: Bool = false
    @State private var scrollViewContentOffset = CGFloat(0)
    @State private var showingSheet = false
    @State private var showingSupport = false
    @ObservedObject var calculator: Calculator = Calculator.shared
    
    var body: some View {
        ZStack(alignment: .top) {
            ZStack {
                HStack {
                    Button(action: {
                        self.isEditing.toggle()
                    }, label: {
                        if self.isEditing {
                            Text("done")
                                .fontWeight(.bold)
                        } else {
                            Text("edit")
                                .fontWeight(.bold)
                        }
                    })
                    Spacer()
                    Button(action: {
                        self.showingSheet.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 22, height: 22)
                    })
                }
                HStack {
                    Spacer()
                    Text("appTitle")
                        .fontWeight(.bold)
                        .opacity(Double((self.scrollViewContentOffset - 35) / 60))
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            .background(Color(UIColor.systemBackground))
            .zIndex(2)
            TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset) {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("appTitle")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("appSubtitle")
                                .font(.caption)
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        Spacer()
                    }
                    .padding(.top, 50)
                    .padding(.bottom)
                    ForEach(self.sizes) { size in
                        PriceLineView(isEditing: self.$isEditing, size: size)
                    }
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("results")
                        .fontWeight(.heavy)
                        .padding(.bottom)
                        .foregroundColor(.black)
                    if self.calculator.results.count > 0 {
                        ForEach(self.calculator.results) { result in
                            ResultLineView(price: result.price, size: result.title, area: result.area, result: result.value)
                                .padding(.bottom)
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("emptyResults")
                                .foregroundColor(.black)
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(Color("AccentColor"))
                .cornerRadius(12)
                .padding(.top, 25)
                .padding(.horizontal)
                Button(action: {
                    self.showingSupport.toggle()
                }, label: {
                    Text("support")
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.systemGray3))
                })
                .padding(.top, 8)
                .sheet(isPresented: self.$showingSupport, content: {
                    SupportView()
                })
            }
            .padding(.top)
            .zIndex(1)
            .onChange(of: self.scrollViewContentOffset) { Equatable in
                if self.scrollViewContentOffset > 25 {
                    hideKeyboard()
                }
            }
        }
        .padding(.top, 50)
        .ignoresSafeArea()
        .sheet(isPresented: self.$showingSheet) {
            SizeEditView {
                self.showingSheet.toggle()
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalculatorView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            CalculatorView()
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
