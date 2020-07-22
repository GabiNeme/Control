//
//  SubcategoriesViewController.swift
//  Control
//
//  Created by Gabriela Neme on 20/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//


import UIKit
import RealmSwift

enum InteractionType {
    case parentCategory, newSubcategory, editSubcategory
}

class SubcategoriesViewController: UIViewController {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var iconColorImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var subcategoriesTableView: UITableView!
    
    let realm = try! Realm()
    var category: Category?
    var subcategories: Results<Subcategory>?
    
    var setCategoryType: InteractionType = .newSubcategory
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subcategoriesTableView.dataSource = self
        subcategoriesTableView.delegate = self
        
        subcategoriesTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        subcategoriesTableView.rowHeight = 50
        
        iconColorImageView.layer.cornerRadius = 25
        
        guard let _ = category else{
            fatalError("Parent category not set")
        }
        
        subcategories = category?.subcategories.sorted(byKeyPath: "name", ascending: true)
        
        loadCategory()
    }
    
    func loadCategory(){
        categoryNameLabel.text = category!.name
        iconImageView.image = IconImage(typeString: category!.iconType, name: category!.iconImage).getImage()
        iconColorImageView.backgroundColor = UIColor(named: category!.iconColor)
        
    }
    
    @IBAction func editCategoryButtonPressed(_ sender: UIButton) {
        setCategoryType = .parentCategory
        performSegue(withIdentifier: "setSubcategory", sender: self)
    }
    

}



extension SubcategoriesViewController: setCategoryDelegate {

    @IBAction func addNewSubcategory(_ sender: UIBarButtonItem) {
        setCategoryType = .newSubcategory
        performSegue(withIdentifier: "setSubcategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setSubcategory" {
            let destinationSegue = segue.destination as! SetCategoryViewController
            destinationSegue.delegate = self
            destinationSegue.UItitle = "Subcategoria"
            
            if setCategoryType == .parentCategory {
                destinationSegue.categoryName = category!.name
                destinationSegue.iconImage = IconImage(typeString: category!.iconType, name: category!.iconImage)
                destinationSegue.iconColor = category!.iconColor
                destinationSegue.UItitle = "Categoria"
            }else if setCategoryType == .editSubcategory {
                if let indexPath = subcategoriesTableView.indexPathForSelectedRow, let subcategory = subcategories?[indexPath.row]{
                    destinationSegue.categoryName = subcategory.name
                    destinationSegue.iconImage = IconImage(typeString: subcategory.iconType, name: subcategory.iconImage)
                    destinationSegue.iconColor = subcategory.iconColor
                }
            }
            
        }
    }
    
    func categoryDataChaged(categoryName: String, iconImage: IconImage, iconColor: String) {
        
        if setCategoryType == .parentCategory{
            if categoryName != category!.name && CategoryModel().categoryNameUsed(categoryName: categoryName){
                let alert = Alert(title: "Nome da categoria repetido", message: "Já existe uma subcategoria com esse nome, não foi possível alterá-la.").get()
                present(alert, animated: true, completion: nil)
                return
            } else {
                category!.edit(name: categoryName, iconImage: iconImage, iconColor: iconColor)
            }
            loadCategory()
        }else if setCategoryType == .newSubcategory {
            if CategoryModel().subcategoryNameUsed(parentCategory: category!, subcategoryName: categoryName){
                let alert = Alert(title: "Nome da subcategoria repetido", message: "Já existe uma subcategoria com esse nome, não foi possível criá-la.").get()
                present(alert, animated: true, completion: nil)
                return
            }
            
            let subcategory = Subcategory(name: categoryName, iconImage: iconImage, iconColor: iconColor)
            CategoryModel().addSubcategory(category: category!, subcategory: subcategory)
        }else if setCategoryType == .editSubcategory {
            if let indexPath = subcategoriesTableView.indexPathForSelectedRow, let subcategory = subcategories?[indexPath.row]{
                if subcategory.name != categoryName && CategoryModel().subcategoryNameUsed(parentCategory: category!, subcategoryName: categoryName){
                    let alert = Alert(title: "Nome da subcategoria repetido", message: "Já existe uma subcategoria com esse nome, não foi possível editá-la.").get()
                    present(alert, animated: true, completion: nil)
                    return
                }
                let newSubcategory = Subcategory(name: categoryName, iconImage: iconImage, iconColor: iconColor)
                subcategory.edit(newSubcategory: newSubcategory)
            }
        }
        
        subcategoriesTableView.reloadData()
    }

    
}


//MARK: - UITableViewDataSource

extension SubcategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = subcategoriesTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell

        if let subcategory = subcategories?[indexPath.row] {
            categoryCell.iconImageView.image = IconImage(typeString: subcategory.iconType, name: subcategory.iconImage).getImage()
            categoryCell.iconColorImageView.backgroundColor = UIColor(named: subcategory.iconColor)


            categoryCell.categoryNameLabel.text = subcategory.name
        }

        
        return categoryCell
    }
}

//MARK: - UITableViewDelegate

extension SubcategoriesViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //if let account1 = categories?[sourceIndexPath.row], let account2 = categories?[destinationIndexPath.row] {
        //    AccountsModel().swapAccounts(account1: account1, account2: account2)
        //}

        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let subcategory = subcategories?[indexPath.row] {
                subcategory.delete()
            }
        }
        subcategoriesTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setCategoryType = .editSubcategory
        performSegue(withIdentifier: "setSubcategory", sender: self)
    }
    
}
