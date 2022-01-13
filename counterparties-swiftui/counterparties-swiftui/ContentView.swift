//
//  ContentView.swift
//  counterparties-swiftui
//
//  Created by Илья Чуб on 12.01.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var counterpartyViewModel: CounterpartyViewModel = .init()
    
    var body: some View {
        VStack{
            Text("ID: \(counterpartyViewModel.counterparty.id!)")
        }.onAppear(perform: {
            DB_Manager().getUsers()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
