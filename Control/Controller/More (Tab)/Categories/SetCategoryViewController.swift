//
//  SetCategoryViewController.swift
//  Control
//
//  Created by Gabriela Neme on 20/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//


import UIKit
import RealmSwift

protocol setCategoryDelegate {
    func categoryDataChaged()
}

class SetCategoryViewController: UIViewController {

    @IBOutlet weak var closeBarButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    
    @IBOutlet weak var iconUIButton: UIButton!
    @IBOutlet weak var topIconImageView: UIImageView!
    
    private var iconImage = IconImage(type: .SFSymbol, name: "questionmark")
    private var iconColor: String = "gray4"
    
    var editingCategory: Category?
    var categoryType: String?
    
    var delegate: setCategoryDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        closeBarButton.layer.cornerRadius = 2.5
        iconUIButton.layer.cornerRadius = 50
        
        let toolbar = KeyboardToolBar(width: view.frame.size.width, target: self, selector: #selector(doneButtonAction)).get()
        categoryNameTextField.inputAccessoryView = toolbar
        
        loadCategory()
    }
    

    @IBAction func categoryIconPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        performSegue(withIdentifier: "setIcon", sender: self)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
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
    
    @IBAction func saveCategoryPressed(_ sender: UIButton) {

        guard let existingDelegate = delegate else {
            fatalError("Category delegate not set")
        }
        
        if categoryNameTextField.text == nil || categoryNameTextField.text == "" {
            
            let alert = Alert(title: "Preencher nome da categoria", message: "A categoria não pode ser criada sem um nome").get()
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        let categoryName = categoryNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //If editing category
        if let category = editingCategory {
            if categoryName != category.name && CategoryModel().categoryNameUsed(categoryName: categoryName){
                showRepeatedNameAlert()
                return
            } else {
                category.edit(name: categoryName, iconImage: iconImage, iconColor: iconColor)
            }
            
        //if new category
        } else{
            if CategoryModel().categoryNameUsed(categoryName: categoryName){
                showRepeatedNameAlert()
                return
            }else{
                if let type = categoryType {
                    let category = Category(type: type, name: categoryName, iconImage: iconImage, iconColor: iconColor)
                    category.save()
                }
            }
        }

        dismiss(animated: true, completion: nil)
        existingDelegate.categoryDataChaged()
        
        
    }
    
    
    func showRepeatedNameAlert(){
        let alert = Alert(title: "Nome da categoria repetido", message: "Já existe uma categoria com esse nome. Por favor, escolha outro nome.").get()
        present(alert, animated: true, completion: nil)
    }
    
}


//MARK: - Editing existing category or subcategory

extension SetCategoryViewController {
    func loadCategory(){
        
        if let category = editingCategory {
            titleLabel.text = "Editar categoria"
            
            categoryNameTextField.text = category.name
            iconImage = IconImage(typeString: category.iconType, name: category.iconImage)
            iconColor = category.iconColor
        }
        
        updateIcon()
    }
}


    

//MARK: - Icon color and image

extension SetCategoryViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setIcon" {
            let destinationSegue = segue.destination as! IconViewController
            destinationSegue.delegate = self
            destinationSegue.selectedImage = iconImage
            destinationSegue.selectedColor = iconColor
        }
    }
}


extension SetCategoryViewController : IconSelectorDelegate {
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

