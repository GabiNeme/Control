//
//  ObjectsModel.swift
//  Control
//
//  Created by Gabriela Neme on 28/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation
import RealmSwift

struct ObjectsModel {
    
    let realm = try! Realm()
    
    func nameUsed<Element: Object>(_ type: Element.Type, name: String) ->Bool {
        let accountNames = realm.objects(type).filter(NSPredicate(format:"name == %@", name)).count
        
        return !(accountNames == 0)
    }
    
}
