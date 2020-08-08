//
//  CategorySelectorViewController.swift
//  Control
//
//  Created by Gabriela Neme on 30/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit
import RealmSwift

protocol SelectCategoryDelegate {
    func categorySelected(category: String)
}

class CategorySelectionViewController: UIViewController {
    let realm = try! Realm()
    
    var selectedCategoryName: String = ""
    var categoryType: TransactionType = .expense
    var categories: Results<Category>?
    
    var delegate: SelectCategoryDelegate!
    
    var categoriesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = realm.objects(Category.self).filter(NSPredicate(format: "privateType = %@", categoryType.rawValue)).sorted(byKeyPath: "name")
        
        categoriesCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 150, height: 10), collectionViewLayout: UICollectionViewFlowLayout())
        categoriesCollectionView.register(CategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        categoriesCollectionView.delegate = self as UICollectionViewDelegate
        categoriesCollectionView.dataSource = self as UICollectionViewDataSource
        
        self.view.addSubview(categoriesCollectionView)

        setCollectionViewProperties()
        
    }
    
    func setCollectionViewProperties(){
        
        categoriesCollectionView.backgroundColor = UIColor(named: "BoxesBackgroundColor")

        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        if let flowLayout = categoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        
        categoriesCollectionView.allowsMultipleSelection = false
    }

    
}

//MARK: - Collection view Layout

extension CategorySelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,                       minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 85)
    }
    
}

//MARK: - Collection View Data Source

extension CategorySelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (categories?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        if indexPath.row == categories?.count { //last cell
            cell.iconColorImageView.image = UIImage(systemName: "plus.circle")
            cell.iconImageView.image = nil
            cell.iconColorImageView.backgroundColor = nil
            cell.categoryNameLabel.text = "Nova"
            cell.deselect()
            return cell
        }
        
        if let category = categories?[indexPath.row]{
            cell.categoryNameLabel.text = category.name
            
            cell.iconImageView.image = IconImage(typeString: category.iconType, name: category.iconImage).getImage()
            cell.iconColorImageView.image = nil
            cell.iconColorImageView.backgroundColor = UIColor(named: category.iconColor)
            
            if selectedCategoryName == categories?[indexPath.row].name {
                cell.select()
            }else{
                cell.deselect()
            }
        }
        
        return cell
    }
    
}

//MARK: - Collection View Delegate

extension CategorySelectionViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == categories?.count{
            addNewAccountPressed()
            return
        }
        
        if let categoryName = categories?[indexPath.row].name {
            selectedCategoryName = categoryName
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell{
            cell.select()
        }
        collectionView.reloadData()
        delegate.categorySelected(category: selectedCategoryName)
        
    }
    

}


//MARK: - Add new category

extension CategorySelectionViewController: setCategoryDelegate {
   
    
    func addNewAccountPressed(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let setAccountViewController = storyboard.instantiateViewController(identifier: "setCategoryViewController") as! SetCategoryViewController
        
        setAccountViewController.delegate = self
        setAccountViewController.categoryType = categoryType
        
        self.present(setAccountViewController, animated: true, completion: nil)
    }
    
    func categoryDataChaged() {
        categoriesCollectionView.reloadData()
    }
    
    
}

