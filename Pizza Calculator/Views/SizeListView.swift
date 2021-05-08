//
//  ContentView.swift
//  Pizza Calculator
//
//  Created by Lars Lorenz on 02.05.21.
//

import SwiftUI
import CoreData

struct SizeListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Size.radius, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Size>
    
    @State var showingUtility = false
    
    var beforeDismiss: (() -> Void)?

    var body: some View {
            List {
                ForEach(items) { item in
                    NavigationLink(Calculator.calcTitle(ofSize: item),
                                   destination: ScrollView {
                                    SizeEditView(size: item)
                                   }.navigationTitle("Edit Size")
                    )
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Sizes")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: HStack {
                Button(action: {
                    if let beforeDismiss = self.beforeDismiss {
                        beforeDismiss()
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                }
                Button(action: {
                    showingUtility.toggle()
                }) {
                    Label("Add Size", systemImage: "plus")
                }
            }, trailing: EditButton())
            .sheet(isPresented: $showingUtility)
            {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Rectangle()
                            .frame(width: 60, height: 6)
                            .foregroundColor(Color(UIColor.systemGray))
                            .cornerRadius(.infinity)
                        Spacer()
                    }
                    .padding(.top)
                    Text("Create Size")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    SizeEditView {
                        self.showingUtility.toggle()
                    }
                }
                .background(Color(UIColor.systemGray6))
            }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            try! viewContext.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SizeListView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
