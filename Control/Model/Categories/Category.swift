//
//  Category.swift
//  Control
//
//  Created by Gabriela Neme on 20/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var type: String = ""
    
    @objc dynamic var name: String = ""
    
    @objc dynamic var iconType: String = ""
    @objc dynamic var iconImage: String = ""
    @objc dynamic var iconColor: String = ""
    
    let subcategories = List<Subcategory>()
    
    
    init(type: String, name: String, iconImage: IconImage, iconColor: String) {
        
        self.type = type
        
        self.name = name
        
        self.iconType = iconImage.typeString
        self.iconImage = iconImage.name
        self.iconColor = iconColor
    }
    
    required init() {
        //fatalError("init() has not been implemented")
    }
    
    
    func edit(name: String, iconImage: IconImage, iconColor: String){
        let realm = try! Realm()
        
        do{
            try realm.write {
                self.name = name
                self.iconType = iconImage.typeString
                self.iconImage = iconImage.name
                self.iconColor = iconColor
            }
        }catch{
            print("Error saving new category: \(error)")
        }
    }
    
}
