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
    @IBOutlet weak var currentBalance: UITextField!
    @IBOutlet weak var addAccountButton: UIButton!

    @IBOutlet weak var iconUIButton: UIButton!
    @IBOutlet weak var topIconImage: UIImageView!
    @IBOutlet weak var iconColor: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    
    
    @IBOutlet weak var iconColorStackView: UIStackView!
    @IBOutlet weak var iconImageStackView: UIStackView!
    
    
    var delegate: AddNewAccountDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        closeBarButton.layer.cornerRadius = 2.5
        topIconImage.layer.cornerRadius = 50
        iconColor.layer.cornerRadius = 20
        
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
//        if accountName.text != "" && currentBalance.text != ""{
//
//            guard let delegateSender = delegate else {
//                print("Delegate method to create new account not set")
//                return
//            }
//
//            let newAccount = Account(name: accountName.text!, balance: currentBalance.text!.extractDigitsToDouble())
//
//            delegateSender.newAccountCreated(account: newAccount)
//            dismiss(animated: true, completion: nil)
//        }
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

}

extension AddNewAccountViewController : IconImageSelectorDelegate {
    func iconImageSelected(image: IconImage) {
        topIconImage.image = image.getImage()
        iconImage.image = image.getImage()
    }
}

extension AddNewAccountViewController: IconColorSelectorDelegate {
    func iconColorSelected(color: UIColor?) {
        topIconImage.backgroundColor = color
        iconColor.backgroundColor = color
    }
    
    
    
}
