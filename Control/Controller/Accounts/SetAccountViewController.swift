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
    @IBOutlet weak var addAccountButton: UIButton!
    
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var currentBalanceTextField: UITextField!
    @IBOutlet weak var addToTotalSwitch: UISwitch!
    
    @IBOutlet weak var iconUIButton: UIButton!
    @IBOutlet weak var topIconImageView: UIImageView!
    @IBOutlet weak var iconColorImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    @IBOutlet weak var iconColorStackView: UIStackView!
    @IBOutlet weak var iconImageStackView: UIStackView!
        
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
        iconColorImageView.layer.cornerRadius = 20
        
        let tapIconColor = UITapGestureRecognizer(target: self, action: #selector(iconColorTapped))
        iconColorStackView.addGestureRecognizer(tapIconColor)
        
        let tapIconImage = UITapGestureRecognizer(target: self, action: #selector(iconImageTapped))
        iconImageStackView.addGestureRecognizer(tapIconImage)
        
        loadAccount()
    }
    

    @IBAction func accountIconPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "selectIconImage", sender: self)
    }
    @objc func iconImageTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "selectIconImage", sender: self)
    }
    
    @objc func iconColorTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "selectIconColor", sender: self)
    }
    
    @IBAction func closeBottomButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBarButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}


//MARK: - Confirm button pressed

extension SetAccountViewController{
    
    @IBAction func createNewAccountPressed(_ sender: UIButton) {

        
        if accountNameTextField.text == nil || accountNameTextField.text == "" {
            let alert = UIAlertController(title: "Preencher nome da conta", message: "A conta não pode ser criada sem um nome", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in })
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
}


//MARK: - Editing existing account

extension SetAccountViewController {
    func loadAccount(){
        
        if let account = editingAccount {
            iconImage = IconImage(typeString: account.iconType, name: account.iconImage)
            iconColor = account.iconColor
            
            accountNameTextField.text = account.name
            currentBalanceTextField.text = account.balance.toCurrency()
            addToTotalSwitch.isOn = account.addToTotal
        }
        
        updateIconColor()
        updateIconImage()
    }
}


    

//MARK: - Icon color and image

extension SetAccountViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectIconImage" {
            let destinationSegue = segue.destination as! IconImageViewController
            destinationSegue.delegate = self
        }else if segue.identifier == "selectIconColor" {
            let destinationSegue = segue.destination as! IconColorViewController
            destinationSegue.delegate = self
            
        }
    }
}


extension SetAccountViewController : IconImageSelectorDelegate {
    func iconImageSelected(image: IconImage) {
        iconImage = image
        updateIconImage()
        
    }
    
    func updateIconImage(){
        topIconImageView.image = iconImage.getImage()
        iconImageView.image = iconImage.getImage()
    }
}

extension SetAccountViewController: IconColorSelectorDelegate {
    func iconColorSelected(color: String) {
        iconColor = color
        updateIconColor()
    }
    
    func updateIconColor(){
        iconUIButton.backgroundColor = UIColor(named: iconColor)
        iconColorImageView.backgroundColor = UIColor(named: iconColor)
    }
    
}
