//
//  UIViewController.swift
//  DevinoDemo
//
//  Created by Maria on 12.10.2019.
//  Copyright © 2019 Alexej Nenastev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in }))
        self.present(alert, animated: true, completion: nil)
    }
}
