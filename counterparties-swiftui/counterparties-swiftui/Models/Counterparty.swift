//
//  Counterparty.swift
//  counterparties-swiftui
//
//  Created by Илья Чуб on 12.01.2022.
//

import Foundation

struct CounterpartyModel: Identifiable {
    public var id: Int = 0
    public var name: String = ""
    public var contactPhoneNumber: String = ""
    public var email: String? = nil
    public var imageData: Data? = nil
}
