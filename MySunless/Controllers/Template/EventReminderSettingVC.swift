//
//  EventReminderSettingVC.swift
//  MySunless
//
//  Created by Daydream Soft on 15/04/22.
//

import UIKit
import Alamofire

class EventReminderSettingVC: UIViewController {
  
    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_EmailReminder: UIView!
    @IBOutlet var txtvwEmailReminder: UITextView!
    @IBOutlet var ButtonOneToSevenClick: [UIButton]!
    
    var token = String()
    var arrShowReminder = [ShowReminderData]()
    var arrRepeatDays = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ButtonOneToSevenClick.forEach { (btn) in
            if arrRepeatDays.contains("\(btn.tag)") {
                btn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                btn.imageView?.tintColor = UIColor.init("#005CC8")
            } else {
                btn.setImage(UIImage(systemName: "square"), for: .normal)
                btn.imageView?.tintColor = UIColor.init("#6D778E")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowReminderDataAPI()
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_EmailReminder.layer.borderWidth = 0.5
        vw_EmailReminder.layer.borderColor = UIColor.init("#005CC8").cgColor
    }
    
    func callShowReminderDataAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_REMINDER_DATA, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrShowReminder.removeAll()
                            for dict in response {
                                self.arrShowReminder.append(ShowReminderData(dictionary: dict)!)
                            }
                            for dic in self.arrShowReminder {
                                self.txtvwEmailReminder.setHTMLFromString(htmlText: dic.message ?? "")
                                self.arrRepeatDays.append(contentsOf: dic.repeatDay?.components(separatedBy: ",") ?? [])
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callEditReminderAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["repeatDay": arrRepeatDays.joined(separator: ","),
                  "message": txtvwEmailReminder.text ?? ""
        ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + EDIT_REMINDER, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: message)
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: message)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnOneToSeven(_ sender: UIButton) {
        if arrRepeatDays.contains("\(sender.tag)") {
            sender.isSelected = true
        }
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            sender.imageView?.tintColor = UIColor.init("#005CC8")
            arrRepeatDays.append("\(sender.tag)")
        } else {
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            sender.imageView?.tintColor = UIColor.init("#6D778E")
            arrRepeatDays = arrRepeatDays.filter{$0 != "\(sender.tag)"}
        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: UIButton) {
        callEditReminderAPI()
    }
}
