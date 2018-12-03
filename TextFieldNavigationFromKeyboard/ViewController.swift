//
//  ViewController.swift
//  TextFieldNavigationFromKeyboard
//
//  Created by Yugandhar Kommineni on 12/2/18.
//  Copyright © 2018 Yugandhar Kommineni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstTextfield: UITextField!
    @IBOutlet weak var secondTextfield: UITextField!
    @IBOutlet weak var thirdTextfield: UITextField!
    @IBOutlet weak var fourthTextfield: UITextField!
    @IBOutlet weak var fifthTextfield: UITextField!
    @IBOutlet weak var sixthTextfield: UITextField!
    
    var textFieldNavigator: TextFieldNavigation?
    var currentTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        currentTextField?.delegate = self
        firstTextfield.delegate = self
        secondTextfield.delegate = self
        thirdTextfield.delegate = self
        fourthTextfield.delegate = self
        fifthTextfield.delegate = self
        sixthTextfield.delegate = self
        textFieldNavigator = TextFieldNavigation()
        textFieldNavigator?.textFields = [firstTextfield,secondTextfield,thirdTextfield,fourthTextfield,fifthTextfield,sixthTextfield]
    }

    @objc func keyboardDidShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardSize:CGSize = keyboardFrame.size
        let contentInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var aRect:CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        if currentTextField != nil {
            if !(aRect.contains(currentTextField!.frame.origin)) {
                scrollView.scrollRectToVisible(currentTextField!.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsents:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsents
        scrollView.scrollIndicatorInsets = contentInsents
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .red
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    private func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        currentTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
