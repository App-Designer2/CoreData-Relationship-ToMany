//
//  DetailView.swift
//  Medias
//
//  Created by App Designer2 on 28.01.22.
//

import SwiftUI
import PhotosUI

struct DetailView: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var detail : Social
    @State private var avatar: Data = .init(count: 0)
    @State private var imageD: Data = .init(count: 0)
    
    @ObservedObject var comment : Comment
    //------------Date--------------
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    var date = Date()
    
    //------------Hours--------------
    static var hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    var hour = Date()
    
    
    @State private var image: [UIImage] = []
    @State private var collectPicker = false
    var rows = Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 12), count: 1)
    
    @State private var showCommentView: Bool = false
    
    @State private var selectComment = Comment()
    var id = UUID()
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
        VStack(spacing: 10) {
            
            ZStack {
                //Background Image
                ZStack(alignment: .bottomTrailing) {
                    
                Image(uiImage: UIImage(data: detail.imageD ?? self.imageD)!)
                    .renderingMode(.original)
                    .resizable()
                    .frame(height: 240)
                    
                    NavigationLink(destination: {
                        
                        CommentView(comment: comment)
                        
                    }, label: {
                        
                    Image(systemName: "bubble.left.fill").padding(10)
                    .symbolRenderingMode(.monochrome)
                    .background(.ultraThinMaterial)
                    .foregroundStyle(.green)
                    .clipShape(Circle())
                    .font(.system(size: 25, weight: .regular))
                    .shadow(radius: 15)
                        
                    })
                }
                
                //Avatar Image
                Image(uiImage: UIImage(data: detail.avatar ?? self.avatar)!)
                    .renderingMode(.original)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 120,height: 115)
                    .shadow(radius: 10)
                    .offset(x: -0, y: 120)
                              
            
            }
            Spacer(minLength: 40)
            
            Form {
                
                Section(header: Text("Name:")) {
                    Text(detail.name ?? "")
                        .font(.headline)
                }
                
                Section(header: Text("About:")) {
                    Text("\(detail.about!.localizedCapitalized)")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .cornerRadius(8)
                }
                
                Section(header: Text("Collection:")) {
                    HStack {
                        Image(systemName: self.image.count > 1 ? "photo.on.rectangle.angled" : "photo.fill")
                        Text("\(image.count)")
                            .font(.caption)
                        
                        Spacer()
                        Button(action: {
                            self.collectPicker.toggle()
                        }) {
                        Image(systemName: "photo.fill")
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        if self.image.isEmpty != true {
                            LazyHGrid(rows: rows, spacing: 12) {
                                ForEach(image, id: \.self) { img in
                                    withAnimation(.default) {
                                        Image(uiImage: img)
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 160, height: 160)
                                            .cornerRadius(8)
                                            .shadow(radius: 10)
                                        
                                            .overlay(alignment: .topLeading) {
                                                Image(systemName: "photo.circle.fill")
                                                    .foregroundColor(.white)
                                                    .shadow(radius: 3)
                                                    .padding(6)
                                            }
                                            .overlay(alignment: .bottomTrailing) {
                                                Image(systemName: "trash.fill")
                                                    .padding(6)
                                                    .symbolRenderingMode(.monochrome)
                                                    .background(Color.red)
                                                    .foregroundStyle(.white)
                                                    .clipShape(Circle())
                                                    .font(.system(size: 15, weight: .regular))
                                                    .shadow(radius: 8)
                                                
                                            }
                                        
                                    }.animation(Animation.spring(), value: 4)
                                }
                            }//LazyHGrid
                    }//If
                    else {
                        Text("Empty")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    }
                }
                Section(header: Text("Posted:")) {
                    HStack {
                    Text("\(detail.date ?? self.hour, formatter: Self.hourFormatter)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        
                        Text("\(detail.date ?? self.date, formatter: Self.dateFormatter)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }.listStyle(GroupedListStyle())
            Spacer()
         }//vstack
            withAnimation(.default) {
            VStack {
            /*//Button(action: {
                //self.showCommentView.toggle()
                
            //}) {
        
                
                Image(systemName: "bubble.left.fill").padding(10)
                .symbolRenderingMode(.monochrome)
                .background(.ultraThinMaterial)
                .foregroundStyle(.green)
                .clipShape(Circle())
                .font(.system(size: 25, weight: .regular))
                .shadow(radius: 15)
                
            }//button*/
                
            //.padding(6)
            }.padding(.trailing)
        }.animation(Animation.spring(), value: 4)
        
        }.edgesIgnoringSafeArea(.top)
            .sheet(isPresented: self.$collectPicker) {
                PhotoPicker(images: self.$image, show: self.$collectPicker)
            }
        
            .sheet(isPresented: self.$showCommentView) {
                
                //CommentView()
                
            }
        
            //The image i choce was so heavy, because of that the app cratched!!
    
        // I hope you could understand everything that we have been doing on here. dont forget to subscribe and like!!
    
    }
}



struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var images: [UIImage]
    @Binding var show: Bool
    
    func makeCoordinator() -> Coordinator {
        return PhotoPicker.Coordinator(img1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> PHPickerViewController {
        
        var configu = PHPickerConfiguration()
        configu.filter = .images
        configu.selectionLimit = 0
        
        let picker = PHPickerViewController(configuration: configu)
        picker.delegate = context.coordinator
        
        return picker
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<PhotoPicker>) {
        //
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var img0 : PhotoPicker
        init(img1: PhotoPicker) {
            img0 = img1
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            img0.show.toggle()
            
            for img in results {
                
                if img.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    
                    img.itemProvider.loadObject(ofClass: UIImage.self) {(image, err) in
                        
                        guard let image1 = image else {
                            print(err as Any)
                            return
                        }
                        
                        self.img0.images.append(image1 as! UIImage)
                    }
                } else {
                    print("Can not load images")
                }
            }
        }
    }
    
}
