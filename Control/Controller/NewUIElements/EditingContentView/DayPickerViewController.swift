//
//  DayPickerView.swift
//  Control
//
//  Created by Gabriela Neme on 28/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

protocol DayPickerDelegate {
    func daySelected(day: Int)
}

class DayPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let days = Array(1...31)
    
    var delegate: DayPickerDelegate!
    var selectedDay: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        let UIPicker: UIPickerView = UIPickerView()
        
        UIPicker.delegate = self as UIPickerViewDelegate
        UIPicker.dataSource = self as UIPickerViewDataSource
        
        self.view.addSubview(UIPicker)
        

        UIPicker.translatesAutoresizingMaskIntoConstraints = false
        UIPicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        UIPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        UIPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        UIPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        
        UIPicker.selectRow(selectedDay - 1, inComponent: 0, animated: true)
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return UIScreen.main.bounds.width
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return days.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = String(days[row])
        return row
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate.daySelected(day: days[row])
    }
}
