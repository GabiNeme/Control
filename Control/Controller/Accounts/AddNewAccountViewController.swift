//
//  CriarNovaContaViewController.swift
//  Control
//
//  Created by Gabriela Neme on 01/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

protocol newAccountAddedDelegate {
    func newAccountAdded()
}

class AddNewAccountViewController: UIViewController {

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
    var delegate: newAccountAddedDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        updateIconImage()
        updateIconColor()
        
        closeBarButton.layer.cornerRadius = 2.5
        iconUIButton.layer.cornerRadius = 50
        iconColorImageView.layer.cornerRadius = 20
        
        let tapIconColor = UITapGestureRecognizer(target: self, action: #selector(iconColorTapped))
        iconColorStackView.addGestureRecognizer(tapIconColor)
        
        let tapIconImage = UITapGestureRecognizer(target: self, action: #selector(iconImageTapped))
        iconImageStackView.addGestureRecognizer(tapIconImage)
        

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
    
    @IBAction func createNewAccountPressed(_ sender: UIButton) {

        
//        if accountName.text == nil || accountName.text == "" {
//            EmptyRequiredField().animateField(uiView: nameFieldView)
//        }
//        if currentBalance.text == nil || currentBalance.text == "" {
//            EmptyRequiredField().animateField(uiView: balanceFieldView)
//        }
//
        
        if accountNameTextField.text != "" && currentBalanceTextField.text != ""{


            let newAccount = Account(
                name: accountNameTextField.text!,
                balance: currentBalanceTextField.text!.extractDigitsToDouble(),
                iconImage: iconImage,
                iconColor: iconColor,
                addToTotal: addToTotalSwitch.isOn
            )
            
            newAccount.save()
            
            guard let existingDelegate = delegate else {
                fatalError("newAccountAddedDelegate not set")
            }
            
            existingDelegate.newAccountAdded()
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeBottomButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBarButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectIconImage" {
            let destinationSegue = segue.destination as! IconImageViewController
            destinationSegue.delegate = self
        }else if segue.identifier == "selectIconColor" {
            let destinationSegue = segue.destination as! IconColorViewController
            destinationSegue.delegate = self
            
        }
    }
    
    func updateIconImage(){
        topIconImageView.image = iconImage.getImage()
        iconImageView.image = iconImage.getImage()
    }
    
    func updateIconColor(){
        iconUIButton.backgroundColor = UIColor(named: iconColor)
        iconColorImageView.backgroundColor = UIColor(named: iconColor)
    }

}

extension AddNewAccountViewController : IconImageSelectorDelegate {
    func iconImageSelected(image: IconImage) {
        iconImage = image
        updateIconImage()
        
    }
}

extension AddNewAccountViewController: IconColorSelectorDelegate {
    func iconColorSelected(color: String) {
        iconColor = color
        updateIconColor()
    }
    
    
    
}
