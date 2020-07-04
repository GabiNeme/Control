//
//  CampoNaoPreenchido.swift
//  Control
//
//  Created by Gabriela Neme on 01/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

struct EmptyRequiredField {
    
    func animateField(uiView: UIView){
        UIView.transition(with: uiView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            uiView.backgroundColor = UIColor.red
        }, completion: nil)
        UIView.transition(with: uiView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            uiView.backgroundColor = UIColor.systemBackground
        }, completion: nil)
        
    }
}
