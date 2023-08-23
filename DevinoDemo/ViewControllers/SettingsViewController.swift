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

class SettingsViewController: UIViewController {
    
    // MARK: - UI Outlets

    @IBOutlet weak var arrowBtn: UIButton?
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var logs: UITextView?
    @IBOutlet weak var logsView: UIView?
    @IBOutlet weak var logsViewHightConstraint: NSLayoutConstraint?
    @IBOutlet weak var pictureSwitch: UISwitch?
    @IBOutlet weak var deepLinkSwitch: UISwitch?
    @IBOutlet weak var soundSwitch: UISwitch?
    @IBOutlet weak var registrationView: UIView?
    
    // MARK: - Properties
    
    private var hightLogs: CGFloat = 0
    private var picture: String?
    private var sound: String?
    private var deepLink: [ActionButton]?
    private var actionLink: String?
    
    private var registeredStatus: Bool {
        UserDefaults.standard.bool(forKey: "status")
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configLogs(for: .close)
        Devino.shared.logger = { str in
            DispatchQueue.main.async {
                print(str)
                logText += str
                self.logs?.text = logText }}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !registeredStatus {
            hightLogs = (scrollView?.frame.size.height ?? 0) - 500
        } else {
            registrationView?.isHidden = registeredStatus
            hightLogs = (scrollView?.frame.size.height ?? 0) - 424
        }
        logsViewHightConstraint?.constant = hightLogs > 0
            ? hightLogs
        : ((logsView?.isHidden ?? false) ? 60 : 260)
        // 500 or 424 - hight of all elements without logs depends on registration button displaying
    }
    
    // MARK: - UI Actions
    
    @IBAction func touchRegistrationBtn(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func touchSendGeoBtn(_ sender: Any) {
        Devino.shared.sendPushWithLocation()
        
        Devino.shared.sendCurrentSubscriptionStatus(isSubscribe: Devino.isUserNotificationsAvailable)
        
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
        Devino.shared.sendPushNotification(title: "Devino Telecom", text: "Text notification", sound: sound, buttons: deepLink, linkToMedia: picture, action: actionLink)
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
    
    @IBAction func switchActionLink(_ sender: UISwitch) {
        actionLink = sender.isOn ? Content.actionLink.rawValue : nil
    }
    
    @IBAction func touchCopyLogBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
                UIPasteboard.general.string = logText
            }
        }
    }
    
    @IBAction func copyTokenBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
                UIPasteboard.general.string = Devino.shared.getTokenCopy()
            }
        }
    }
    
    @IBAction func touchShowLogsBtn(_ sender: UIButton) {
        logsView?.isHidden = !(logsView?.isHidden ?? false) 
        configLogs(for: (logsView?.isHidden ?? false) ? .close : .open)
    }
    
    @IBAction func touchClearBtn(_ sender: Any) {
        logText.removeAll()
        logs?.text.removeAll()
    }
    
    //MARK: Functions
    
    func userUpdateData(phone: String?, email: String?) {
        Devino.shared.setUserData(phone: phone, email: email)
    }
    
    //MARK: Private
    
    private func setRedBorder(for textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
    }
    
    private func configLogs(for state: LogState) {
        if #available(iOS 11.0, *) {
            arrowBtn?.clipsToBounds = true
            arrowBtn?.layer.cornerRadius = 5
            switch state {
            case .open:
                arrowBtn?.setImage(UIImage(named: "arrow_down"), for: .normal)
                arrowBtn?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            case .close:
                arrowBtn?.setImage(UIImage(named: "arrow_up"), for: .normal)
                arrowBtn?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            }
        }
    }
}

enum LogState {
    case open
    case close
}

enum Content: String {
    case picture = "https://moon.nasa.gov/system/resources/list_images/343_DSC1997_320.jpg"
    case sound = "push_sound.wav"
    case deepLinkCaption = "deep link"
    case deepLinkAction = "devino://first"
    case actionLink = "devino://second"
}
