//
//  Conta.swift
//  Control
//
//  Created by Gabriela Neme on 01/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var balance: Double = 0.0
    @objc dynamic var savings: Double = 0.0
    @objc dynamic var available: Double = 0.0
    
    @objc dynamic var iconType: String = ""
    @objc dynamic var iconImage: String = ""
    @objc dynamic var iconColor: String = ""
    
    @objc dynamic var addToTotal: Bool = true
    @objc dynamic var listPosition: Int = 0
    
    init(name: String, balance: Double, iconImage: IconImage, iconColor: String, addToTotal: Bool){
        
        self.name = name
        self.balance = balance
        self.savings = 0.0
        self.available = balance
        
        self.iconType = iconImage.typeString
        self.iconImage = iconImage.name
        self.iconColor = iconColor
        
        self.addToTotal = addToTotal
        
        self.listPosition = AccountsModel().getNextAccountPosition()
        
    }
    
    required init() {
        //fatalError("init() has not been implemented")
    }
    
    
    func save(){
        
        let realm = try! Realm()
        
        do{
            try realm.write {
                realm.add(self)
            }
        }catch{
            print("Error saving new account: \(error)")
        }
        
    }
    
    func edit(changeTo account: Account){
        
        let realm = try! Realm()
        
        do{
            try realm.write {
                self.name = account.name
                self.balance = account.balance
                self.savings = account.savings
                self.available = account.savings
                
                self.iconType = account.iconType
                self.iconImage = account.iconImage
                self.iconColor = account.iconColor
                
                self.addToTotal = account.addToTotal
                
                self.listPosition = account.listPosition
            }
        }catch{
            print("Error saving new account: \(error)")
        }
        
    }
    
}
