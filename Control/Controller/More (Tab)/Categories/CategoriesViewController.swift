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
    var type: TransactionType = .expense
    var categories: Results<Category>?
    
    var categoryModifyType: ObjectModifyType = .add
    var categoryIndexToEdit: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        
        categoriesTableView.register(CategoryTableViewCell.nib(), forCellReuseIdentifier: CategoryTableViewCell.identifier)
        categoriesTableView.rowHeight = 50
        
        categories = realm.objects(Category.self).filter(NSPredicate(format: "privateType = %@", type.rawValue)).sorted(byKeyPath: "name")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoriesTableView.reloadData()
    }

}

//MARK: - Category Types - expense, income

extension CategoriesViewController {
    
    
    @IBAction func categoryTypeSegmentedControlPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            type = .expense
        }else{
            type = .income
        }
        categories = realm.objects(Category.self).filter(NSPredicate(format: "privateType = %@", type.rawValue)).sorted(byKeyPath: "name")
        categoriesTableView.reloadData()
    }
    
}


//MARK: - UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = categoriesTableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
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
    
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCategory(indexPathRow: indexPath.row)
        }
        categoriesTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "subcategories", sender: self)
    }
    
}

//MARK: - Swipe tableview methods

extension CategoriesViewController {
    
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        return TrailingSwipeForEditAndDelete().get(
            editHandler: { (_, _, complete) in
                complete(true)
                self.editCategory(indexPathRow: indexPath.row)
            },
            deleteHandler:  { (_, _, complete) in
                complete(true)
                self.deleteCategory(indexPathRow: indexPath.row)
            })
    
    }
    

}

//MARK: - Haptic/Force Touch menu

extension CategoriesViewController {

    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return HepticTouchForEditAndDelete().get(
            editHandler: { (_) in
                self.editCategory(indexPathRow: indexPath.row)
            }, deleteHandler:  { (_) in
                self.deleteCategory(indexPathRow: indexPath.row)
            })
        
    }
    
}


//MARK: - Add new category

extension CategoriesViewController: setCategoryDelegate {


    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        categoryModifyType = .add
        performSegue(withIdentifier: "editCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCategory" {
            let destinationSegue = segue.destination as! SetCategoryViewController
            destinationSegue.delegate = self
            
            if categoryModifyType == .add {
                destinationSegue.categoryType = type
            }else{
                if let index = categoryIndexToEdit, let category = categories?[index] {
                    destinationSegue.editingCategory = category
                }
            }
        }else if segue.identifier == "subcategories"{
            let destinationSegue = segue.destination as! SubcategoriesViewController
            
            if let indexPath = categoriesTableView.indexPathForSelectedRow, let category = categories?[indexPath.row] {
                destinationSegue.category = category
            }
        }
    }
    
    func categoryDataChaged() {
        categoriesTableView.reloadData()

    }
    
}

extension CategoriesViewController {
    //MARK: - Edit category
    func editCategory(indexPathRow: Int){
        self.categoryIndexToEdit = indexPathRow
        self.categoryModifyType = .edit
        
        performSegue(withIdentifier: "editCategory", sender: self)
    }
    
    
    //MARK: - Delete category
    func deleteCategory(indexPathRow: Int){
        if let category = categories?[indexPathRow] {
            category.delete()
        }
        categoriesTableView.deleteRows(at: [IndexPath(row: indexPathRow, section: 0)], with: .automatic)
    }

    
}
