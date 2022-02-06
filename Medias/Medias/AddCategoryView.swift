//
//  AddCategoryView.swift
//  Medias
//
//  Created by App Designer2 on 28.01.22.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.dismiss) private var dismiss
    
    @State private var category : String = ""
    var body: some View {
        
        NavigationView {
            
            Form {
                TextField("Add Task...", text: self.$category)
                Button(action: {
                    
                    let add = Media(context: self.moc)
                    add.id = UUID()
                    add.category = self.category
                    
                    try! self.moc.save()
                    dismiss()
                }) {
                    Text("Add Task")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(self.category.count > 2 ? .blue : .gray)
                .disabled(self.category.count > 2 ? false: true)
                
                
            }.navigationBarTitle("Add Task")
        }
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView()
    }
}
