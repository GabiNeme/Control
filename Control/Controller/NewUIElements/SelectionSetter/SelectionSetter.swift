//
//  InsertHorizontalSelectionToView.swift
//  Control
//
//  Created by Gabriela Neme on 30/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

struct SelectionSetter {
    
    
    func insertAccountSelection(viewController: SelectAccountDelegate, originView: UIView, account: Account?) {
        clearView(view: originView)
        if let viewControllerOrigin = viewController as? UIViewController{
            let accountSelectionViewController = AccountSelectionViewController()
            
            accountSelectionViewController.delegate = viewController
            accountSelectionViewController.selectedAccount = account
            
            originView.addSubview(accountSelectionViewController.view)
            viewControllerOrigin.addChild(accountSelectionViewController)
            
            setConstraints(view1: originView, view2: accountSelectionViewController.view)
            
            accountSelectionViewController.didMove(toParent: viewControllerOrigin)
        }
    }
    
    func insertCategorySelection(viewController: SelectCategoryDelegate, originView: UIView, categoryType: TransactionType, categoryName: String = "") {
        clearView(view: originView)
        if let viewControllerOrigin = viewController as? UIViewController{
            let categorySelectionViewController = CategorySelectionViewController()
            
            categorySelectionViewController.delegate = viewController
            categorySelectionViewController.categoryType = categoryType
            categorySelectionViewController.selectedCategoryName = categoryName
            
            originView.addSubview(categorySelectionViewController.view)
            viewControllerOrigin.addChild(categorySelectionViewController)
            
            setConstraints(view1: originView, view2: categorySelectionViewController.view)
            
            categorySelectionViewController.didMove(toParent: viewControllerOrigin)
        }
    }
    
    func insertSubcategorySelection(viewController: SelectSubcategoryDelegate, originView: UIView, parentCategory: Category, subcategory: String = "") {
        clearView(view: originView)
        if let viewControllerOrigin = viewController as? UIViewController{
            let subcategorySelectionViewController = SubcategorySelectionViewController()
            
            subcategorySelectionViewController.delegate = viewController
            subcategorySelectionViewController.parentCategory = parentCategory
            subcategorySelectionViewController.selectedSubcategoryName = subcategory
            
            originView.addSubview(subcategorySelectionViewController.view)
            viewControllerOrigin.addChild(subcategorySelectionViewController)
            
            setConstraints(view1: originView, view2: subcategorySelectionViewController.view)
            
            subcategorySelectionViewController.didMove(toParent: viewControllerOrigin)
        }
    }
    
    
    private func clearView(view:UIView) {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }
    
    private func setConstraints(view1: UIView, view2: UIView) {
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.topAnchor.constraint(equalTo: view1.topAnchor
            , constant: 0).isActive = true
        view2.trailingAnchor.constraint(equalTo: view1.trailingAnchor, constant: 0).isActive = true
        view2.leadingAnchor.constraint(equalTo: view1.leadingAnchor, constant: 0).isActive = true
        view2.bottomAnchor.constraint(equalTo: view1.bottomAnchor, constant: 0).isActive = true
    }
    
    
}
