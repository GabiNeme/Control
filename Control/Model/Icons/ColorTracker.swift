//
//  ColorTracker.swift
//  Control
//
//  Created by Gabriela Neme on 13/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

struct ColorTracker {
    
    
    func getColor(index: Int) -> UIColor? {
        let color = UIColor(named: colors[index])
        return color
    }
    
    func getName(index: Int) -> String {
        return colors[index]
    }
    
    var colorsCount: Int{
        return colors.count
    }
    
    
    private var colors = [
        "purple1",
        "purple2",
        "purple3",
        "purple4",
        "blue1",
        "blue2",
        "blue3",
        "blue4",
        "aqua1",
        "aqua2",
        "aqua3",
        "aqua4",
        "green1",
        "green2",
        "green3",
        "green4",
        "yellow1",
        "yellow2",
        "yellow3",
        "yellow4",
        "orange1",
        "orange2",
        "orange3",
        "orange4",
        "red1",
        "red2",
        "red3",
        "red4",
        "pink1",
        "pink2",
        "pink3",
        "pink4",
        "dark-gray1",
        "dark-gray2",
        "dark-gray3",
        "dark-gray4",
        "gray1",
        "gray2",
        "gray3",
        "gray4"
        
    ]
    
}
