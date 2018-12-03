//
//  TextFieldNavigation.swift
//  TextFieldNavigationFromKeyboard
//
//  Created by Yugandhar Kommineni on 12/2/18.
//  Copyright © 2018 Yugandhar Kommineni. All rights reserved.
//

import UIKit

class TextFieldNavigation: NSObject {
    
    // MARK: - Properties
    var toolbarBackgroundColor: UIColor? {
        get {
            return toolbar.barTintColor
        }
        set {
            toolbar.barTintColor = newValue
        }
    }
    var textFields: [UITextField] = []
    weak var activeTextField: UITextField? = nil {
        didSet {
            activeTextField?.inputAccessoryView = toolbar
        }
    }
    private var isFirstTextFieldActive: Bool {
        return activeTextField != textFields.first
    }
    private var isLastTextFieldActive: Bool {
        return activeTextField != textFields.last
    }
    private lazy var previousButton: UIBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "uparrow"), style: .plain, target: self, action: #selector(moveToPreviousTextField))
    
    private lazy var nextButton: UIBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "downarrow"), style: .plain, target: self, action: #selector(moveToNextTextField))
    
    private lazy var doneButton: UIBarButtonItem =  UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(done))
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barTintColor = #colorLiteral(red: 0.9254901961, green: 0.9294117647, blue: 0.937254902, alpha: 1)
        toolbar.sizeToFit()
        
        let marginView = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        marginView.width = 10
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        if #available(iOS 11.0, *) {
            let spaceBetweenButtons = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
            spaceBetweenButtons.width = 10
            
            toolbar.setItems([marginView, self.previousButton, spaceBetweenButtons, self.nextButton, flexibleSpace ,self.doneButton, marginView], animated: false)
            
        } else {
            toolbar.setItems([marginView, self.previousButton, self.nextButton,flexibleSpace, self.doneButton, marginView], animated: false)
        }
        
        return toolbar
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    init(with fields: [UITextField]) {
        super.init()
        self.textFields = fields
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: nil)
    }
    
    @objc private func textFieldDidBeginEditing(notification: NSNotification) {
        guard let textField = notification.object as? UITextField, textFields.contains(textField) else {
            return
        }
        
        activeTextField = textField
        previousButton.isEnabled = isFirstTextFieldActive
        nextButton.isEnabled = isLastTextFieldActive
    }
    
    @objc private func moveToPreviousTextField() {
        guard let activeTextField = activeTextField else {
            return
        }
        
        if isFirstTextFieldActive, let index = textFields.index(of: activeTextField) {
            moveFocus(to: textFields[index - 1])
        }
    }
    
    @objc private func done() {
        activeTextField?.resignFirstResponder()
    }
    
    @objc func moveToNextTextField() {
        guard let activeTextField = activeTextField else {
            return
        }
        
        if isLastTextFieldActive, let index = textFields.index(of: activeTextField) {
            moveFocus(to: textFields[index + 1])
        }
    }
    
    private func moveFocus(to activeField: UITextField) {
        activeField.becomeFirstResponder()
        activeTextField = activeField
    }
}
