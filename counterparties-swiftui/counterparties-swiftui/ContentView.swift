//
//  ContentView.swift
//  counterparties-swiftui
//
//  Created by Илья Чуб on 12.01.2022.
//

import SwiftUI

struct ContentView: View {
    private var screenSize: CGSize { UIScreen.main.bounds.size }
    
    @State var counterpartyModels: [CounterpartyModel] = []
    @State var isCounterpartySelected: Bool = false
    @State var selectedCounterpartyId: Int = 0
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .bottom){
                VStack (spacing: 0) {
                    Rectangle()
                        .frame(width: screenSize.width, height: 10)
                        .foregroundColor(.gray.opacity(0.1))
                    List {
                        ForEach(self.counterpartyModels) { model in
                            CounterpartyHStack(
                                imageData: model.imageData!,
                                name: model.name,
                                contactPhoneNumber: model.contactPhoneNumber
                            )
                            .swipeActions {
                                EditSwipeButton(
                                    model: model,
                                    counterpartyModels: self.$counterpartyModels,
                                    isCounterpartySelected: self.$isCounterpartySelected,
                                    selectedCounterpartyId: self.$selectedCounterpartyId
                                )
                            }
                            .swipeActions {
                                DeleteSwipeButton(
                                    model: model,
                                    counterpartyModels: self.$counterpartyModels
                                )
                            }
                        }
                    }
                    .background(Color.gray.opacity(0.1))
                    .onAppear(perform: {
                        self.counterpartyModels = DB_Manager().getCounterparties()
                    })
                }
                
                VStack{
                    NavigationLink (
                        destination: AddCounterpartyView() ,
                        label: { Text("Add counterparty") }
                    ).buttonStyleViewModifier()
                    
                    Spacer().frame(height: 20)
                }
            }
            .navigationBarTitle("Counterparties")
            .navigationBarColor(
                backgroundColor: .black, titleColor: .white
            )
        }
        .sheet(isPresented: self.$isCounterpartySelected) {
            EditCounterpartyView(
                id: self.$selectedCounterpartyId
            )
            .onDisappear(perform: {
                self.counterpartyModels = DB_Manager().getCounterparties()
            })
        }
        
    }
    
    private struct CounterpartyHStack: View {
        
        let imageData: Data
        let name: String
        let contactPhoneNumber: String
        
        var body: some View {
            HStack {
                smallImage(data: imageData)
                Spacer().frame(width: 30)
                Text(name)
                Spacer()
                Text(contactPhoneNumber)
                Spacer().frame(width: 30)
            }
        }
    }
    private struct DeleteSwipeButton: View {
        var model: CounterpartyModel
        
        @Binding var counterpartyModels: [CounterpartyModel]
        
        var body: some View {
            Button {
                let dbManager: DB_Manager = .init()
                dbManager.deleteCounterparty(idValue: model.id)
                counterpartyModels = dbManager.getCounterparties()
            } label: {
                Label(
                    "Delete",
                    systemImage: "trash.circle.fill"
                )
            }.tint(.red)
        }
    }
    
    private struct EditSwipeButton: View {
        
        var model: CounterpartyModel
        
        @Binding var counterpartyModels: [CounterpartyModel]
        @Binding var isCounterpartySelected: Bool
        @Binding var selectedCounterpartyId: Int
        
        var body: some View {
            Button {
                selectedCounterpartyId = model.id
                isCounterpartySelected.toggle()
            } label: {
                Label(
                    "Edit",
                    systemImage: "pencil.circle.fill"
                )
            }.sheet(isPresented: $isCounterpartySelected) {
                Rectangle()
            }
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
