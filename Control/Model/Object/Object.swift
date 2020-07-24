//
//  Object.swift
//  Control
//
//  Created by Gabriela Neme on 22/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation
import RealmSwift

extension Object {
    
    func save(){
        
        let realm = try! Realm()
        
        do{
            try realm.write {
                realm.add(self)
            }
        }catch{
            print("Error saving new object: \(error)")
        }
        
    }
    
    func delete() {
        let realm = try! Realm()
        
        do{
            try realm.write{
                realm.delete(self)
            }
        }catch{
            print("Error deleting object: \(error)")
        }
    }
    
}
