//
//  ViewController+TextField.swift
//  DevinoDemo
//
//  Created by Maria on 18.10.2019.
//  Copyright © 2019 Alexej Nenastev. All rights reserved.
//

import UIKit

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            tfEmail.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 {
            return true
        }
        if textField.tag == 0 {
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
