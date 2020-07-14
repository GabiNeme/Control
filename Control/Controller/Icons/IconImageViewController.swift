//
//  iconImageViewController.swift
//  Control
//
//  Created by Gabriela Neme on 12/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

protocol IconImageSelectorDelegate {
    func iconImageSelected(image: IconImage)
}

class IconImageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closerBarButton: UIButton!
    
    var delegate: IconImageSelectorDelegate!
    
    let images = ImageTracker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(IconImageCollectionViewCell.nib(), forCellWithReuseIdentifier: IconImageCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        closerBarButton.layer.cornerRadius = 2.5
    }

    @IBAction func closeBarButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension IconImageViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.iconImageSelected(image: images.getImage(index: indexPath.item))
        dismiss(animated: true, completion: nil)
    }
}

extension IconImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconImageCollectionViewCell.identifier, for: indexPath) as! IconImageCollectionViewCell
        
        cell.iconImageView.image = images.getImage(index: indexPath.item)
        
        return cell
    }
    
}


extension IconImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
}
