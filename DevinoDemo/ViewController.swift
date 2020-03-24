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

var logText = ""

class ViewController: UIViewController {

    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logs: UITextView!
    @IBOutlet weak var logsView: UIView!
    @IBOutlet weak var logsViewHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var pictureSwitch: UISwitch!
    @IBOutlet weak var deepLinkSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    var hightLogs: CGFloat = 0
    var picture: String?
    var sound: String?
    var deepLink: [ActionButton]?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tfPhone.delegate = self
        tfEmail.delegate = self
        configLogs(for: .close)
        Devino.shared.logger = { str in
            DispatchQueue.main.async {
            print(str)
            logText += str
            self.logs.text = logText }}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hightLogs = scrollView.frame.size.height - 397
        logsViewHightConstraint.constant = hightLogs > 0
            ? hightLogs
            : (logsView.isHidden ? 60 : 260)
        // 397 - hight of all elements without logs
    }
    
    @IBAction func doUpdateUserInfo(_ sender: Any) {
        guard let phone = tfPhone.text, let email = tfEmail.text else { return }
        if validUserInfo() {
            Devino.shared.setUserData(phone: "+" + phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(), email: email)
        }
        view.endEditing(true)
    }
    
    private func validUserInfo() -> Bool {
        var isValid = true
        if let phone = tfPhone.text, !phone.isValidPhoneNumber {
            isValid = false
            setRedBorder(for: tfPhone)
        }
        if let email = tfEmail.text, !email.isValidEmail {
            isValid = false
            setRedBorder(for: tfEmail)
        }
        return isValid
    }
    
    func setRedBorder(for textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
    }
 
    @IBAction func touchSendGeoBtn(_ sender: Any) {
        Devino.shared.sendPushWithLocation()
//        Devino.shared.trackLocation()
        
        Devino.shared.sendCurrentSubscriptionStatus(isSubscribe: Devino.isUserNotificationsAvailable)// from settings - Devino.isUserNotificationsAvailable
        
        Devino.shared.getLastSubscriptionStatus { result in
            switch result {
            case .success(let result):
                print("Success LastSubscriptionStatus = \(result)")
            case .failure(let error):
                print("Error LastSubscriptionStatus = \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func touchNotificationBtn(_ sender: Any) {
        Devino.shared.sendPushNotification(sound: sound, buttons: deepLink, linkToMedia: picture)
    }
    
    @IBAction func switchPicture(_ sender: UISwitch) {
        picture = sender.isOn ? Content.picture.rawValue : nil
    }
    
    @IBAction func switchSound(_ sender: UISwitch) {
        sound = sender.isOn ? Content.sound.rawValue : nil
    }
    
    @IBAction func switchDeepLink(_ sender: UISwitch) {
        deepLink = sender.isOn ? [ActionButton(caption: Content.deepLinkCaption.rawValue, action: Content.deepLinkAction.rawValue)] : nil
    }
    
    @IBAction func touchShowLogsBtn(_ sender: UIButton) {
        logsView.isHidden = !logsView.isHidden
        configLogs(for: logsView.isHidden ? .close : .open)
    }
    
    @IBAction func touchClearBtn(_ sender: Any) {
        logText.removeAll()
        logs.text.removeAll()
    }
    
    func configLogs(for state: LogState) {
        if #available(iOS 11.0, *) {
            arrowBtn.clipsToBounds = true
            arrowBtn.layer.cornerRadius = 5
            switch state {
            case .open:
                arrowBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
                arrowBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            case .close:
                arrowBtn.setImage(UIImage(named: "arrow_up"), for: .normal)
                arrowBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            }
        }
    }
}


class NavVC: UINavigationController {}

enum LogState {
    case open
    case close
}

enum Content: String {
    case picture = "https://moon.nasa.gov/system/resources/list_images/343_DSC1997_320.jpg"
    case sound = "push_sound.wav"
    case deepLinkCaption = "deep link"
    case deepLinkAction = "devino://first"
}
