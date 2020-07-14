//
//  Double.swift
//  Control
//
//  Created by Gabriela Neme on 05/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation

extension Double {
    
    func toCurrency() -> String? {
        
        return Formatter.currency.string(from: NSNumber(value: self))
        
    }
    
    
}
