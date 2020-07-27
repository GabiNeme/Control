//
//  SavingModel.swift
//  Control
//
//  Created by Gabriela Neme on 26/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation
import RealmSwift

struct SavingsModel {
    
    let realm = try! Realm()
    
        
    func savingNameUsed(savingName: String) ->Bool {
        let savingsNames = realm.objects(Saving.self).filter(NSPredicate(format:"name == %@", savingName)).count
        
        return !(savingsNames == 0)
    }
    


    
}


