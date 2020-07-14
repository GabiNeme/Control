//
//  Conta.swift
//  Control
//
//  Created by Gabriela Neme on 01/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import Foundation

struct Account: Codable {
    
    let name: String
    let balance: Double
    let savings: Double
    let free: Double
    let iconType: String
    let iconImage: String
    let iconColor: String
    let addToTotal: Bool
    
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case balance
        case savings
        case free
        case iconType
        case iconImage
        case iconColor
        case addToTotal
    }
    
    
}
