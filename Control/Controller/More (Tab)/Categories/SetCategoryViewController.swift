//
//  SetCategoryViewController.swift
//  Control
//
//  Created by Gabriela Neme on 20/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//


import UIKit

protocol setCategoryDelegate {
    func categoryDataChaged(categoryName: String, iconImage: IconImage, iconColor: String)
}

class SetCategoryViewController: UIViewController {

    @IBOutlet weak var closeBarButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmCategoryButton: UIButton!
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    
    @IBOutlet weak var iconUIButton: UIButton!
    @IBOutlet weak var topIconImageView: UIImageView!
    @IBOutlet weak var iconColorImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
 
        
    var UItitle: String = "Categoria"
    
    var iconImage = IconImage(type: .SFSymbol, name: "questionmark")
    var iconColor: String = "gray4"
    
    var categoryName: String = ""
    
    var delegate: setCategoryDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        closeBarButton.layer.cornerRadius = 2.5
        iconUIButton.layer.cornerRadius = 50
        iconColorImageView.layer.cornerRadius = 20
        titleLabel.text = UItitle
        
        let toolbar = KeyboardToolBar(width: view.frame.size.width, target: self, selector: #selector(doneButtonAction)).get()
        categoryNameTextField.inputAccessoryView = toolbar
        
        loadCategory()
    }
    

    @IBAction func categoryIconPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        performSegue(withIdentifier: "selectIconImage", sender: self)
    }
    @IBAction func iconImageTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        performSegue(withIdentifier: "selectIconImage", sender: self)
    }
    @IBAction func iconColorTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        performSegue(withIdentifier: "selectIconColor", sender: self)
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

extension SetCategoryViewController{
    
    @IBAction func confirmCategoryPressed(_ sender: UIButton) {

        
        if categoryNameTextField.text == nil || categoryNameTextField.text == "" {
            
            let alert = Alert(title: "Preencher nome da categoria", message: "A categoria não pode ser criada sem um nome").get()
            present(alert, animated: true, completion: nil)
            
            return
        }
        
       
        
        guard let existingDelegate = delegate else {
            fatalError("Category delegate not set")
        }
        
        dismiss(animated: true, completion: nil)
        existingDelegate.categoryDataChaged(categoryName: categoryNameTextField.text!, iconImage: iconImage, iconColor: iconColor)
        
        
    }
    
    
}


//MARK: - Editing existing account

extension SetCategoryViewController {
    func loadCategory(){
        categoryNameTextField.text = categoryName
        updateIconColor()
        updateIconImage()
    }
}


    

//MARK: - Icon color and image

extension SetCategoryViewController {
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


extension SetCategoryViewController : IconImageSelectorDelegate {
    func iconImageSelected(image: IconImage) {
        iconImage = image
        updateIconImage()
        
    }
    
    func updateIconImage(){
        topIconImageView.image = iconImage.getImage()
        iconImageView.image = iconImage.getImage()
    }
}

extension SetCategoryViewController: IconColorSelectorDelegate {
    func iconColorSelected(color: String) {
        iconColor = color
        updateIconColor()
    }
    
    func updateIconColor(){
        iconUIButton.backgroundColor = UIColor(named: iconColor)
        iconColorImageView.backgroundColor = UIColor(named: iconColor)
    }
    
}

