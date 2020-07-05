//
//  Formatter.swift
//  Control
//
//  Created by Gabriela Neme on 05/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation

extension Formatter {
    
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        return formatter
    }()
    
}
