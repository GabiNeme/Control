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
        iconUIButton.layer.cornerRadius = 50
        
        let toolbar = KeyboardToolBar(width: view.frame.size.width, target: self, selector: #selector(doneButtonAction)).get()
        savingNameTextField.inputAccessoryView = toolbar
        goalValueTextField.inputAccessoryView = toolbar
        
        updateIcon()
        
    }
    
    let editingContentView = EditingContentView()
    
    @IBAction func iconPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        editingContentView.show()
        editingContentView.addIconSelector(viewController: self)
        //performSegue(withIdentifier: "setIcon", sender: self)
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

        if savingNameTextField.text == nil || savingNameTextField.text == "" {

            let alert = Alert(title: "Preencher nome da reserva", message: "A reserva não pode ser criada sem um nome").get()
            present(alert, animated: true, completion: nil)

            return
        }

        if savingNameInUse() {
            let alert = Alert(title: "Nome da conta repetido", message: "Já existe uma conta com esse nome, favor escolher um novo nome.").get()
            present(alert, animated: true, completion: nil)

            return
        }

        if goalValueTextField.text == nil || goalValueTextField.text == "" {
            goalValueTextField.text = "0.00"
        }

        guard let existingDelegate = delegate else {
            fatalError("savingsDelegate not set")
        }
        
        let newSaving = Saving(
            name: savingNameTextField.text!,
            savingGoal: goalValueTextField.text!.extractDigitsToDouble(),
            iconImage: iconImage,
            iconColor: iconColor
        )
        
        if let modifiedSaving = editingSaving {
            newSaving.saved = modifiedSaving.saved
            modifiedSaving.edit(changeTo: newSaving)
        }else{
            newSaving.save()
        }

        existingDelegate.savingDataChaged()
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func savingNameInUse() -> Bool {
        let currentName = savingNameTextField.text!
        let nameExistsInDatabase = AccountsModel().accountNameUsed(accountName: currentName)

        //if account is being edited
        if let existingSaving = editingSaving {
            if currentName == existingSaving.name {
                return false
            }
        }
        return nameExistsInDatabase
    }
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
