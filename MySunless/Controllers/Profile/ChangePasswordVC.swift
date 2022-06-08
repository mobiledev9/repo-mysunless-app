//
//  ChangePasswordVC.swift
//  MySunless
//
//  Created by Daydream Soft on 08/06/22.
//

import UIKit
import Alamofire

class ChangePasswordVC: UIViewController {
    
    @IBOutlet var vw_currentPassword: UIView!
    @IBOutlet var txtCurrentPassword: UITextField!
    @IBOutlet var vw_newPassword: UIView!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var vw_confirmNewPassword: UIView!
    @IBOutlet var txtConfirmNewPassword: UITextField!
    @IBOutlet var vw_changePassword: UIView!
    @IBOutlet var btnChangePassword: UIButton!
    
    var token = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func setInitially() {
        vw_currentPassword.layer.borderWidth = 0.5
        vw_currentPassword.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_newPassword.layer.borderWidth = 0.5
        vw_newPassword.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_confirmNewPassword.layer.borderWidth = 0.5
        vw_confirmNewPassword.layer.borderColor = UIColor.init("15B0DA").cgColor
        txtCurrentPassword.delegate = self
        txtNewPassword.delegate = self
        txtConfirmNewPassword.delegate = self
    }
    
    func changePasswordValidation() -> Bool {
        if txtCurrentPassword.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter your current password", viewController: self)
        } else if txtNewPassword.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter new password", viewController: self)
        } else if txtConfirmNewPassword.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter confirm password", viewController: self)
        } else if txtNewPassword.text != txtConfirmNewPassword.text {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Enter confirm password same as password", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callChangePasswordAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [
            "password":txtCurrentPassword.text ?? "",
            "newpassword":txtNewPassword.text ?? ""
        ]
        
        let headers: HTTPHeaders = ["Authorization":token]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CHANGE_PASSWORD, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnUpdatePasswordClick(_ sender: UIButton) {
        if changePasswordValidation() {
            callChangePasswordAPI()
        }
    }
}

//MARK:- Textfield Delegate Methods
extension ChangePasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtCurrentPassword.resignFirstResponder()
        txtNewPassword.resignFirstResponder()
        txtConfirmNewPassword.resignFirstResponder()
        return true
    }
}
