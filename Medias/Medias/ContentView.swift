//
//  ContentView.swift
//  Medias
//
//  Created by App Designer2 on 28.01.22.
//

import SwiftUI
import CoreData
import Lottie

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Media.category, ascending: true)])
    private var medias: FetchedResults<Media>
@State private var selectMedia = Media()
    @State private var showCategory : Bool = false
    @State private var showAddItem : Bool = false
    
    var columns = Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 15), count: 3)
    
    @State var addCategory = false
    
    @ObservedObject var comment : Comment
    
    var colors = UIColor.red
    var body: some View {
        NavigationView {
            ZStack {
                
                List {
               
                    
                ForEach(medias, id: \.id) { media in
                    
                    NavigationLink(destination:  {
                        
                        ScrollView {
                            if media.social.isEmpty != true {
                                
                        LazyVGrid(columns: columns, spacing: 15) {
                            
                        ForEach(media.social) { social in
                            
                            SocialRow(social: social, comment: comment)
                        }
                        
                        }//LazyVGrid
                        }//if
                            else {
                                
                                LottieView(filename: "data")
                                    .frame(width: 500, height: 500)
                            }
                    }//ScrollView
                    
                                   
                                   
                        .navigationBarTitle(media.category ?? "", displayMode: .inline)
                    }, label: {
                        
                        HStack {
                            
                        Text(media.category ?? "")
                            Spacer()
                                .badge(media.social.count)
                                .foregroundColor(.red)
                        }
                        //I will stop the video until here, see you in the next one
                    })//NvgLink
                    
                
                }//Main ForEach
                //.onDelete(perform: deleteItems)
                    
                
            }//List
                
                if self.addCategory == true {
                    
                    VStack {
                        
                       LottieView(filename: "task")
                    }
                    
                } else {
                    
                }
                
            }.navigationBarTitle(self.medias.count > 0 ? "Tasks": "Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        
                        self.showCategory.toggle()
                        
                    }) {
                        Label("", systemImage: "list.dash")                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button(action: {
                        
                        self.showAddItem.toggle()
                        
                    }) {
                        Label("", systemImage: "plus")                    }
                }
                
            }
            
                
        } .onAppear {
            if self.medias.count == 0 {
                self.addCategory = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.addCategory = false
                }
            } else {
                
            }
        }
        .sheet(isPresented: self.$showCategory) {
            
            AddCategoryView().environment(\.managedObjectContext, self.moc)
        }
        .sheet(isPresented: self.$showAddItem) {
            
            AddItemView().environment(\.managedObjectContext, self.moc)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            
            offsets.map { medias[$0] }.forEach(moc.delete)

            do {
                try moc.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(comment: Comment(context: PersistenceController.preview.container.viewContext)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



// In the next video we will implement how to add item select them by Category. see you in the next One!1

//In the next video we will implement the DetailView

// To have access to the Lottie animation Add this on the Swift Package:  "https://github.com/airbnb/lottie-ios.git"

struct LottieView: UIViewRepresentable {
    var filename: String
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = AnimationView()
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .repeat(1.0)
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
    }
    
}
