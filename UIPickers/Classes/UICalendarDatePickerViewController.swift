//
//  UICalendarDatePickerViewController.swift
//  UIEntryPicker
//
//  Created by Erick Sanchez on 5/15/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import UIKit

public class UICalendarDatePickerViewController: UIDatePickerViewController {
    
    public var isTimeIncluded: Bool = false {
        didSet {
            updateTimeButtonTitle()
        }
    }
    
    public var canAddTime: Bool = false
    public var isTimeRequired: Bool = false
    
    private lazy var addTimeButton: UIOptionButton = {
        let button = UIOptionButton(type: .TitleButtonAndClearAction)
        button.delegate = self
        
        return button
    }()
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    public override func layoutConent() -> [UIView] {
        
        //TODO: configure datePickerView
        
        let content = super.layoutConent()
        
        return content + [addTimeButton]
    }
    
    private func updateTimeButtonTitle() {
        if isTimeIncluded {
            
            addTimeButton.buttonTitle = self.date.formattedStringWith(.Time_noPadding_am_pm)
            addTimeButton.isShowingClearButton = true
        } else {
            addTimeButton.buttonTitle = "Add a Time"
            addTimeButton.isShowingClearButton = false
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        isTimeIncluded = !(!isTimeIncluded)
    }
}

extension UICalendarDatePickerViewController: UIOptionButtonDelegate {
    public func optionButton(_ optionButton: UIOptionButton, didPressTitle button: UIButton) {
        let timePickerVc = UIDatePickerViewController(headerText: nil, messageText: "select a time", date: self.date)
        timePickerVc.datePickerMode = .time
        timePickerVc.delegate = self
        
        //if adding a new time, set only the time of `self.date` to `Date()`
        if isTimeIncluded == false {
            let timeDate = self.date.equating(to: Date(), by: [.hour, .minute])
            timePickerVc.date = timeDate
        }
        
        self.present(timePickerVc, animated: true) { [unowned self] in
            self.isTimeIncluded = true
        }
    }
    
    public func optionButton(_ optionButton: UIOptionButton, didPressClear button: UIButton) {
        isTimeIncluded = false
    }
}

extension UICalendarDatePickerViewController: UIDatePickerViewControllerDelegate {
    public func datePicker(_ datePicker: UIDatePickerViewController, didFinishWith selectedDate: Date) {
        
        //update self.date with only the time from UIDatePickerVc
        self.date = selectedDate
        updateTimeButtonTitle()
    }
}

//////////////////////////////////////////////////////////
//
// MARK: - UIDatePickerViewController
//
//////////////////////////////////////////////////////////

@objc public protocol UIDatePickerViewControllerDelegate: class {
    @objc optional func datePicker(_ datePicker: UIDatePickerViewController, didFinishWith selectedDate: Date)
}

public class UIDatePickerViewController: UIPickerViewController {
    
    public weak var delegate: UIDatePickerViewControllerDelegate?
    
    public var datePickerMode: UIDatePickerMode = .date
    
    public var date: Date {
        didSet {
            self.datePickerView.setDate(self.date, animated: true)
        }
    }
    
    public fileprivate(set) lazy var datePickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = self.datePickerMode
        pickerView.date = self.date
        pickerView.addTarget(self, action: #selector(changedDatePickerValue(_:)), for: .valueChanged)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.heightAnchor.constraint(equalTo: pickerView.widthAnchor, multiplier: 0.33).isActive = true
        
        return pickerView
    }()
    
    public init(headerText: String?, messageText: String? = "", date: Date) {
        self.date = date
        
        super.init(headerText: headerText, messageText: messageText)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.date = Date()
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    public override func layoutConent() -> [UIView] {
        return [datePickerView]
    }
    
    public override func pressDone(button: UIButton) {
        delegate?.datePicker?(self, didFinishWith: self.date)
    }
    
    @objc private func changedDatePickerValue(_ datePicker: UIDatePicker) {
        self.date = datePicker.date
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
}
