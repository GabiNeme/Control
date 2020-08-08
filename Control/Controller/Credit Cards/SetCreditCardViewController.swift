//
//  SetCreditCardViewController.swift
//  Control
//
//  Created by Gabriela Neme on 28/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//


import UIKit

protocol setCreditCardDelegate {
    func creditCardDataChaged()
}

enum Days {
    case closing, due
}

class SetCreditCardViewController: UIViewController {

    @IBOutlet weak var closeBarButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var creditNameTextField: UITextField!
    @IBOutlet weak var limitTextField: UITextField!
    
    @IBOutlet weak var closingDayButton: UIButton!
    @IBOutlet weak var dueDayButton: UIButton!
    
    @IBOutlet weak var iconUIButton: UIButton!
    @IBOutlet weak var topIconImageView: UIImageView!
        
    //Account Elements
    var iconImage = IconImage(type: .SFSymbol, name: "questionmark")
    var iconColor: String = "gray4"
    
    var editingCreditCard: CreditCard?
    var editingDay: Days = .closing
    
    var delegate: setCreditCardDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        closeBarButton.layer.cornerRadius = 2.5
        iconUIButton.layer.cornerRadius = 50
        
        let toolbar = KeyboardToolBar(width: view.frame.size.width, target: self, selector: #selector(doneButtonAction)).get()
        creditNameTextField.inputAccessoryView = toolbar
        limitTextField.inputAccessoryView = toolbar
        
        loadCreditCard()
    }
    
    let editingContentView = EditingContentView()
    
    @IBAction func creditCardIconPressed(_ sender: UIButton) {
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


//MARK: - Select day - day picker
extension SetCreditCardViewController: DayPickerDelegate {
    func daySelected(day: Int) {
        if editingDay == .closing {
            closingDayButton.setTitleColor(UIColor(named: "LabelColor"), for: .normal)
            closingDayButton.setTitle(String(day), for: .normal)
        }else  if editingDay == .due {
            dueDayButton.setTitleColor(UIColor(named: "LabelColor"), for: .normal)
            dueDayButton.setTitle(String(day), for: .normal)
            
        }
    }
    
    @IBAction func closingDaySelected(_ sender: UIButton) {
        self.view.endEditing(true)
        editingDay = .closing
        if let day = Int((closingDayButton.titleLabel?.text)!) {
            editingContentView.showDaySelector(viewController: self, daySelected: day)
        } else {
            editingContentView.showDaySelector(viewController: self, daySelected: 1)
        }
    }
    
    @IBAction func dueDaySelected(_ sender: UIButton) {
        self.view.endEditing(true)
        editingDay = .due
        if let day = Int((dueDayButton.titleLabel?.text)!) {
            editingContentView.showDaySelector(viewController: self, daySelected: day)
        } else {
            editingContentView.showDaySelector(viewController: self, daySelected: 1)
        }
    }
    
}

//MARK: - Confirm button pressed

extension SetCreditCardViewController{
    
    @IBAction func saveCreditCardPressed(_ sender: UIButton) {


        if creditNameTextField.text == nil || creditNameTextField.text == "" {

            let alert = Alert(title: "Preencher nome do cartão de crédito", message: "O cartão de crédito não pode ser criado sem um nome").get()
            present(alert, animated: true, completion: nil)

            return
        }

        if creditCardNameInUse() {
            let alert = Alert(title: "Nome da cartão repetido repetido", message: "Já existe uma conta com esse nome, favor escolher um novo nome.").get()
            present(alert, animated: true, completion: nil)

            return
        }

        if limitTextField.text == nil || limitTextField.text == "" {
            let alert = Alert(title: "Limite não preenchido", message: "Favor preencher o limite do cartão de crédito.").get()
            present(alert, animated: true, completion: nil)

            return
        }
        
        if Int((closingDayButton.titleLabel?.text)!) == nil {
            let alert = Alert(title: "Dia de fechamento não preenchido", message: "Favor preencher o dia de fechamento do cartão de crédito.").get()
            present(alert, animated: true, completion: nil)

            return
        }
        if Int((dueDayButton.titleLabel?.text)!) == nil {
            let alert = Alert(title: "Dia de vencimento não preenchido", message: "Favor preencher o dia de vencimento do cartão de crédito.").get()
            present(alert, animated: true, completion: nil)

            return
        }
        

        guard let existingDelegate = delegate else {
            fatalError("newAccountAddedDelegate not set")
        }
        
        let newCreditCard = CreditCard(
            name: creditNameTextField.text!,
            limit: limitTextField.text!.extractDigitsToDouble(),
            closingDay: Int((closingDayButton.titleLabel?.text)!)!,
            dueDay: Int((dueDayButton.titleLabel?.text)!)!,
            iconImage: iconImage,
            iconColor: iconColor
        )


        if let modifiedCreditCard = editingCreditCard{
            newCreditCard.availableLimit = modifiedCreditCard.availableLimit
            modifiedCreditCard.edit(changeTo: newCreditCard)
        }else{
            newCreditCard.save()
        }

        existingDelegate.creditCardDataChaged()
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func creditCardNameInUse() -> Bool {
        let currentName = creditNameTextField.text!
        let nameExistsInDatabase = ObjectsModel().nameUsed(CreditCard.self, name: currentName)

        //if account is being edited
        if let existingAccount = editingCreditCard {
            if currentName == existingAccount.name {
                return false
            }
        }
        return nameExistsInDatabase
    }
}


//MARK: - Editing existing account

extension SetCreditCardViewController {
    func loadCreditCard(){
        
        if let creditCard = editingCreditCard {
            descriptionLabel.text = "Editar cartão de crédito"
            
            iconImage = IconImage(typeString: creditCard.iconType, name: creditCard.iconImage)
            iconColor = creditCard.iconColor
            
            creditNameTextField.text = creditCard.name
            limitTextField.text = creditCard.limit.toCurrency()
       
            
            closingDayButton.tintColor = UIColor(named: "LabelColor")
            closingDayButton.setTitle(String(creditCard.closingDay), for: .normal)
            
            dueDayButton.tintColor = UIColor(named: "LabelColor")
            dueDayButton.setTitle(String(creditCard.dueDay), for: .normal)
            
            
        }
        
        updateIcon()
    }
}




//MARK: - Icon color and image

extension SetCreditCardViewController : IconSelectorDelegate {
    func iconColorSelected(color: String) {
        iconColor = color
        updateIcon()
    }
    
    func iconImageSelected(image: IconImage) {
        iconImage = image
        updateIcon()
    }
    
    func updateIcon(){
        iconUIButton.tintColor = UIColor(named: iconColor)
        topIconImageView.image = iconImage.getImage()
    }
}
