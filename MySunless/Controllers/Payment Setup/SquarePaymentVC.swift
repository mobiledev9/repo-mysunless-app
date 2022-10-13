//
//  SquarePaymentVC.swift
//  MySunless
//
//  Created by iMac on 07/05/22.
//

import UIKit
import iOSDropDown
import Alamofire
import SCLAlertView

class SquarePaymentVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var vw_type: UIView!
    @IBOutlet var txtType: DropDown!
    @IBOutlet var vw_applicationID: UIView!
    @IBOutlet var txtApplicationID: UITextField!
    @IBOutlet var vw_accessToken: UIView!
    @IBOutlet var txtAccessToken: UITextField!
    @IBOutlet var vw_locationID: UIView!
    @IBOutlet var txtLocationID: UITextField!
    @IBOutlet var vw_enable: UIView!
    @IBOutlet var vw_disable: UIView!
    @IBOutlet var lblApplicationID: UILabel!
    
    //MARK:- Variable Declarations
    var token = String()
    var type = Int()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowSquareAPI()
    }
    
    //MARK:- User-Defined Functions
    func setInitially() {
        vw_type.layer.borderWidth = 0.5
        vw_type.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_applicationID.layer.borderWidth = 0.5
        vw_applicationID.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_accessToken.layer.borderWidth = 0.5
        vw_accessToken.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_locationID.layer.borderWidth = 0.5
        vw_locationID.layer.borderColor = UIColor.init("#15B0DA").cgColor
        txtType.delegate = self
        txtLocationID.delegate = self
        txtAccessToken.delegate = self
        txtApplicationID.delegate = self
        txtType.optionArray = ["Testing (Sandbox)", "Production (Live)"]
        txtType.didSelect { (selectedText, index, id) in
            switch index {
                case 0:
                    self.type = 0
                self.txtType.text = selectedText
                self.txtType.selectText = selectedText
                case 1:
                    self.type = 1
                self.txtType.text = selectedText
                self.txtType.selectText = selectedText
                default:
                    print("Default")
            }
        }
        
        vw_enable.isHidden = false
        vw_disable.isHidden = true
    }
    
    func setValidation() -> Bool {
        if txtType.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Square payment type", viewController: self)
        } else if txtApplicationID.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Application Id", viewController: self)
        } else if txtAccessToken.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Token", viewController: self)
        } else if txtLocationID.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Location Id", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String, enable: Bool, disable: Bool) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            if enable {
                self.vw_enable.isHidden = true
                self.vw_disable.isHidden = false
                self.callShowSquareAPI()
            } else if disable {
                self.vw_enable.isHidden = false
                self.vw_disable.isHidden = true
            }
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func callAddSquareAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["type": type,
                  "applicationId": txtApplicationID.text ?? "",
                  "token": txtAccessToken.text ?? "",
                  "locationId": txtLocationID.text ?? ""
        ]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_SQUARE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response, enable: true, disable: false)
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
    
    func callShowSquareAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_SQUARE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? NSDictionary {
                            if let applicationId = response.value(forKey: "applicationId") as? String {
                                self.lblApplicationID.text = applicationId
                                self.vw_enable.isHidden = true
                                self.vw_disable.isHidden = false
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            print(response)
                            self.vw_enable.isHidden = false
                            self.vw_disable.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    func callDesableSquareAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DISABLE_SQUARE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response, enable: false, disable: true)
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
    @IBAction func btnEnableClick(_ sender: UIButton) {
        if setValidation() {
            callAddSquareAPI()
        }
    }
    
    @IBAction func btnSetUpGuideClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SetUpGuideVC") as! SetUpGuideVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnSetIDClick(_ sender: UIButton) {
        if let url = URL(string: "https://developer.squareup.com/apps") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func btnDisableClick(_ sender: UIButton) {
        callDesableSquareAPI()
    }
    
}

//MARK:- UITextField Delegate Methods
extension SquarePaymentVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtType.resignFirstResponder()
        txtApplicationID.resignFirstResponder()
        txtAccessToken.resignFirstResponder()
        txtLocationID.resignFirstResponder()
        return true
    }
}
