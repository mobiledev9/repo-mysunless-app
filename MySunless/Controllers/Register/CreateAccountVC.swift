//
//  CreateAccountVC.swift
//  MySunless
//
//  Created by iMac on 09/10/21.
//

import UIKit

class CreateAccountVC: UIViewController, CAAnimationDelegate {
    
    //MARK:- Outlets
    @IBOutlet var vw_Email: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var vw_Password: UIView!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var vw_ConfirmPassword: UIView!
    @IBOutlet var txtConfirmPassword: UITextField!
    @IBOutlet var vw_Main: UIView!
    
    //MARK:- Variable Declarations
    
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vw_Email.layer.borderWidth = 0.5
        vw_Email.layer.borderColor = UIColor.gray.cgColor
        
        vw_Password.layer.borderWidth = 0.5
        vw_Password.layer.borderColor = UIColor.gray.cgColor
        
        vw_ConfirmPassword.layer.borderWidth = 0.5
        vw_ConfirmPassword.layer.borderColor = UIColor.gray.cgColor

        vw_Main.layer.cornerRadius = 12
        vw_Main.layer.masksToBounds = true
        
        vw_Main.backgroundColor = UIColor.white
        vw_Main.layer.shadowColor = UIColor.lightGray.cgColor
        vw_Main.layer.shadowOpacity = 0.8
        vw_Main.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_Main.layer.shadowRadius = 6.0
        vw_Main.layer.masksToBounds = false
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //MARK:- User-Defined Functions
//    func imgSlideInFromLeft(view: UIView)
//    {
//        let transition:CATransition = CATransition()
//        transition.duration = 0
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        transition.delegate = self
//        view.layer.add(transition, forKey: "transition")
//    }
    
    func validation() -> Bool {
        
        if txtEmail.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter email", viewController: self)
        } else if txtPassword.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter password", viewController: self)
        } else if txtConfirmPassword.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter confirm password", viewController: self)
        } else if txtPassword.text != txtConfirmPassword.text {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Passwords do not match", viewController: self)
        } else if !(txtEmail.text!.isValidEmail) {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter valid email id", viewController: self)
        } else {
            return true
        }
        return false
    }
    //
    
    func callSendOTPAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [
            "email": txtEmail.text ?? "",
            "password": txtPassword.text ?? ""
        ]
       // print("PARAM :=> \(params)")
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + SEND_CODE, param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let userId = res.value(forKey: "userid") as? Int {
                            UserDefaults.standard.setValue(userId, forKey: "userid")
                        }
                        //                        if let resp = res.value(forKey: "data") as? NSDictionary {
                        //                            print(resp)
                        //
//                                                    let model = UserModel()
//                                                    model.initModel(attributeDict: res)
//                                                    UserManager.shared = model
//                                                    UserManager.saveUserData()
                        //                        }
                        
                        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
                        if let conVC = storyBoard.instantiateViewController(withIdentifier: "AccountVerifyVC") as? AccountVerifyVC,
                           let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                            conVC.email = self.txtEmail.text ?? ""
                            navController.pushViewController(conVC, animated: true)
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
    
    //MARK:- Actions
    @IBAction func btnNextClick(_ sender: UIButton) {
        if (self.validation()) {
            let name = txtEmail.text?.stringBefore("@")
            UserDefaults.standard.setValue(name, forKey: "username")
            callSendOTPAPI()
        }
        
//        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
//        if let conVC = storyBoard.instantiateViewController(withIdentifier: "AccountVerifyVC") as? AccountVerifyVC,
//           let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
//            conVC.email = self.txtEmail.text ?? ""
//            navController.pushViewController(conVC, animated: true)
//        }
        
    }
    
    @IBAction func btnLoginClick(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
        if let conVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC,
           let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navController.pushViewController(conVC, animated: true)
        }
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
    
}

//MARK:- Textfield Delegate Methods
extension CreateAccountVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
        return true
    }
}
