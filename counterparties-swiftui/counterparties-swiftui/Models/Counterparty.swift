//
//  Counterparty.swift
//  counterparties-swiftui
//
//  Created by Илья Чуб on 12.01.2022.
//

struct CounterpartyModel: Identifiable {
    let id: Int?
    var name: String? = ""
    var contactPhoneNumber: String? = ""
    var email: String? = nil
    
    static var placeholder: Self {
        .init(id: nil, name: nil, contactPhoneNumber: nil, email: nil)
    }
}
