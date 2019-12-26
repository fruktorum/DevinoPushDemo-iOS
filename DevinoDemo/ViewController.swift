//
//  ViewController.swift
//  DevinoDemo
//
//  Created by Alexej Nenastev on 31.05.2018.
//  Copyright © 2018 Alexej Nenastev. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
import DevinoSDK

var logText: String = "" 

class ViewController: UIViewController {

    @IBOutlet weak var logs: UITextView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tfPhone.delegate = self
        tfEmail.delegate = self
        
        Devino.shared.logger = { str in DispatchQueue.main.async {
            logText += str 
            self.logs.text = logText
            } }
    }
    
    @IBAction func doUpdateUserInfo(_ sender: Any) {
        let phone = tfPhone.text == "" ? nil : tfPhone.text
        let email = tfEmail.text == "" ? nil : tfEmail.text
        Devino.shared.setUserData(phone: phone, email: email)
    }
 
    @IBAction func doPushPerm(_ sender: Any) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                Devino.shared.trackNotificationPermissionsGranted(granted: granted)
                
                guard  granted  else { return }
                DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @IBAction func doGeo(_ sender: Any) {
        Devino.shared.trackLocation()
    }
    
    @IBAction func doTrackSomeEvent(_ sender: Any) {
        Devino.shared.trackEvent(name: "SomeEvent", params: ["someParam": 1])
    }
    
    
    @IBAction func doClear(_ sender: Any) {
        logText = ""
        logs.text = ""
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

