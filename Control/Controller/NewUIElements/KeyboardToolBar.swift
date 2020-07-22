//
//  KeyboardToolBar.swift
//  Control
//
//  Created by Gabriela Neme on 20/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

struct KeyboardToolBar {
    
    var width: CGFloat
    var target: Any
    var selector: Selector
    
    func get() -> UIToolbar {
        
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: width, height: 30)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(title: "OK", style: .done, target: target, action: selector)
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        return toolbar
        
    }
    
    
}
