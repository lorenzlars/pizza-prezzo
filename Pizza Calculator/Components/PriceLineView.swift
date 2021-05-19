//
//  PriceLineView.swift
//  Pizza Calculator
//
//  Created by Lars Lorenz on 16.05.21.
//

import SwiftUI
import Combine
import CoreData

struct PriceLineView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingSheet = false
    @State private var inputPrice: String = ""
    
    @Binding var isEditing: Bool
    var size: Size
    
    var title: String {
        if let diameter = size.diameter {
            return "\(diameter) Ø"
        }
        
        if let width = size.width, let height = size.height {
            return "\(width) x \(height)"
        }
        
        return ""
    }
    
    var body: some View {
        let inputPrice: Binding<String> = Binding {
            self.inputPrice
        } set: { newValue in
            Calculator.shared.calculateResult(size: self.size, price: newValue)
            self.inputPrice = newValue
        }
        
        return ZStack(alignment: .trailing) {
            HStack {
                Text(self.title)
                    .frame(width: 100)
                    .padding(.vertical, 8)
                    .background(Color("AccentColor"))
                    .cornerRadius(8)
                Spacer()
                    .frame(width: 20)
                HStack {
                    TextField("price", text: inputPrice)
                        .keyboardType(.decimalPad)
                        .onReceive(Just(_inputPrice.wrappedValue)) { newValue in
                            if let range = newValue.range(of: #"[0-9]{1,4}([,.][0-9]{0,2})?"#, options: .regularExpression) {
                                inputPrice.wrappedValue = String(newValue[range])
                            } else {
                                inputPrice.wrappedValue = ""
                            }
                        }
                        .disabled(self.isEditing)
                    Text("\(Locale.current.currencySymbol!)")
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(UIColor.systemGray3), lineWidth: 2))
                .cornerRadius(8)
                
            }
            .background(Color(.white))
            .zIndex(2)
            .padding(.trailing, self.isEditing ? 80 : 0)
            HStack {
                Button(action: {
                    self.showingSheet.toggle()
                }, label: {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .foregroundColor(Color(UIColor.systemBlue))
                        .frame(width: 30, height: 30)
                })
                Button(action: {
                    self.deleteSize(size: self.size)
                }, label: {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .foregroundColor(Color(UIColor.systemRed))
                        .frame(width: 30, height: 30)
                })
            }
            .zIndex(1)
            .opacity(self.isEditing ? 1 : 0)
        }
        .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.6))
        .sheet(isPresented: self.$showingSheet) {
            SizeEditView(size: self.size, onDismiss: {
                Calculator.shared.calculateResult(size: self.size, price: self.inputPrice)
                self.showingSheet.toggle()
                self.isEditing = false
            })
        }
    }
    
    private func deleteSize(size: Size) {
        withAnimation {
            Calculator.shared.deleteResult(size: size)
            
            viewContext.delete(size)
            
            try! viewContext.save()
        }
    }
    
    func addDoneButtonOnNumpad(textField: UITextField) {

      let keypadToolbar: UIToolbar = UIToolbar()

      // add a done button to the numberpad
      keypadToolbar.items=[
        UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textField, action: #selector(UITextField.resignFirstResponder)),
        UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
      ]
      keypadToolbar.sizeToFit()
      // add a toolbar with a done button above the number pad
      textField.inputAccessoryView = keypadToolbar
    }
}

struct PriceLineView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let fetchRequest = NSFetchRequest<Size>(entityName: "Size")
        let sizes = try! viewContext.fetch(fetchRequest)
        let size = sizes[0]
        
        PriceLineView(isEditing: .constant(true), size: size)
            .previewLayout(.sizeThatFits)
        PriceLineView(isEditing: .constant(false), size: size)
            .previewLayout(.sizeThatFits)
    }
}
