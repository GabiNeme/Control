//
//  IconImage.swift
//  Control
//
//  Created by Gabriela Neme on 12/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit


enum imageType {
    case SFSymbol, external
}

struct IconImage {

    var type: imageType
    var name: String
    
    func getImage() -> UIImage? {
        if type == .SFSymbol {
            return UIImage(systemName: name)
        }else{
            return UIImage(named: name)
        }
    }
    
}


