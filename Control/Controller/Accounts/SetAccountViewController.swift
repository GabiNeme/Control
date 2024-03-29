//
//  CriarNovaContaViewController.swift
//  Control
//
//  Created by Gabriela Neme on 01/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

protocol setAccountDelegate {
    func accountDataChaged()
}

class SetAccountViewController: UIViewController {

    @IBOutlet weak var closeBarButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var currentBalanceTextField: UITextField!
    @IBOutlet weak var addToTotalSwitch: UISwitch!
    
    @IBOutlet weak var iconUIButton: UIButton!
    @IBOutlet weak var topIconImageView: UIImageView!
        
    //Account Elements
    var iconImage = IconImage(type: .SFSymbol, name: "questionmark")
    var iconColor: String = "gray4"
    
    var editingAccount: Account?
    
    var delegate: setAccountDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        closeBarButton.layer.cornerRadius = 2.5
        iconUIButton.layer.cornerRadius = 50
        
        let toolbar = KeyboardToolBar(width: view.frame.size.width, target: self, selector: #selector(doneButtonAction)).get()
        accountNameTextField.inputAccessoryView = toolbar
        currentBalanceTextField.inputAccessoryView = toolbar
        
        loadAccount()
    }
    
    let editingContentView = EditingContentView()
    
    @IBAction func accountIconPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        editingContentView.showIconSelector(viewController: self, selectedImage: iconImage, selectedColor: iconColor)
    }
    
    @IBAction func closeBottomButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBarButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
}


//MARK: - Confirm button pressed

extension SetAccountViewController{
    
    @IBAction func createNewAccountPressed(_ sender: UIButton) {

        
        if accountNameTextField.text == nil || accountNameTextField.text == "" {
            
            let alert = Alert(title: "Preencher nome da conta", message: "A conta não pode ser criada sem um nome").get()
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        if accountNameInUse() {
            let alert = Alert(title: "Nome da conta repetido", message: "Já existe uma conta com esse nome, favor escolher um novo nome.").get()
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        if currentBalanceTextField.text == nil || currentBalanceTextField.text == "" {
            currentBalanceTextField.text = "0.00"
        }
        
        guard let existingDelegate = delegate else {
            fatalError("newAccountAddedDelegate not set")
        }
        
        let newAccount = Account(
            name: accountNameTextField.text!,
            balance: currentBalanceTextField.text!.extractDigitsToDouble(),
            iconImage: iconImage,
            iconColor: iconColor,
            addToTotal: addToTotalSwitch.isOn
        )
        
        if let modifiedAccount = editingAccount {
            newAccount.savings = modifiedAccount.savings
            newAccount.available = newAccount.balance - modifiedAccount.savings
            newAccount.listPosition = modifiedAccount.listPosition
            modifiedAccount.edit(changeTo: newAccount)
        }else{
            newAccount.save()
        }

        existingDelegate.accountDataChaged()
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func accountNameInUse() -> Bool {
        let currentName = accountNameTextField.text!
        let nameExistsInDatabase = ObjectsModel().nameUsed(Account.self, name: currentName)
        
        //if account is being edited
        if let existingAccount = editingAccount {
            if currentName == existingAccount.name {
                return false
            }
        }
        return nameExistsInDatabase
    }
}


//MARK: - Editing existing account

extension SetAccountViewController {
    func loadAccount(){
        
        if let account = editingAccount {
            descriptionLabel.text = "Editar conta"
            
            iconImage = IconImage(typeString: account.iconType, name: account.iconImage)
            iconColor = account.iconColor
            
            accountNameTextField.text = account.name
            currentBalanceTextField.text = account.balance.toCurrency()
            addToTotalSwitch.isOn = account.addToTotal
        }
        
        updateIcon()
    }
}




//MARK: - Icon color and image

extension SetAccountViewController : IconSelectorDelegate {
    func iconColorSelected(color: String) {
        iconColor = color
        updateIcon()
    }
    
    func iconImageSelected(image: IconImage) {
        iconImage = image
        updateIcon()
    }
    
    func updateIcon(){
        iconUIButton.backgroundColor = UIColor(named: iconColor)
        topIconImageView.image = iconImage.getImage()
    }
}
