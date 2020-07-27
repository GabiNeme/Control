//
//  IconViewController.swift
//  Control
//
//  Created by Gabriela Neme on 25/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//


import UIKit

protocol IconSelectorDelegate {
    func iconSelected(color: String, image: IconImage)
}

class IconViewController: UIViewController {
    
    @IBOutlet weak var closerBarButton: UIButton!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionView: UICollectionView!

    @IBOutlet weak var backgroundColorImageView: UIImageView!
    @IBOutlet weak var imageImageView: UIImageView!
       
    @IBOutlet weak var segmentControlView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var imageView: UIView!
    
       
    var delegate: IconSelectorDelegate!
    
    let colors = ColorTracker()
    let images = ImageTracker()
    
    var selectedColor: String!
    var selectedImage: IconImage!
    
    var onlyImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorCollectionView.register(IconColorCollectionViewCell.nib(), forCellWithReuseIdentifier: IconColorCollectionViewCell.identifier)
        imageCollectionView.register(IconImageCollectionViewCell.nib(), forCellWithReuseIdentifier: IconImageCollectionViewCell.identifier)
        
        backgroundColorImageView.layer.cornerRadius = 50
        closerBarButton.layer.cornerRadius = 2.5
        
        selectedColor = "gray4"
        selectedImage = IconImage(type: .SFSymbol, name: "questionmark")
        
        if onlyImage {
            segmentControlView.isHidden = true
            separatorView.isHidden = true
            colorView.isHidden = true
        }
        
        updateIcon()
    }

    @IBAction func closeBarButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        delegate.iconSelected(color: selectedColor, image: selectedImage)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func colorOrImageSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            colorView.isHidden = false
            imageView.isHidden = true
        }else if sender.selectedSegmentIndex == 1 {
            colorView.isHidden = true
            imageView.isHidden = false
            
        }
    }
    
    
}

extension IconViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == colorCollectionView {
            if let cell = colorCollectionView.cellForItem(at: indexPath) as? IconColorCollectionViewCell{
                cell.selectionIndicator.isHidden = false
            }
            selectedColor = colors.getName(index: indexPath.row)
            updateColor()
            
        }else if collectionView == imageCollectionView {
            if let cell = imageCollectionView.cellForItem(at: indexPath) as? IconImageCollectionViewCell{
                cell.selectedIndicator.isHidden = false
            }
            selectedImage = images.getImage(index: indexPath.row)
            updateImage()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == colorCollectionView {
            if let cell = colorCollectionView.cellForItem(at: indexPath) as? IconColorCollectionViewCell{
                cell.selectionIndicator.isHidden = true
            }
        }else if collectionView == imageCollectionView {
            if let cell = imageCollectionView.cellForItem(at: indexPath) as? IconImageCollectionViewCell{
                cell.selectedIndicator.isHidden = true
            }
        }
    }
}


extension IconViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == colorCollectionView {
            return colors.colorsCount
        }else if collectionView == imageCollectionView {
            return images.imagesCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == colorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconColorCollectionViewCell.identifier, for: indexPath) as! IconColorCollectionViewCell
            
            cell.backgroundColorImageView.backgroundColor = colors.getColor(index: indexPath.row)
            
            if selectedColor == colors.getName(index: indexPath.row) {
                cell.selectionIndicator.isHidden = false
                colorCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            } else {
                cell.selectionIndicator.isHidden = true
            }
            
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconImageCollectionViewCell.identifier, for: indexPath) as! IconImageCollectionViewCell
            let iconImage: IconImage = images.getImage(index: indexPath.item)
            cell.iconImageView.image = iconImage.getImage()
            
            if selectedImage.type == iconImage.type && selectedImage.name == iconImage.name {
                cell.selectedIndicator.isHidden = false
                imageCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            }else{
                cell.selectedIndicator.isHidden = true
            }
            return cell
        }
        
    }
    
}


extension IconViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
}


extension IconViewController {
    
    func updateIcon(){
        updateColor()
        updateImage()
    }
    
    func updateColor(){
        backgroundColorImageView.backgroundColor = UIColor(named: selectedColor)
    }
    
    func updateImage(){
        imageImageView.image = selectedImage.getImage()
    }

}
