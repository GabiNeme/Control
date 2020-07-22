//
//  Saving.swift
//  Control
//
//  Created by Gabriela Neme on 22/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation
import RealmSwift

class Saving: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var savingGoal: Double = 0.0
    @objc dynamic var saved: Double = 0.0
    
    @objc dynamic var iconType: String = ""
    @objc dynamic var iconImage: String = ""
    @objc dynamic var iconColor: String = ""
    
    init(name: String, savingGoal: Double, iconImage: IconImage, iconColor: String){
        
        self.name = name
        self.savingGoal = savingGoal
        
        self.iconType = iconImage.typeString
        self.iconImage = iconImage.name
        self.iconColor = iconColor
        
    }
    
    required init() {
        //fatalError("init() has not been implemented")
    }
    
    
    func edit(changeTo saving: Saving){
        
        let realm = try! Realm()
        
        do{
            try realm.write {
                self.name = saving.name
                self.savingGoal = saving.savingGoal
                
                self.iconType = saving.iconType
                self.iconImage = saving.iconImage
                self.iconColor = saving.iconColor
            }
        }catch{
            print("Error saving new account: \(error)")
        }
        
    }
    
}
