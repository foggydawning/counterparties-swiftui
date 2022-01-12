//
//  ViewModels.swift
//  counterparties-swiftui
//
//  Created by Илья Чуб on 12.01.2022.
//

import Combine
import Foundation


class SQLiteAPI {
    
    static let shared: SQLiteAPI = .init()
    func fetchCounterparty(for id: Int) -> AnyPublisher<CounterpartyModel, Never> {
        Just(
            CounterpartyModel.init(
                id: 10,
                name: "Alex",
                contactPhoneNumber: "+79113285700",
                email: "fgd@gmail.com"
            )
        )
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}

final class CounterpartyViewModel: ObservableObject {
    // input
    @Published var counterpartyId: Int = -1
    // output
    @Published var counterparty: CounterpartyModel = .placeholder
    
    init(){
        $counterpartyId
            .removeDuplicates()
            .flatMap { (id: Int) -> AnyPublisher <CounterpartyModel, Never> in
                SQLiteAPI.shared.fetchCounterparty(for: id)
        }
        .assign(to: \.counterparty , on: self)
        .store(in: &self.concellableSet)
    }
    
    private var concellableSet: Set<AnyCancellable> = []
}
