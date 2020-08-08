//
//  CreditCard.swift
//  Control
//
//  Created by Gabriela Neme on 27/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation
import RealmSwift

class CreditCard: Object {
    
    @objc dynamic var name: String = ""
    
    @objc dynamic var availableLimit: Double = 0.0
    @objc dynamic var limit: Double = 0.0
    @objc dynamic var closingDay: Int = 0
    @objc dynamic var dueDay: Int = 0
    
    @objc dynamic var iconType: String = ""
    @objc dynamic var iconImage: String = ""
    @objc dynamic var iconColor: String = ""
    
    init(name: String, limit: Double, closingDay: Int, dueDay: Int, iconImage: IconImage, iconColor: String){
        
        self.name = name
        
        self.availableLimit = limit
        self.limit = limit
        self.closingDay = closingDay
        self.dueDay = dueDay
        
        self.iconType = iconImage.typeString
        self.iconImage = iconImage.name
        self.iconColor = iconColor
        
    }
    
    required init() {
        //fatalError("init() has not been implemented")
    }
    
    func edit(changeTo creditCard: CreditCard){
        
        let realm = try! Realm()
        
        do{
            try realm.write {
                self.name = creditCard.name
                
                self.availableLimit = creditCard.availableLimit
                self.limit = creditCard.limit
                self.closingDay = creditCard.closingDay
                self.dueDay = creditCard.dueDay
                
                self.iconType = creditCard.iconType
                self.iconImage = creditCard.iconImage
                self.iconColor = creditCard.iconColor
            }
        }catch{
            print("Error saving new account: \(error)")
        }
        
    }
    
}

