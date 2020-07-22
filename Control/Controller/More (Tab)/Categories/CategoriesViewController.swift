//
//  CategoriesViewController.swift
//  Control
//
//  Created by Gabriela Neme on 20/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//


import UIKit
import RealmSwift

class CategoriesViewController: UIViewController {

    @IBOutlet weak var categoriesTableView: UITableView!
    
    let realm = try! Realm()
    var type: String = "expense"
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        
        categoriesTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        categoriesTableView.rowHeight = 50
        
        categories = realm.objects(Category.self).filter(NSPredicate(format: "type = %@", type)).sorted(byKeyPath: "name")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoriesTableView.reloadData()
    }

}

//MARK: - Category Types - expense, income

extension CategoriesViewController {
    
    
    @IBAction func categoryTypeSegmentedControlPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            type = "expense"
        }else{
            type = "income"
        }
        categories = realm.objects(Category.self).filter(NSPredicate(format: "type = %@", type)).sorted(byKeyPath: "name")
        categoriesTableView.reloadData()
    }
    
}


extension CategoriesViewController: setCategoryDelegate {


    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "setCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setCategory" {
            let destinationSegue = segue.destination as! SetCategoryViewController
            destinationSegue.delegate = self
        }else if segue.identifier == "subcategories"{
            let destinationSegue = segue.destination as! SubcategoriesViewController
            
            if let indexPath = categoriesTableView.indexPathForSelectedRow, let category = categories?[indexPath.row] {
                destinationSegue.category = category
            }
        }
    }
    
    func categoryDataChaged(categoryName: String, iconImage: IconImage, iconColor: String) {
        if CategoryModel().categoryNameUsed(categoryName: categoryName){
            let alert = Alert(title: "Nome da categoria repetido", message: "Já existe uma categoria com esse nome, não foi possível criá-la.").get()
            present(alert, animated: true, completion: nil)
            return
        }
        
        let category = Category(type: type, name: categoryName, iconImage: iconImage, iconColor: iconColor)
        category.save()
        categoriesTableView.reloadData()
    }
    
}


//MARK: - UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = categoriesTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        categoryCell.accessoryType = .disclosureIndicator

        if let category = categories?[indexPath.row] {
            categoryCell.iconImageView.image = IconImage(typeString: category.iconType, name: category.iconImage).getImage()
            categoryCell.iconColorImageView.backgroundColor = UIColor(named: category.iconColor)

            
            categoryCell.categoryNameLabel.text = category.name
        }

        
        return categoryCell
    }
}

//MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //if let account1 = categories?[sourceIndexPath.row], let account2 = categories?[destinationIndexPath.row] {
        //    AccountsModel().swapAccounts(account1: account1, account2: account2)
        //}

        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let category = categories?[indexPath.row] {
                category.delete()
            }
        }
        categoriesTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "subcategories", sender: self)
    }
    
}
