//
//  CurrencyTextField.swift
//  Control
//
//  Created by Gabriela Neme on 05/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

class CurrencyTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    @objc func editingChanged() {
        
        guard let currentText = text else {return}
        
        let currentNumbers = currentText.extractDigitsToString()
        text = currentNumbers.asCurrency()
 
    }
    
}
