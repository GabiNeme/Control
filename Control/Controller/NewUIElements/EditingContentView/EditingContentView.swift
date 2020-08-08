//
//  EditingContentView.swift
//  Control
//
//  Created by Gabriela Neme on 26/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

protocol FinishedEditingDate {
    func finishedEditingDate(date: Date)
}

class EditingContentView: NSObject {
    
    var containerView = UIView()
    let background = UIView()
    
    var mainContentHeight: CGFloat = 310
    let toolBarHeight: CGFloat = 44
    var viewHeight: CGFloat {
        var height = mainContentHeight + toolBarHeight
        if let window = UIApplication.shared.windows.first{
           let bottomPadding = window.safeAreaInsets.bottom
           height = height + bottomPadding
        }
        return height
    }
    
    var date: Date?
    var dateDelegate: FinishedEditingDate?
    
    override init() {
        super.init()

    }
    
    private func show(){

        if let window = UIApplication.shared.windows.first{
            background.alpha = 0.1
            background.frame = UIScreen.main.bounds
            background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            window.addSubview(background)
            
            createContainer()
            createToolBar()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.containerView.frame = CGRect(x: 0, y: window.frame.height - self.viewHeight, width: window.frame.width, height: self.viewHeight)
            }, completion: nil)
            
 
        }
    }
    
    @objc func dismiss(){
        background.alpha = 0
        if let window = UIApplication.shared.windows.first{
            UIView.animate(withDuration: 0.3) {
                self.containerView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: self.viewHeight)
            }
        }
        
        if let date = date, let delegate = dateDelegate {
            delegate.finishedEditingDate(date: date)
        }
    }
    
    private func createContainer(){
        containerView = UIView()
        if let window = UIApplication.shared.windows.first{
            containerView.backgroundColor = UIColor(named: "BackgroundColor")
            containerView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: viewHeight)
            window.addSubview(containerView)
        }
    }
    
    private func createToolBar(){
        if let window = UIApplication.shared.windows.first{
            let toolBar = KeyboardToolBar(width: window.frame.width, target: self, selector: #selector(dismiss)).getCustom()
            containerView.addSubview(toolBar)
            toolBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
            toolBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
            toolBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        }
    }
    
    private func setConstraintToContainterView(view: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: containerView.topAnchor
            , constant: toolBarHeight).isActive = true
        view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        view.heightAnchor.constraint(equalToConstant: mainContentHeight).isActive = true
    }
    
}

//MARK: - Icon Selector

extension EditingContentView {
    func showIconSelector(viewController: IconSelectorDelegate, selectedImage: IconImage, selectedColor: String, onlyImage: Bool = false){
        mainContentHeight = 266
        show()
        
        
        if let viewControllerOrigin = viewController as? UIViewController{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let iconSelector = storyboard.instantiateViewController(identifier: "setIconViewController") as! IconViewController
            
            iconSelector.delegate = viewController
            iconSelector.selectedImage = selectedImage
            iconSelector.selectedColor = selectedColor
            iconSelector.onlyImage = onlyImage
            
            containerView.addSubview(iconSelector.view)
            viewControllerOrigin.addChild(iconSelector)
            
            setConstraintToContainterView(view: iconSelector.view)
            
            iconSelector.didMove(toParent: viewControllerOrigin)
        }
        
    }
}

//MARK: - Day picker

extension EditingContentView {
    func showDaySelector(viewController: DayPickerDelegate, daySelected: Int){
        
        mainContentHeight = 216
        show()
        
        if let viewControllerOrigin = viewController as? UIViewController{
            let dayPickerViewController = DayPickerViewController()
            
            dayPickerViewController.delegate = viewController
            dayPickerViewController.selectedDay = daySelected
            
            containerView.addSubview(dayPickerViewController.view)
            viewControllerOrigin.addChild(dayPickerViewController)
            
            setConstraintToContainterView(view: dayPickerViewController.view)            
            
            dayPickerViewController.didMove(toParent: viewControllerOrigin)
        }
    }
    
}

//MARK: - Calendar view and date selection

extension EditingContentView: CalendarSelectionDelegate {
    
    func showCalendarSelector(viewController: FinishedEditingDate, daySelected: Int){
        
        mainContentHeight = 300
        show()
        
        dateDelegate = viewController
        
        if let viewControllerOrigin = viewController as? UIViewController{
            
            let calendarSelectorViewController = CalendarSelectionViewController()
                
            calendarSelectorViewController.delegate = self
            
            containerView.addSubview(calendarSelectorViewController.view)
            viewControllerOrigin.addChild(calendarSelectorViewController)
            
            setConstraintToContainterView(view: calendarSelectorViewController.view)
            
            calendarSelectorViewController.didMove(toParent: viewControllerOrigin)
         }
    }
    
    
    func dateSelected(date: Date) {
        self.date = date
    }
    
}
