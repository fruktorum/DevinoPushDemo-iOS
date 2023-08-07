//
//  ActionLinkViewController.swift
//  DevinoDemo
//
//  Created by Zhoomartov Erbolot on 18.06.2022.
//

import Foundation
import UIKit

class ActionLinkViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func pressedBackButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "navVC") as! NavVC
        UIApplication.shared.windows.first?.rootViewController = navVC
    }
}
