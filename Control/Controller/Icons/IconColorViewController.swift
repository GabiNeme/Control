//
//  iconImageViewController.swift
//  Control
//
//  Created by Gabriela Neme on 12/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

protocol IconColorSelectorDelegate {
    func iconColorSelected(color: UIColor?)
}

class IconColorViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closerBarButton: UIButton!
    
    var delegate: IconColorSelectorDelegate!
    
    let colors = ColorTracker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionView.register(UINib(nibName: "iconColorCell", bundle: <#T##Bundle?#>), forCellWithReuseIdentifier: IconImageCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        closerBarButton.layer.cornerRadius = 2.5
    }

    @IBAction func closeBarButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension IconColorViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.iconColorSelected(color: colors.getColor(index: indexPath.item))
        dismiss(animated: true, completion: nil)
    }
}

extension IconColorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.colorsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconColorCell", for: indexPath)
        
        cell.contentView.backgroundColor = colors.getColor(index: indexPath.item)
        
        return cell
    }
    
}


extension IconColorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = round((UIScreen.main.bounds.width - 40)/4) - 1
        
        return CGSize(width: width, height: width)
    }
    
    

    
}
