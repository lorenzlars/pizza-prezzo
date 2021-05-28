//
//  SizeEditView.swift
//  Pizza Calculator
//
//  Created by Lars Lorenz on 02.05.21.
//

import SwiftUI
import Combine
import CoreData

struct SizeEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    private enum SizeType {
       case Round
       case Rectangular
    }
    
    private var isEditing: Bool {
        return self.size != nil
    }
    
    private var canSave: Bool {
        if self.sizeType == SizeType.Round {
            return self.diameter.count > 0
        }
        
        if self.sizeType == SizeType.Rectangular {
            return self.width.count > 0 && self.height.count > 0
        }
        
        return false
    }
    
    @State private var sizeType: SizeType = SizeType.Round
    @State private var diameter: String = ""
    @State private var width: String = ""
    @State private var height: String = ""
    
    private var size: Size?
    private var onDismiss: (() -> Void)?
    
    init(size: Size, onDismiss: @escaping () -> Void) {
        self.size = size
        self.onDismiss = onDismiss
        
        if let diameter = size.diameter {
            self._diameter = State(initialValue: "\(diameter)")
            self._sizeType = State(initialValue: SizeType.Round)
        }
        
        if let width = size.width, let height = size.height {
            self._width = State(initialValue: "\(width)")
            self._height = State(initialValue: "\(height)")
            self._sizeType = State(initialValue: SizeType.Rectangular)
        }
    }
    
    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }

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
                Text(self.isEditing ? "editTitle" : "createTitle")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(self.isEditing ? "editSubtitle" : "createSubtitle")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.systemGray))
                    .padding(.bottom, 30)
                Picker(selection: self.$sizeType, label: Text("Picker")) {
                    Text("round").tag(SizeType.Round)
                    Text("rectangular").tag(SizeType.Rectangular)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 30)
                if self.sizeType == SizeType.Round {
                    TextField("diameter", text: self.$diameter)
                        .keyboardType(.numberPad)
                        .onReceive(Just(self.diameter)) { newValue in
                            if let range = newValue.range(of: #"[0-9]{1,4}"#, options: .regularExpression) {
                                self.diameter = String(newValue[range])
                            } else {
                                self.diameter = ""
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                if self.sizeType == SizeType.Rectangular {
                    TextField("width", text: self.$width)
                        .keyboardType(.numberPad)
                        .onReceive(Just(self.width)) { newValue in
                            if let range = newValue.range(of: #"[0-9]{1,4}"#, options: .regularExpression) {
                                self.width = String(newValue[range])
                            } else {
                                self.width = ""
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("height", text: self.$height)
                        .keyboardType(.numberPad)
                        .onReceive(Just(self.height)) { newValue in
                            if let range = newValue.range(of: #"[0-9]{1,4}"#, options: .regularExpression) {
                                self.height = String(newValue[range])
                            } else {
                                self.height = ""
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Spacer()
                    VStack {
                        Text("Save")
                            .font(.headline)
                    }
                    .frame(width: 335, height: 50)
                    .background(self.canSave ? Color("AccentColor") : Color(UIColor.systemGray3))
                    .foregroundColor(self.canSave ? .black : Color(UIColor.label))
                    .cornerRadius(12)
                    Spacer()
                }
                .padding(.top, 60)
                .onTapGesture {
                    if self.canSave {
                        if self.isEditing {
                            updateItem()
                        } else {
                            addItem()
                        }
                        
                        if let onDismiss = self.onDismiss {
                            onDismiss()
                        }
                    }
                }
                Spacer()
            }
            .padding()
    }
    
    private func addItem() {
        withAnimation {
            if self.sizeType == SizeType.Round {
                if let diameter = Double(self.diameter) {
                    let newItem = Size(context: viewContext)
                    
                    newItem.id = UUID().uuidString
                    newItem.diameter = NSNumber(value: diameter)
                    
                    try! viewContext.save()
                }
            } else if (self.sizeType == SizeType.Rectangular) {
                if let width = Double(self.width), let height = Double(self.height) {
                    let newItem = Size(context: viewContext)
                    
                    newItem.id = UUID().uuidString
                    newItem.width = NSNumber(value: width)
                    newItem.height = NSNumber(value: height)

                    try! viewContext.save()
                }
            }
        }
    }
    
    private func updateItem() {
        withAnimation {
            if self.sizeType == SizeType.Round, let size = self.size {
                if let diameter = Double(self.diameter) {
                    size.diameter = NSNumber(value: diameter)
                    size.width = nil
                    size.height = nil
                    
                    try! viewContext.save()
                }
            }
            
            if self.sizeType == SizeType.Rectangular, let size = self.size {
                if let width = Double(self.width), let height = Double(self.height) {
                    size.diameter = nil
                    size.width = NSNumber(value: width)
                    size.height = NSNumber(value: height)
                    
                    try! viewContext.save()
                }
            }
        }
    }
}

struct SizeEditView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SizeEditView {
                
            }
            SizeEditView {
                
            }
            .preferredColorScheme(.dark)
        }
    }
}
