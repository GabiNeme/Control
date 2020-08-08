//
//  CategoryModel.swift
//  Control
//
//  Created by Gabriela Neme on 20/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation
import RealmSwift

struct CategoryModel {
    
    let realm = try! Realm()
    
    func subcategoryNameUsed(parentCategory: Category,  subcategoryName: String) ->Bool {
        let subcategories = parentCategory.subcategories.filter("name = %@", subcategoryName).count
        
        return !(subcategories == 0)
    }
    
    func addSubcategory(category: Category, subcategory: Subcategory){
        do{
            try realm.write{
                category.subcategories.append(subcategory)
            }
        }catch{
            print("Error adding subcategory: \(error)")
        }
    }
    
    func changeParentCategory(oldSubcategory: Subcategory, newSubcategory: Subcategory, to newCategory: Category){
        do{
            try realm.write{
                realm.delete(oldSubcategory)
                newCategory.subcategories.append(newSubcategory)
            }
        }catch{
            print("Error adding subcategory: \(error)")
        }
    }

    
}
