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
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
}
