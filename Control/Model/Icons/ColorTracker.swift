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
        let color = UIColor(hexString: colors[index])
        return color
    }
    
    func getHex(index: Int) -> String {
        return colors[index]
    }
    
    var colorsCount: Int{
        return colors.count
    }
    
    
    private var colors = [
        "#a29bfe",
        "#6c5ce7",
        "#9b59b6",
        "#8e44ad",
        "#74b9ff",
        "#0984e3",
        "#3498db",
        "#2980b9",
        "#81ecec",
        "#00cec9",
        "#1abc9c",
        "#16a085",
        "#55efc4",
        "#00b894",
        "#2ecc71",
        "#27ae60",
        "#ffeaa7",
        "#fdcb6e",
        "#f1c40f",
        "#f39c12",
        "#fab1a0",
        "#e17055",
        "#e67e22",
        "#d35400",
        "#ff7675",
        "#d63031",
        "#e74c3c",
        "#c0392b",
        "#fd79a8",
        "#e84393",
        "#ef5777",
        "#f53b57",
        "#636e72",
        "#34495e",
        "#2c3e50",
        "#2d3436",
        "#ecf0f1",
        "#dfe6e9",
        "#b2bec3",
        "#bdc3c7",
        
    ]
    
}
