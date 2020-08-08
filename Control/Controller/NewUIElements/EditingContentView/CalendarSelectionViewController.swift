//
//  DatePickerViewController.swift
//  Control
//
//  Created by Gabriela Neme on 30/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit
import CVCalendar

protocol CalendarSelectionDelegate {
    func dateSelected(date: Date)
}

class CalendarSelectionViewController: UIViewController {
    
    var monthLabel: UILabel!
    var menuView: CVCalendarMenuView!
    var calendarView: CVCalendarView!

    
    private var animationFinished = true
    private var currentCalendar: Calendar?
    
    var delegate: CalendarSelectionDelegate!
    var selectedDay: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        monthLabel.textColor = UIColor(named: "Label Color")
        monthLabel.font = UIFont(name: "Avenir Next Medium", size: 17)
        monthLabel.textAlignment = .center
        view.addSubview(monthLabel)
        
        // CVCalendarMenuView initialization with frame
        self.menuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 30, width: view.bounds.width, height: 20))
        view.addSubview(menuView)
        // CVCalendarView initialization with frame
        self.calendarView = CVCalendarView(frame: CGRect(x: 0, y: 50, width: view.bounds.width, height: 250))
        view.addSubview(calendarView)
        // Appearance delegate [Unnecessary]
        self.calendarView.calendarAppearanceDelegate = self

        // Animator delegate [Unnecessary]
        self.calendarView.animatorDelegate = self

        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self

        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
        
        currentCalendar = Calendar(identifier: .gregorian)
        
        if let currentCalendar = currentCalendar {
            monthLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription.capitalized
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Commit frames' updates
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    
}

extension CalendarSelectionViewController:  CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    func presentationMode() -> CalendarMode {
        return .monthView
    }

    func firstWeekday() -> Weekday {
        return .sunday
    }

    func calendar() -> Calendar? { return currentCalendar }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        if let date = dayView.date.convertedDate(){
            delegate.dateSelected(date: date)
        }
        
    }

    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription.capitalized && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription.capitalized
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                //self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
}
