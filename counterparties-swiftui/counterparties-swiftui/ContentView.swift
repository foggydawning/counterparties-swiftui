//
//  ContentView.swift
//  counterparties-swiftui
//
//  Created by Илья Чуб on 12.01.2022.
//

import SwiftUI

struct ContentView: View {
    let screenSize: CGSize = UIScreen.main.bounds.size
    @State var counterpartyModels: [CounterpartyModel] = []
    
    @State var isCounterpartySelected: Bool = false
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .bottom){
                VStack {
                    Spacer(minLength: 10)
                    List {
                        ForEach(self.counterpartyModels) { model in
                    
                            HStack {
                                Ellipse()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                Spacer().frame(width: 30)
                                Text(model.name)
                                Spacer()
                                Text("\(model.contactPhoneNumber)")
                                Spacer().frame(width: 30)
                            }
                            .swipeActions {
                                EditSwipeButton(
                                    model: model,
                                    counterpartyModels: self.$counterpartyModels,
                                    isCounterpartySelected: self.$isCounterpartySelected
                                )
                            }
                            .swipeActions {
                                DeleteSwipeButton(
                                    model: model,
                                    counterpartyModels: self.$counterpartyModels
                                )
                            }
                            .sheet(isPresented: self.$isCounterpartySelected) {
                                EmptyView()
                            }
                            
                        }
                    }
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
        var body: some View {
            Button {
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
