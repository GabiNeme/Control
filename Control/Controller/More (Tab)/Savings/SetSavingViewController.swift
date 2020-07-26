//
//  SetSavingViewController.swift
//  Control
//
//  Created by Gabriela Neme on 25/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

protocol setSavingDelegate {
    func savingDataChaged()
}

class SetSavingViewController: UIViewController {

    @IBOutlet weak var closeBarButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var savingNameTextField: UITextField!
    @IBOutlet weak var goalValueTextField: UITextField!
    
    @IBOutlet weak var iconUIButton: UIButton!
    @IBOutlet weak var ringImageView: UIImageView!
    @IBOutlet weak var topIconImageView: UIImageView!
        
    //Account Elements
    var iconImage = IconImage(type: .SFSymbol, name: "questionmark")
    var iconColor: String = "gray4"
    
    var editingSaving: Saving?
    
    var delegate: setSavingDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        closeBarButton.layer.cornerRadius = 2.5
        iconUIButton.layer.cornerRadius = 55
        ringImageView.layer.cornerRadius = 50
        ringImageView.layer.borderWidth = 5
        ringImageView.layer.borderColor = UIColor(named: "BackgroundColor")?.cgColor
        
        let toolbar = KeyboardToolBar(width: view.frame.size.width, target: self, selector: #selector(doneButtonAction)).get()
        savingNameTextField.inputAccessoryView = toolbar
        goalValueTextField.inputAccessoryView = toolbar
        
        updateIcon()
        
    }
    

    @IBAction func iconPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        performSegue(withIdentifier: "setIcon", sender: self)
    }
    
    @IBAction func cancelBottomButtonPressed(_ sender: UIButton) {
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

extension SetSavingViewController{
    
    @IBAction func saveSavingPressed(_ sender: UIButton) {

//
//        if savingNameTextField.text == nil || savingNameTextField.text == "" {
//
//            let alert = Alert(title: "Preencher nome da conta", message: "A conta não pode ser criada sem um nome").get()
//            present(alert, animated: true, completion: nil)
//
//            return
//        }
//
//        if accountNameInUse() {
//            let alert = Alert(title: "Nome da conta repetido", message: "Já existe uma conta com esse nome, favor escolher um novo nome.").get()
//            present(alert, animated: true, completion: nil)
//
//            return
//        }
//
//        if goalValueTextField.text == nil || goalValueTextField.text == "" {
//            goalValueTextField.text = "0.00"
//        }
//
//        guard let existingDelegate = delegate else {
//            fatalError("newAccountAddedDelegate not set")
//        }
//
//        let newAccount = Account(
//            name: savingNameTextField.text!,
//            balance: goalValueTextField.text!.extractDigitsToDouble(),
//            iconImage: iconImage,
//            iconColor: iconColor,
//            addToTotal: addToTotalSwitch.isOn
//        )
//
//        if let modifiedAccount = editingAccount {
//            newAccount.savings = modifiedAccount.savings
//            newAccount.available = newAccount.balance - modifiedAccount.savings
//            newAccount.listPosition = modifiedAccount.listPosition
//            modifiedAccount.edit(changeTo: newAccount)
//        }else{
//            newAccount.save()
//        }
//
//        existingDelegate.accountDataChaged()
        dismiss(animated: true, completion: nil)
        
    }
    
    
//    func accountNameInUse() -> Bool {
//        let currentName = savingNameTextField.text!
//        let nameExistsInDatabase = AccountsModel().accountNameUsed(accountName: currentName)
//
//        //if account is being edited
//        if let existingAccount = editingAccount {
//            if currentName == existingAccount.name {
//                return false
//            }
//        }
//        return nameExistsInDatabase
//    }
}


//MARK: - Editing existing account

extension SetSavingViewController {
    func loadSaving(){
        
        if let saving = editingSaving {
            descriptionLabel.text = "Editar reserva"
            
            iconImage = IconImage(typeString: saving.iconType, name: saving.iconImage)
            iconColor = saving.iconColor
            
            savingNameTextField.text = saving.name
        }
        
        updateIcon()
    }
}


    

//MARK: - Icon color and image

extension SetSavingViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setIcon" {
            let destinationSegue = segue.destination as! IconViewController
            destinationSegue.delegate = self
            destinationSegue.selectedImage = iconImage
            destinationSegue.selectedColor = iconColor
        }
    }
}


extension SetSavingViewController : IconSelectorDelegate {
    func iconSelected(color: String, image: IconImage) {
        iconColor = color
        iconImage = image
        updateIcon()
    }
    
    func updateIcon(){
        iconUIButton.backgroundColor = UIColor(named: iconColor)
        topIconImageView.image = iconImage.getImage()
    }
}
