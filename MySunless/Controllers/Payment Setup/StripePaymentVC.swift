//
//  StripePaymentVC.swift
//  MySunless
//
//  Created by iMac on 07/05/22.
//

import UIKit
import iOSDropDown
import Alamofire
import SCLAlertView

class StripePaymentVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var vw_activate: UIView!
    @IBOutlet var vw_type: UIView!
    @IBOutlet var txtType: DropDown!
    @IBOutlet var vw_publishableKey: UIView!
    @IBOutlet var txtPublishableKey: UITextField!
    @IBOutlet var vw_secretKey: UIView!
    @IBOutlet var txtSecretKey: UITextField!
    @IBOutlet var vw_deactivate: UIView!
    @IBOutlet var lblMode: UILabel!
    
    //MARK:- Variable Declarations
    var token = String()
    var type = String()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowStripeAPI()
    }
    
    //MARK:- User-Defined Functions
    func setInitially() {
        vw_type.layer.borderWidth = 0.5
        vw_type.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_publishableKey.layer.borderWidth = 0.5
        vw_publishableKey.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_secretKey.layer.borderWidth = 0.5
        vw_secretKey.layer.borderColor = UIColor.init("#15B0DA").cgColor
        txtType.delegate = self
        txtPublishableKey.delegate = self
        txtSecretKey.delegate = self
        txtType.optionArray = ["Testing (Sandbox)", "Production (Live)"]
        txtType.didSelect { (selectedText, index, id) in
            switch index {
                case 0:
                    self.type = "0"
                case 1:
                    self.type = "1"
                default:
                    print("Default")
            }
        }
        vw_activate.isHidden = false
        vw_deactivate.isHidden = true
    }
    
    func setValidation() -> Bool {
        if txtType.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "PaymentType is Required", viewController: self)
        } else if txtPublishableKey.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Publishable key is Required", viewController: self)
        } else if txtSecretKey.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Secret key is required", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String, activate: Bool, deactivate: Bool) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            if activate {
                self.vw_activate.isHidden = true
                self.vw_deactivate.isHidden = false
                self.callShowStripeAPI()
            } else if deactivate {
                self.vw_activate.isHidden = false
                self.vw_deactivate.isHidden = true
            }
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func callAddstripeAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["paymentstatus": type,
                  "publishablekey": txtPublishableKey.text ?? "",
                  "secretkey": txtSecretKey.text ?? ""
        ]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_STRIPE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response, activate: true, deactivate: false)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    }
                }
            }
        }
    }
    
    func callShowStripeAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_STRIPE_DATA, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            if response == "Production Mode is Successfully Activated" {
                                self.lblMode.text = "Production Mode"
                                self.lblMode.textColor = UIColor.init("#149A14")
                            } else if response == "Test Mode is Successfully Activated" {
                                self.lblMode.text = "Test Mode"
                                self.lblMode.textColor = UIColor.init("#F7B84B")
                            }
                            self.vw_activate.isHidden = true
                            self.vw_deactivate.isHidden = false
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            print(response)
                            self.vw_activate.isHidden = false
                            self.vw_deactivate.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    func callDesableStripeAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DISABLE_STRIPE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response, activate: false, deactivate: true)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func btnActivateClick(_ sender: UIButton) {
        if setValidation() {
            callAddstripeAPI()
        }
    }
    
    @IBAction func btnDeactivateClick(_ sender: UIButton) {
        callDesableStripeAPI()
    }
}

//MARK:- UITextField Delegate Methods
extension StripePaymentVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtType.resignFirstResponder()
        txtPublishableKey.resignFirstResponder()
        txtSecretKey.resignFirstResponder()
        return true
    }
}
