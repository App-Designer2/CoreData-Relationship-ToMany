//
//  AddItemView.swift
//  Medias
//
//  Created by App Designer2 on 28.01.22.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var dismiss

    
    //------------------------------------------------------------//
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Media.category, ascending: true)])
    //This will be in ForEach allowing us to select any of the category that is saved on its database.
    private var medias: FetchedResults<Media>
    
    //This is used to pick a categoty [ Picker ]
    @State private var selectMedia = Media()
    //------------------------------------------------------------//
    
    
    @State private var name: String = ""
    @State private var about: String = ""
    
    //------------------------------Image-----Start-----
    @State private var showImage: Bool = false
    @State private var chooceOptionImg: Bool = false
    @State private var image: Data = .init(count: 0)
    //------------------------------Image-----End-----
    
    //------------------------------AvatarPhoto-----Start-----
    @State private var showAvatar: Bool = false
    @State private var chooceOptionAvatar: Bool = false
    @State private var avatar: Data = .init(count: 0)
    //------------------------------AvatarPhoto-----End-----
    
    
    //------------------------------SourceType-----Start-----
    //by implementing this varable sourceType ,we will be able to chooce between: .Camera,.PhotoLibrary or .SavedPhotoAlbum
    @State private var sourceType : UIImagePickerController.SourceType = .photoLibrary
    //------------------------------SourceType-----End-----

    //------------------------------Animation-----Start-----
    @State private var categoryIsEmpty: Bool = false
    @State private var go123 : Bool = false
    //------------------------------Animation-----End-----
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                //You dont have to use this if you dont want, but if you want, you can go on my channel and search: Neomurphirm UI.
                Rectangle()
                    .fill(Color.init("background"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                    
                if self.image.count != 0 {
                    
                    Button(action: {
                        
                        self.chooceOptionImg.toggle()
                        
                    }) {
                        
                        Image(uiImage: UIImage(data: self.image)!)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 120, height: 120)
                            .background(Color("background"))
                            .cornerRadius(10)
                            .shadow(color: Color("light"), radius: 10, x: -10, y: -10)
                            .shadow(color: Color("dark"), radius: 10, x: 10, y: 10)
                        
                    }
                } else {
                    
                    Button(action: {
                        
                        self.chooceOptionImg.toggle()
                        
                    }) {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 120, height: 120)
                        .background(Color("background"))
                        .cornerRadius(10)
                        .shadow(color: Color("light"), radius: 10, x: -10, y: -10)
                        .shadow(color: Color("dark"), radius: 10, x: 10, y: 10)
                    }
                }
                
                
                    
                TextField("Name...", text: self.$name)
                    .padding(10)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 60)
                    .background(Color("background"))
                    .cornerRadius(25)
                    .shadow(color: Color("light"), radius: 10, x: -10, y: -10)
                    .shadow(color: Color("dark"), radius: 10, x: 10, y: 10)
                
                    TextField("About...",text: self.$about)
                    .padding(10)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 60)
                    .background(Color("background"))
                    .cornerRadius(25)
                    .shadow(color: Color("light"), radius: 10, x: -10, y: -10)
                    .shadow(color: Color("dark"), radius: 10, x: 10, y: 10)
                    
                Picker("Select Category", selection: self.$selectMedia) {
                    Text("Select any task").bold().font(.title3)
                    ForEach(medias, id: \.self) {
                        Text($0.category ?? "")
                            .foregroundColor(.blue)
                    }
                }
                    Button(action: {
                        
                        //This will call an animation
                        self.go123.toggle()
                        
                        //The animation will end and after 4 sec the data will be saved
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            
                            
                        self.go123 = false
                            
                        let add = Social(context: self.moc)
                        add.id = UUID()
                        add.avatar = self.avatar
                        add.name = self.name
                        add.date = Date()
                        add.imageD = self.image
                        add.about = self.about
                        
                        //This will allows us to add item on the selected category
                            //You could find it on the [ Media+CoreDataProperties.swift ]
                        add.socialToMedia = selectMedia
                        
                        //Lets save the data permanent
                        try! self.moc.save()
                        
                        //Lets dismiss the View after tap
                        self.dismiss.wrappedValue.dismiss()
                            
                        }
                    }) {
                        Text("Add Item")
                            .bold()
                            .padding()
                            
                            .foregroundColor(.white)
                            
                    }
                    
                        .background(self.avatar.count != 0 && self.image.count != 0 && self.name.count > 0 && self.about.count > 6 ? Color.blue : Color("background"))
                    
                        .cornerRadius(6)
                    
                        .shadow(color: Color("light"), radius: 6, x: -6, y: -6)
                        .shadow(color: Color("dark"), radius: 6, x: 6, y: 6)
                    
                    //If the user doesn't put the requied information the button will stay disabled
                        .disabled(self.avatar.count != 0 && self.image.count != 0 && self.name.count > 0 && self.about.count > 6  ? false : true)
                    
                }.padding(.leading,12)
                    .padding(.trailing, 12)
                
                //This will call the image picker
                .sheet(isPresented: self.$showAvatar) {
                    
                    ImagePicker(images: self.$avatar, show: self.$showAvatar, sourceType: self.sourceType)
                    
                }
                //This will allows you to select [.Camera, .PhotoLibrary or .SavedPhotoAlbum
                
                .actionSheet(isPresented: self.$chooceOptionAvatar) {
                    ActionSheet(title: Text("Select anyone"), message: Text("Please select one of the option."), buttons: [.default(Text("Camera")) {
                        self.sourceType = .camera
                        self.showAvatar.toggle()
                        
                        //Dont forget that we can only use the camera on a real Device, no on the Simulator
                        //if you try to use it the app will cratch 🤯
                        
                    }, .default(Text("PhotoLibrary")) {
                        self.sourceType = .photoLibrary
                        self.showAvatar.toggle()
                        
                    }, .default(Text("SavedPhotosAlbum")) {
                        self.sourceType = .savedPhotosAlbum
                        self.showAvatar.toggle()
                    }, .cancel()])
                }
                .onAppear {
                    //If medias is empty the AddItemView will kick you out after 5 sec
                    if self.medias.count == 0 {
                        self.categoryIsEmpty = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.dismiss.wrappedValue.dismiss()
                        }
                    } else {
                        
                    }
                }
                
            }
             //------------blurView------and-------disabledView--
            .blur(radius: self.medias.count > 0 ? 0 : 4)
            .disabled(self.medias.count > 0 ? false : true)//ScrollView
             //------------blurView------and-------disabledView--
                
                //This will remind you that you have to add at least 1 category to have access to this view
                //if there is not any category added, this view will kick 😨 you out after 4 sec
                if self.categoryIsEmpty == true {
                    VStack {
                       LottieView(filename: "task")
                    }
                    
                } else {
                    
                }
                
                //This counter animation will appear when you tap the add task button
                //and will last 4 sec, this animation will comfirm you that you did fufilled the requied infos
                if self.go123 {
                    LottieView(filename: "go")
                        .frame(width: 250, height: 250)
                }
                
                
            }.navigationBarTitle("Add Item", displayMode: .automatic)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            //This will call the Action function to chooce .camera,photoLibrary or savedPhotoAlbum to add it on the Avatar UIImageView
                            self.chooceOptionAvatar.toggle()
                        }) {
                            if self.avatar.count != 0 {
                                Button(action: {
                                    self.chooceOptionAvatar.toggle()
                                }) {
                                    Image(uiImage: UIImage(data: self.avatar)!)
                                        .renderingMode(.original)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 40, height: 40)
                                        .shadow(radius: 4)
                                    
                                }
                            } else {
                                
                                Button(action: {
                                    self.chooceOptionAvatar.toggle()
                                }) {
                                    Image(systemName: "photo.circle.fill")
                                        .resizable()
                                        .foregroundColor(.gray)
                                        .frame(width: 40, height: 40)                .shadow(radius: 4)
                                    
                                        .blur(radius: self.medias.count > 0 ? 0 : 4)
                                            
                                }
                            }
                        }
                    }
                })
            //The whole view will be disabled if the user doesn't add at least 1 category in the ContentView
                .disabled(self.medias.count > 0 ? false : true)
            
            
        }
        //This will call the image picker
        .sheet(isPresented: self.$showImage) {
            ImagePicker(images: self.$image, show: self.$showImage, sourceType: self.sourceType)
            
        }
        //This will allows you to select [.Camera, .PhotoLibrary or .SavedPhotoAlbum
        .actionSheet(isPresented: self.$chooceOptionImg) {
            ActionSheet(title: Text("Select anyone"), message: Text("Please select one of the option."), buttons: [.default(Text("Camera")) {
                self.sourceType = .camera
                self.showImage.toggle()
                
            }, .default(Text("PhotoLibrary")) {
                self.sourceType = .photoLibrary
                self.showImage.toggle()
                
            }, .default(Text("SavedPhotosAlbum")) {
                self.sourceType = .savedPhotosAlbum
                self.showImage.toggle()
            }, .cancel()])
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}


//ImagePicker
//We are done with the imagePicker implementation
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var images: Data
    @Binding var show: Bool
    
    
    var sourceType : UIImagePickerController.SourceType = .photoLibrary

    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(img1: self)
    }
    
        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
            
        picker.sourceType = sourceType
            
            //Now lets fetch the images
            //If you forget to connect them, you will never see a photo appearing on your app, so dont forget this
            picker.delegate = context.coordinator
        
        return picker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePicker>) {
        //
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var img0 : ImagePicker
        init(img1: ImagePicker) {
            img0 = img1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            //If you call the ImagePicker and then decided to dont pick any pic, by only push cancel
            self.img0.show.toggle()
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage] as? UIImage
            
            //Ths will send the photo to our app with good quality if you want it, only change the amoung on [ (compressionQuality: CGFloat) ]
            let data = image?.jpegData(compressionQuality: 1.0)
            
            self.img0.images = data!
            //When you click on the photo, the imagePickerView will dismiss asap
            self.img0.show.toggle()
        }
    }
}
