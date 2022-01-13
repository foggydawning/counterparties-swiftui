//
//  Views.swift
//  counterparties-swiftui
//
//  Created by Илья Чуб on 13.01.2022.
//

import SwiftUI
import UIKit


struct AddCounterpartyView: View {
    
    @State var name: String = ""
    @State var email: String = ""
    @State var contactPhoneNumber: String = ""
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage(named: "CounterpartyDefaultPic")!
    
     
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
     
    var body: some View {
         
        VStack {
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.width)
                .clipped()
                .edgesIgnoringSafeArea(.all)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ _ in
                            isShowPhotoLibrary = true
                        })
                )
            
            Spacer()
            
            BasicTextField(textString: "Enter name", text: $name)
                .keyboardType(.emailAddress)
            Spacer().frame(height: 10)
            BasicTextField(textString: "Enter email", text: $email)
                .keyboardType(.emailAddress)
            Spacer().frame(height: 10)
            BasicTextField(
                textString: "Enter contact phone number",
                text: $contactPhoneNumber
            ).keyboardType(.emailAddress)
               
            Spacer()
            
            Button(
                action: { buttonAction() },
                label: { Text("Add").fontWeight(.bold) }
            ).buttonStyleViewModifier()
            
            Spacer().frame(height: 20)
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Adding counterparty")
        .navigationBarColor(
            backgroundColor: .clear, titleColor: .white
        )
        
    }
    
    private func buttonAction() {
        let imageData: Data? = self.image.pngData()
        DB_Manager().addCounterparty(
            nameValue: self.name,
            emailValue: self.email,
            contactPhoneNumberValue: self.contactPhoneNumber,
            imageDataValue: imageData
        )
        self.mode.wrappedValue.dismiss()
    }
}

struct EditCounterpartyView: View {
    @Binding var id: Int
    @State var name: String = ""
    @State var email: String = ""
    @State var contactPhoneNumber: String = ""
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage(named: "CounterpartyDefaultPic")!
     
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
     
    var body: some View {
         
        VStack {
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.width)
                .clipped()
                .edgesIgnoringSafeArea(.all)
                .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged({ _ in
                                isShowPhotoLibrary = true
                            })
                        )
            Spacer()
            
            BasicTextField(textString: "Enter name", text: $name)
                .keyboardType(.emailAddress)
            Spacer().frame(height: 10)
            BasicTextField(textString: "Enter email", text: $email)
                .keyboardType(.emailAddress)
            Spacer().frame(height: 10)
            BasicTextField(
                textString: "Enter contact phone number",
                text: $contactPhoneNumber
            ).keyboardType(.emailAddress)
               
            Spacer()
            
            Button(
                action: { buttonAction() },
                label: { Text("Edit").fontWeight(.bold) }
            ).buttonStyleViewModifier()
            
            Spacer()
        }
        .ignoresSafeArea(edges: [.top])
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
        }
        .onAppear(perform: {
            let counterpartyModel: CounterpartyModel =
                DB_Manager().getCounterparty(idValue: self.id)
            self.name = counterpartyModel.name
            self.email = counterpartyModel.email ?? ""
            self.contactPhoneNumber = counterpartyModel.contactPhoneNumber
            self.image = UIImage(data: counterpartyModel.imageData!)!
        })
    }
    
    private func buttonAction() {
        let imageData: Data? = self.image.pngData()
        DB_Manager().updateUser(
            idValue: self.id,
            nameValue: self.name,
            emailValue: self.email,
            contactPhoneNumberValue: self.contactPhoneNumber,
            imageDataValue: imageData
        )

        // go back to home page
        self.mode.wrappedValue.dismiss()
    }
}
