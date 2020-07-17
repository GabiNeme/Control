//
//  AccountsModel.swift
//  Control
//
//  Created by Gabriela Neme on 14/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation
import RealmSwift

struct AccountsModel {
    
    let realm = try! Realm()
    
    func getNextAccountPosition() -> Int {
        
        let lastPosition: Int = realm.objects(Account.self).max(ofProperty: "listPosition") as Int? ?? -1
        
        return lastPosition + 1
        
    }
    
    func swapAccounts(account1: Account, account2: Account) {
        
        let tempPosition = account1.listPosition
        
        do{
            try realm.write {
                account1.listPosition = account2.listPosition
                account2.listPosition = tempPosition
            }
            
        }catch{
            print("Error updating account: \(error)")
        }
    }
    
    
    func deleteAccount(account: Account) {
        do{
            try realm.write{
                realm.delete(account)
            }
        }catch{
            print("Error deleting account: \(error)")
        }
    }
    
}


