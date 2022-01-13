//
//  Views.swift
//  counterparties-swiftui
//
//  Created by Илья Чуб on 13.01.2022.
//

import SwiftUI


struct AddCounterpartyView: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var contactPhoneNumber: String = ""
     
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
     
    var body: some View {
         
        VStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height*0.5)
                .foregroundColor(.gray)
            Spacer()
            
            BasicTextField(textString: "Enter name", text: $name)
            Spacer().frame(height: 15)
            BasicTextField(textString: "Enter email", text: $email)
                .keyboardType(.emailAddress)
            Spacer().frame(height: 15)
            BasicTextField(
                textString: "Enter contact phone number",
                text: $contactPhoneNumber
            ).keyboardType(.phonePad)
               
            Spacer()
            
            Button(
                action: { buttonAction() },
                label: { Text("Add").fontWeight(.bold) }
            ).buttonStyleViewModifier()
            
            Spacer().frame(height: 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Adding counterparty")
        .navigationBarColor(
            backgroundColor: .clear, titleColor: .white
        )
    }
    
    private func buttonAction() {
        DB_Manager().addCounterparty(
            nameValue: self.name,
            emailValue: self.email,
            contactPhoneNumberValue: self.contactPhoneNumber
        )
        self.mode.wrappedValue.dismiss()
    }
}

struct EditCounterpartyView: View {
    @Binding var id: Int
    @State var name: String = ""
    @State var email: String = ""
    @State var contactPhoneNumber: String = ""
     
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
     
    var body: some View {
         
        VStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height*0.5)
                .foregroundColor(.gray)
            Spacer()
            
            BasicTextField(textString: "Enter name", text: $name)
            Spacer().frame(height: 15)
            BasicTextField(textString: "Enter email", text: $email)
                .keyboardType(.emailAddress)
            Spacer().frame(height: 15)
            BasicTextField(
                textString: "Enter contact phone number",
                text: $contactPhoneNumber
            ).keyboardType(.phonePad)
               
            Spacer()
            
            Button(
                action: { buttonAction() },
                label: { Text("Edit").fontWeight(.bold) }
            ).buttonStyleViewModifier()
            
            Spacer().frame(height: 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Adding counterparty")
        .navigationBarColor(
            backgroundColor: .clear, titleColor: .white
        )
        .onAppear(perform: {
            let counterpartyModel: CounterpartyModel =
                DB_Manager().getCounterparty(idValue: self.id)
             
            self.name = counterpartyModel.name
            self.email = counterpartyModel.email ?? ""
            self.contactPhoneNumber = counterpartyModel.contactPhoneNumber
        })
    }
    
    private func buttonAction() {
        DB_Manager().updateUser(
            idValue: self.id,
            nameValue: self.name,
            emailValue: self.email,
            contactPhoneNumberValue: self.contactPhoneNumber
        )

        // go back to home page
        self.mode.wrappedValue.dismiss()
        self.mode.wrappedValue.dismiss()
    }
}
