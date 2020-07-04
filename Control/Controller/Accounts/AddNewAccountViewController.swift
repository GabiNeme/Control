//
//  CriarNovaContaViewController.swift
//  Control
//
//  Created by Gabriela Neme on 01/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

protocol AddNewAccountDelegate {
    func newAccountCreated(account: Account)
}

class AddNewAccountViewController: UIViewController {

    @IBOutlet weak var closeBarButton: UIButton!
    @IBOutlet weak var accountName: UITextField!
    @IBOutlet weak var currentBalance: UITextField!
    @IBOutlet weak var addAccountButton: UIButton!
    
    @IBOutlet weak var nameFieldView: UIView!
    @IBOutlet weak var balanceFieldView: UIView!
    
    var delegate: AddNewAccountDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeBarButton.layer.cornerRadius = 2.5
        accountName.layer.cornerRadius = 10
        currentBalance.layer.cornerRadius = 10
        addAccountButton.layer.cornerRadius = 10
    }
    

    @IBAction func createNewAccountPressed(_ sender: UIButton) {

        
        if accountName.text == nil || accountName.text == "" {
            EmptyRequiredField().animateField(uiView: nameFieldView)
        }
        if currentBalance.text == nil || currentBalance.text == "" {
            EmptyRequiredField().animateField(uiView: balanceFieldView)
        }
        
        if accountName.text != "" && currentBalance.text != ""{

            guard let delegateSender = delegate else {
                print("Delegate method to create new account not set")
                return
            }

            let newAccount = Account(name: accountName.text!, balanceString: currentBalance.text!)

            delegateSender.newAccountCreated(account: newAccount)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeBarButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
