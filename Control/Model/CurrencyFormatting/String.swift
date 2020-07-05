//
//  String.swift
//  Control
//
//  Created by Gabriela Neme on 05/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation

extension String {
    func asCurrency() -> String? {
        
        if self.isEmpty {
            return Formatter.currency.string(from: NSNumber(value: 0))
        } else {
            return Formatter.currency.string(from: NSNumber(value: (Double(self) ?? 0) / 100))
        }
    }
    
    
    func extractDigitsToString() -> String{
        
        var number = ""
        
        for char in self {
            if char.isNumber {
                number += String(char)
            }
        }
        
        return number
    }
    
    func extractDigitsToDouble() -> Double{
        let numberString = self.extractDigitsToString()
        
        return (Double(numberString) ?? 0)/100
        
    }
}
