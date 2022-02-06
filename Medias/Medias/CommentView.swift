//
//  CommentView.swift
//  Medias
//
//  Created by App Designer2 on 30.01.22.
//

import SwiftUI

struct CommentView: View {
    
    @Environment(\.managedObjectContext) private var moc

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Comment.id, ascending: true)])
    private var comments: FetchedResults<Comment>
    
    @ObservedObject var comment : Comment
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Social.id, ascending: true)])
    private var socials: FetchedResults<Social>
    @State private var selecSocial = Social()
    
    @State private var write : String = ""
    
    @State private var date = ""
    var hour = Date()
    
    var body: some View {
        
        
        VStack {
            
            Form {
                ForEach(comments, id: \.self) { comm in
                    
                    VStack(alignment: .leading) {
                            
                        Text("\(comm.comment ?? "")").padding()
                        .font(.headline)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                }
                }.onDelete(perform: delete)
            }.navigationBarTitle("Comment", displayMode: .inline)
        HStack {
           /* Picker("", selection: self.$selecSocial) {
                ForEach(socials, id: \.self) { nam in
                    Text(nam.name!)
                        
                }.tint(.gray)
                    .font(.callout)
            }*/
            
            TextField("Comment...", text: self.$write)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .shadow(radius: 5)
            
            Button(action: {
                
                let add = Comment(context: self.moc)
                add.id = UUID()
                add.comment = self.write
                add.date = Date()
                //add.commentToSocial = self.selecSocial
                
                
                try! self.moc.save()
                
                self.write = ""
            }) {
                Text("Send").bold()
                    .padding(6)
                    .foregroundColor(.white)
                    .background(self.write.count > 0 ? Color.blue : Color.gray)
                    .cornerRadius(5)
                
                
            } .disabled(self.write.count > 0 ? false: true)
        } .padding()
    
        }
        
    }
    func delete(at offset: IndexSet) {
        for index in offset {
            let delet = comments[index]
            self.moc.delete(delet)
        }
        try! self.moc.save()
    }
}

