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
    
    func categoryNameUsed(categoryName: String) ->Bool {
        let categories = realm.objects(Category.self).filter(NSPredicate(format:"name == %@", categoryName)).count
        
        return !(categories == 0)
    }
    
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
    

    
}
