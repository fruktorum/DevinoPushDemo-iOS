//
//  UserRegistrationViewController.swift
//  DevinoDemo
//
//  Created by West on 3.08.23.
//  Copyright © 2023 Alexej Nenastev. All rights reserved.
//

import UIKit
import DevinoSDK

class UserRegistrationViewController: UIViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet private var userPassTextField: UITextField?
    @IBOutlet private var rootApiUrlTextField: UITextField?
    @IBOutlet private var userPhoneTextField: UITextField?
    
    private var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        rootApiUrlTextField?.text = Constants.apiUrl
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        userPhoneTextField?.delegate = self
    }
    
    // MARK: - Gestures
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UI Actions
    
    @IBAction private func didTapOnRegisterButton() {
        let storyBoard: UIStoryboard = .init(name: "Main", bundle: nil)
        guard let settingsVC = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else { return }
        if validUserInfo() {
            settingsVC.userUpdateData(phone: userPhoneTextField?.text, email: userPassTextField?.text)
            clearTextFields()
            UserDefaults.standard.set(true, forKey: "status")
            navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    
    @IBAction private func didTapOnSkipRegistrationButton() {
        redirectToMainViewController()
    }
    
    @IBAction private func didTapOnConfirmRootUrlButton() {
        guard let apiUrl = rootApiUrlTextField?.text, !apiUrl.isEmpty else {
            self.showError(message: "Root API Url не должен быть пустым!")
            return
        }
//        Devino.shared.setupApiRootUrl(with: apiUrl)
//        showMessage("Root API URL is changed")
        rootApiUrlTextField?.text = nil
    }
    
    private func redirectToMainViewController() {
        let storyboard: UIStoryboard = .init(name: "Main", bundle: nil)
        guard let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else { return }
        navigationController?.pushViewController(settingsVC, animated: true)
    }
   
    private func validUserInfo() -> Bool {
        var isValid = true
        if let phone = userPhoneTextField?.text, !phone.isValidPhoneNumber {
            isValid = false
            setRedBorder(for: userPhoneTextField ?? .init(frame: .zero))
        }
        
        if let password = userPassTextField?.text, !password.isValidPasswordCode {
            isValid = false
            setRedBorder(for: userPassTextField ?? .init(frame: .zero))
        }
        
        return isValid
    }
    
    private func setRedBorder(for textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
    }
    
    private func clearTextFields() {
        userPhoneTextField?.text = nil
        userPassTextField?.text = nil
    }
}

//MARK: Extensions

extension UserRegistrationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == .zero {
            return true
        }
        
        if textField.tag == .zero {
            guard let text = textField.text, text.count < "+# ### ###-####".count  else { return false }
            textField.text = text.applyPatternOnNumbers(pattern: "+# ### ###-####", replacmentCharacter: "#")
            return true
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        if textField.tag == 0, textField.text == "" {
            textField.text = "+7 9"
        }
    }
}
