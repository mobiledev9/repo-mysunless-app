//
//  LoginVC.swift
//  MySunless
//
//  Created by iMac on 05/10/21.
//

import UIKit
import SCLAlertView

class LoginVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var vw_Email: UIView!
    @IBOutlet var vw_Password: UIView!
    @IBOutlet var vw_HidePass: UIView!
    @IBOutlet var btnHidePass: UIButton!
    @IBOutlet var btnRememberMe: UIButton!
    @IBOutlet var vw_showpassword: UIView!
    
    //MARK:- Variable Declarations
    var AgreeIconClick : Bool! = false
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CheckAndAdd()
        
        vw_Email.layer.borderWidth = 0.5
        vw_Email.layer.borderColor = UIColor.gray.cgColor
        vw_Password.layer.borderWidth = 0.5
        vw_Password.layer.borderColor = UIColor.gray.cgColor
        vw_HidePass.layer.borderWidth = 0.5
        vw_HidePass.layer.borderColor = UIColor.gray.cgColor
        vw_showpassword.roundCorners(corners: [.topRight, .bottomRight], radius: 6.0)
        txtEmail.delegate = self
        txtPassword.delegate = self
        self.hideKeyboardWhenTappedAround()
        
    }
    
    //MARK:- Userdefined Functions
    func CheckAndAdd(){
        if UserDefaults.standard.string(forKey: "rememberMe") == "1" {
            if let image = UIImage(named: "checkbox") {
                btnRememberMe.setBackgroundImage(image, for: .normal)
            }
            AgreeIconClick = true
            
            // Set values
            self.txtEmail.text = UserDefaults.standard.string(forKey: "userMail") ?? ""
            self.txtPassword.text = UserDefaults.standard.string(forKey: "userPassword") ?? ""
        } else {
            if let image = UIImage(named: "box") {
                btnRememberMe.setBackgroundImage(image, for: .normal)
            }
            AgreeIconClick = false
        }
    }
    
    func validation() -> Bool {
        if txtEmail.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter email", viewController: self)
        } else if txtPassword.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter password", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            self.navigationController?.pushViewController(VC, animated: true)
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func callLoginAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [
            "email": self.txtEmail.text ?? "",
            "password": self.txtPassword.text ?? ""
        ]
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + LOGIN, param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if (success == "1") {
                        if let userType = res.value(forKey: "usertype") as? String {
                            UserDefaults.standard.set(userType, forKey: "usertype")
                        }
                        if let token = res.value(forKey: "token") as? String {
                            UserDefaults.standard.set(token, forKey: "token")
                        }
                        if let userid = res.value(forKey: "userid") as? Int {
                            UserDefaults.standard.set(userid, forKey: "userid")
                        }
                        UserDefaults.standard.set(true, forKey: "setUser")
//                        if let resp = res.value(forKey: "data") as? NSDictionary {
                        
//                            let model = UserModel()
//                            model.initModel(attributeDict: resp)
//                            UserManager.shared = model
//                            UserManager.saveUserData()

//                            print(resp)
                        
                        if(self.AgreeIconClick == true) {
                            UserDefaults.standard.set("1", forKey: "rememberMe")
                            UserDefaults.standard.set(self.txtEmail.text ?? "", forKey: "userMail")
                            UserDefaults.standard.set(self.txtPassword.text ?? "", forKey: "userPassword")
                            
                            print("Mail & Password Saved Successfully")
                        }else{
                            print("Mail & Password didn't Saved Successfully")
                            UserDefaults.standard.set("2", forKey: "rememberMe")
                            UserDefaults.standard.removeObject(forKey: "userPassword")
                            UserDefaults.standard.removeObject(forKey: "userMail")
                        }
                        if let response = res.value(forKey: "response") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: message)
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func btnHidePassClick(_ sender: UIButton) {
        if sender.isSelected == true {
            btnHidePass.setImage(UIImage(named: "eye-hidden"), for: .normal)
            sender.isSelected = false
            txtPassword.isSecureTextEntry = true
            
        }else{
            btnHidePass.setImage(UIImage(named: "eye"), for: .normal)
            sender.isSelected = true
            txtPassword.isSecureTextEntry = false
        }
    }
     
    @IBAction func btnRememberMeClick(_ sender: UIButton) {
        if(AgreeIconClick == false) {
            if let image = UIImage(named: "checkbox") {
                btnRememberMe.setBackgroundImage(image, for: .normal)
            }
            AgreeIconClick = true
            
        } else {
            if let image = UIImage(named: "box") {
                btnRememberMe.setBackgroundImage(image, for: .normal)
            }
            AgreeIconClick = false
        }

    }
    
    @IBAction func btnLoginClick(_ sender: UIButton) {
        if (self.validation()) {
            callLoginAPI()
        }
        
        
//        let validEmailAddress = AppData.sharedInstance.isValidEmailAddress(emailAddressString: txtEmail.text ?? "")
//        let validPassword = AppData.sharedInstance.isValidpassword(passwordString: txtPassword.text ?? "")
//
//        if (validEmailAddress) {
//            if (validPassword) {
//
//            }else {
//              //  AppData.sharedInstance.showAlert(title: "Alert", message: "Invalid Password", viewController: self)
//            }
//        }else {
//           // AppData.sharedInstance.showAlert(title: "Alert", message: "Invalid Email Address", viewController: self)
//        }
        
    }
    
    @IBAction func btnForgotPassClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnSignUpClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

//MARK:- Textfield Delegate Methods
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        return true
    }
}


