//
//  Subcategory.swift
//  Control
//
//  Created by Gabriela Neme on 20/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation
import RealmSwift

class Subcategory: Object {
    @objc dynamic var name: String = ""
    
    @objc dynamic var iconType: String = ""
    @objc dynamic var iconImage: String = ""
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "subcategories")
    
    
    init(name: String, iconImage: IconImage) {
        
        self.name = name
        
        self.iconType = iconImage.typeString
        self.iconImage = iconImage.name

    }
    
    required init() {
        //fatalError("init() has not been implemented")
    }
    
    func edit(newSubcategory: Subcategory){
        let realm = try! Realm()
            
        do{
            try realm.write {
                self.name = newSubcategory.name
                self.iconType = newSubcategory.iconType
                self.iconImage = newSubcategory.iconImage
            }
        }catch{
            print("Error saving new category: \(error)")
        }
        
    }
    
}
