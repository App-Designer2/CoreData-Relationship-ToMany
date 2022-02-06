//
//  SocialRow.swift
//  Medias
//
//  Created by App Designer2 on 28.01.22.
//

import SwiftUI

struct SocialRow: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var social : Social
    @ObservedObject var comment : Comment
    var body: some View {
         
        VStack(spacing: 12) {
            
            Text("")
                .padding(6)
            
            NavigationLink(destination:  {
                
                DetailView(detail: social, comment: comment)
                
            }, label: {
                
            if social.avatar != nil {
                
                withAnimation(.default) {
                    
                Image(uiImage: UIImage(data: social.avatar!)!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 110, height:  100)
                    .shadow(radius: 8)
                    
                   }
                }
            })
            Text(social.name ?? "").bold()
                .font(.caption2)
            
        }.padding([.leading])
            .padding([.trailing])
    
    }
}

