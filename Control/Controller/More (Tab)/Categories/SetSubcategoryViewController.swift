//
//  SetSubcategoryViewController.swift
//  Control
//
//  Created by Gabriela Neme on 23/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit
import RealmSwift

protocol setSubcategoryDelegate {
    func subcategoryDataChaged()
}

class SetSubcategoryViewController: UIViewController {

    @IBOutlet weak var closeBarButton: UIButton!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var subcategoryNameTextField: UITextField!

    @IBOutlet weak var iconUIButton: UIButton!
    @IBOutlet weak var topIconImageView: UIImageView!

    @IBOutlet weak var parentCategoriesCollectionView: UICollectionView!
    
    private var iconImage = IconImage(type: .SFSymbol, name: "questionmark")

    var parentCategory: Category!
    var editingSubcategory: Subcategory?

    var delegate: setSubcategoryDelegate!

    let realm = try! Realm()
    var categories: Results<Category>?
    var selectedCategoryIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false 
        view.addGestureRecognizer(tap)

        closeBarButton.layer.cornerRadius = 2.5
        iconUIButton.layer.cornerRadius = 50

        let toolbar = KeyboardToolBar(width: view.frame.size.width, target: self, selector: #selector(doneButtonAction)).get()
        subcategoryNameTextField.inputAccessoryView = toolbar
        
        configureCollectionView()
       
        loadCategory()
    }
    
    func configureCollectionView(){
        parentCategoriesCollectionView.register(CategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        parentCategoriesCollectionView.dataSource = self
        parentCategoriesCollectionView.delegate = self
        categories = realm.objects(Category.self).filter(NSPredicate(format: "privateType = %@", parentCategory.type.rawValue)).sorted(byKeyPath: "name")
        
        if let index = categories?.index(of: parentCategory) {
            let indexPath = IndexPath(row: index, section: 0)
            selectedCategoryIndex = index
            
            parentCategoriesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            //parentCategoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        parentCategoriesCollectionView.allowsMultipleSelection = false
    }
    
    let editingContentView = EditingContentView()
    
    @IBAction func categoryIconPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        editingContentView.showIconSelector(viewController: self, selectedImage: iconImage, selectedColor: "", onlyImage: true)
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

extension SetSubcategoryViewController{

    @IBAction func saveSubcategoryPressed(_ sender: UIButton) {

        guard let existingDelegate = delegate else {
            fatalError("Category delegate not set")
        }
        
        guard let index = selectedCategoryIndex, let selectedCategory = categories?[index] else {
            fatalError("Selected category doesnt exist")
        }

        if subcategoryNameTextField.text == nil || subcategoryNameTextField.text == "" {

            let alert = Alert(title: "Preencher nome da subcategoria", message: "A subcategoria não pode ser criada sem um nome").get()
            present(alert, animated: true, completion: nil)

            return
        }

            
        let subcategoryName = subcategoryNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let newSubcategory = Subcategory(name: subcategoryName, iconImage: iconImage)
        
        //If editing category
        if let subcategory = editingSubcategory {
            if subcategoryName != subcategory.name && CategoryModel().subcategoryNameUsed(parentCategory: selectedCategory, subcategoryName: subcategoryName){
                showRepeatedNameAlert()
                return
            } else {
                if selectedCategory.name != parentCategory.name {
                    CategoryModel().changeParentCategory(oldSubcategory: subcategory, newSubcategory: newSubcategory, to: selectedCategory)
                }else{
                    subcategory.edit(newSubcategory: newSubcategory)
                }
            }
            
        //if new category
        } else{
            if CategoryModel().subcategoryNameUsed(parentCategory: selectedCategory, subcategoryName: subcategoryName){
                showRepeatedNameAlert()
                return
            }else{
                CategoryModel().addSubcategory(category: selectedCategory, subcategory: newSubcategory)
            }
        }

        dismiss(animated: true, completion: nil)
        existingDelegate.subcategoryDataChaged()
    }


    func showRepeatedNameAlert(){
        let alert = Alert(title: "Nome da subcategoria repetido", message: "Já existe uma subcategoria com esse nome nessa categoria. Por favor, escolha outro nome.").get()
        present(alert, animated: true, completion: nil)
    }
    
}


//MARK: - Editing existing subcategory

extension SetSubcategoryViewController {
    func loadCategory(){

        if let subCategory = editingSubcategory {
            titleLabel.text = "Editar subcategoria"

            subcategoryNameTextField.text = subCategory.name
            iconImage = IconImage(typeString: subCategory.iconType, name: subCategory.iconImage)
        }

        iconUIButton.backgroundColor = UIColor(named: parentCategory.iconColor)
        updateIcon()
    }
}

//MARK: - Icon image


extension SetSubcategoryViewController : IconSelectorDelegate {
    func iconColorSelected(color: String) {
        
    }
    
    func iconImageSelected(image: IconImage) {
        iconImage = image
        updateIcon()
    }
    
    func updateIcon(){
        topIconImageView.image = iconImage.getImage()
    }
}


extension SetSubcategoryViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell{
            cell.select()
        }
        
        if let category = categories?[indexPath.row]{
            iconUIButton.backgroundColor = UIColor(named: category.iconColor)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            cell.deselect()
        }
    }
}

extension SetSubcategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        if let category = categories?[indexPath.row]{
            cell.categoryNameLabel.text = category.name
            
            cell.iconImageView.image = IconImage(typeString: category.iconType, name: category.iconImage).getImage()
            cell.iconColorImageView.backgroundColor = UIColor(named: category.iconColor)
            
            if selectedCategoryIndex == indexPath.row {
                cell.select()
            }else{
                cell.deselect()
            }
        }
        
        return cell
    }
    
}
