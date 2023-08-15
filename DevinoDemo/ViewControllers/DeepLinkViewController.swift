//
//  DeepLinkViewController.swift
//  DevinoDemo
//
//  Created by Maria on 17.10.2019.
//  Copyright © 2019 Alexej Nenastev. All rights reserved.
//

import UIKit

class DeepLinkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doBackBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
}
