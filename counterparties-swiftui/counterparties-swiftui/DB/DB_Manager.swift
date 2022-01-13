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
    
    public func addCounterparty(
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
    
    public func getUsers() -> [CounterpartyModel] {
        var counterpartyModels: [CounterpartyModel] = []
     
        // get all users in descending order
        counterpartiesTable = counterpartiesTable.order(id.desc)
     
        // exception handling
        do {
            // loop through all users
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
}

