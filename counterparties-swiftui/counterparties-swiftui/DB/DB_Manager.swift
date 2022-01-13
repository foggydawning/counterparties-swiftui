//
//  DB_Manager.swift
//  counterparties-swiftui
//
//  Created by Илья Чуб on 13.01.2022.
//

import SQLite
import Foundation

class DB_Manager {
    private var db: Connection!
    // table instance
    private var counterpartiesTable: Table!
    // colomns instances of table
    private var id: Expression<Int>!
    private var name: Expression<String>!
    private var contactPhoneNumber: Expression<String>!
    private var email: Expression<String>!
    
    init () {
        // exception handling
        do {
            // path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true).first ?? ""

            // creating database connection
            db = try Connection("\(path)/CounterpartiesDB.sqlite3")
            
            // creating table object
            counterpartiesTable = Table("users")
             
            // create instances of each column
            id = .init("id")
            name = .init("name")
            contactPhoneNumber = .init("contactPhoneNumber")
            email = .init("email")
            
            // check if the table is already created
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {

                // if not, then create the table
                try db.run(counterpartiesTable.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(name)
                    t.column(email, unique: true)
                    t.column(contactPhoneNumber, unique: true)
                })
                 
                // set the value to true, so it will not attempt to create the table again
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
        } catch {
                   // show error message if any
                   print(error.localizedDescription)
        }
    }
    
    public func addCounterparty (
        nameValue: String,
        emailValue: String,
        contactPhoneNumberValue: String
    ){
        do {
            try db.run(
                counterpartiesTable.insert(
                    name <- nameValue,
                    email <- emailValue,
                    contactPhoneNumber <- contactPhoneNumberValue
                    
                )
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func getCounterparty(idValue: Int) -> CounterpartyModel {
        var counterpartyModel: CounterpartyModel = .init(id: 0)
        do {
            // get counterparty using ID
            let counterparty: AnySequence<Row> = try db.prepare(
                counterpartiesTable.filter(id == idValue)
            )
     
            try counterparty.forEach({ (rowValue) in
                counterpartyModel.id = try rowValue.get(id)
                counterpartyModel.name = try rowValue.get(name)
                counterpartyModel.email = try rowValue.get(email)
                counterpartyModel.contactPhoneNumber = try rowValue.get(contactPhoneNumber)
            })
        } catch {
            print(error.localizedDescription)
        }
        return counterpartyModel
    }
    
    public func deleteCounterparty(idValue: Int) {
        do {
            let counterparty: Table = counterpartiesTable.filter(id == idValue)
            try db.run(counterparty.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getCounterparties() -> [CounterpartyModel] {
        var counterpartyModels: [CounterpartyModel] = []
        counterpartiesTable = counterpartiesTable.order(name.asc)
        do {
            for counterparty in try db.prepare(counterpartiesTable) {
                let counterpartyModel: CounterpartyModel = .init(
                    id: counterparty[id],
                    name: counterparty[name],
                    contactPhoneNumber: counterparty[contactPhoneNumber],
                    email: counterparty[email]
                )
                counterpartyModels.append(counterpartyModel)
            }
        } catch {
            print(error.localizedDescription)
        }
        return counterpartyModels
    }
    
    public func updateUser(
        idValue: Int,
        nameValue: String,
        emailValue: String,
        contactPhoneNumberValue: String
    ){
        do {
            let counterparty: Table = counterpartiesTable.filter(id == idValue)
            try db.run(counterparty.update(
                name <- nameValue,
                email <- emailValue,
                contactPhoneNumber <- contactPhoneNumberValue
            ))
        } catch {
            print(error.localizedDescription)
        }
    }
}

