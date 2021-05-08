//
//  SizeEditView.swift
//  Pizza Calculator
//
//  Created by Lars Lorenz on 02.05.21.
//

import SwiftUI
import CoreData

struct SizeEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    private enum SizeType {
       case Round
       case Square
    }
    
    private var isEditing: Bool {
        return self.size != nil
    }
    
    @State private var sizeType: SizeType = SizeType.Round
    @State private var radius: String = ""
    @State private var width: String = ""
    @State private var height: String = ""
    
    @State private var size: Size?
    private var onDismiss: (() -> Void)?
    
    init(size: Size?) {
        self._size = State(initialValue: size)
        
        if let s = size {
            if let radius = s.radius {
                self._radius = State(initialValue: "\(radius)")
                self._sizeType = State(initialValue: SizeType.Round)
            }
            
            if let width = s.width, let height = s.height {
                self._width = State(initialValue: "\(width)")
                self._height = State(initialValue: "\(height)")
                self._sizeType = State(initialValue: SizeType.Square)
            }
        }
    }
    
    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                Picker(selection: self.$sizeType, label: Text("Picker")) {
                    Text("Round").tag(SizeType.Round)
                    Text("Square").tag(SizeType.Square)
                }
                .pickerStyle(SegmentedPickerStyle())
                if self.sizeType == SizeType.Round {
                    TextField("Radius", text: self.$radius)
                        .keyboardType(.numberPad)
                }
                if self.sizeType == SizeType.Square {
                    TextField("Width", text: self.$width)
                        .keyboardType(.numberPad)
                    TextField("Height", text: self.$height)
                        .keyboardType(.numberPad)
                }
                Button("Save") {
                    if self.isEditing {
                        updateItem()
                    } else {
                        addItem()
                    }
                    
                    if let onDismiss = self.onDismiss {
                        onDismiss()
                    } else {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGray6))
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Size(context: viewContext)
            
            if self.sizeType == SizeType.Round {
                if let radius = Int(self.radius) {
                    newItem.radius = NSNumber(value: radius)
                }
            } else if (self.sizeType == SizeType.Square) {
                if let width = Int(self.width) {
                    newItem.width = NSNumber(value: width)
                }
                
                if let height = Int(self.height) {
                    newItem.height = NSNumber(value: height)
                }
            }

            try! viewContext.save()
        }
    }
    
    private func updateItem() {
        withAnimation {
            if self.sizeType == SizeType.Round, let size = self.size {
                if let radius = Int(self.radius) {
                    size.radius = NSNumber(value: radius)
                    size.height = nil
                    size.width = nil
                }
            }
            
            if self.sizeType == SizeType.Square, let size = self.size {
                if let width = Int(self.width), let height = Int(self.height) {
                    size.radius = nil
                    size.width = NSNumber(value: width)
                    size.height = NSNumber(value: height)
                }
            }
             
            try! viewContext.save()
        }
    }
}

struct SizeEditView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest = NSFetchRequest<Size>(entityName: "Size")
        let sizes = try! context.fetch(fetchRequest)
        
        SizeEditView(size: sizes[0])
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
