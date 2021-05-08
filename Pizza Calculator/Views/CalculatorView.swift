//
//  CalculatorView.swift
//  Pizza Calculator
//
//  Created by Lars Lorenz on 02.05.21.
//

import SwiftUI
import CoreData

struct CalculatorView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isShowingDetailView = false
    @ObservedObject var calculator: Calculator = Calculator()
    
    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(destination: SizeListView(beforeDismiss: {
                    initCalculator()
                }), isActive: $isShowingDetailView) {
                    EmptyView()
                }
                VStack(alignment: .leading) {
                    ForEach(self.calculator.sizes) { size in
                        Text("\(size.title)")
                        TextField("Preis", text: size.value)
                            .keyboardType(.decimalPad)
                    }
                    Text("Results")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    ForEach(self.calculator.results) { result in
                        if result.result != "" {
                            HStack {
                                Text("\(result.title)")
                                Spacer()
                                Text("Preis: \(result.result) €")
                            }.padding(.bottom)
                        }
                    }
                    
                }
                .padding()
            }
            .navigationTitle("Pizza Calculator")
            .navigationBarItems(trailing: Button("Sizes", action: {
                isShowingDetailView.toggle()
            }) )
        }
        .onAppear(perform: initCalculator)
    }
    
    func initCalculator() -> Void {
        let request: NSFetchRequest<Size> = Size.fetchRequest()
        let fetchResult = try! viewContext.fetch(request)
        
        self.calculator.clear()
        
        for index in fetchResult.indices {
            self.calculator.add(size: fetchResult[index], at: index)
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
