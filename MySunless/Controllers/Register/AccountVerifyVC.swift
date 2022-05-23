//
//  AccountVerifyVC.swift
//  MySunless
//
//  Created by iMac on 09/10/21.
//

import UIKit

class AccountVerifyVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var vw_Main: UIView!
    @IBOutlet var txtEnterOTP: UITextField!
    @IBOutlet var vw_EnterOTP: UIView!
    
    //MARK:- Variable Declarations
    var email = String()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vw_EnterOTP.layer.borderWidth = 0.5
        vw_EnterOTP.layer.borderColor = UIColor.gray.cgColor
        
        vw_Main.layer.cornerRadius = 12
        vw_Main.layer.masksToBounds = true
        
        vw_Main.backgroundColor = UIColor.white
        vw_Main.layer.shadowColor = UIColor.lightGray.cgColor
        vw_Main.layer.shadowOpacity = 0.8
        vw_Main.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_Main.layer.shadowRadius = 6.0
        vw_Main.layer.masksToBounds = false
        
        txtEnterOTP.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    //MARK:- User-Defined Functions
    func validation() -> Bool {
        if txtEnterOTP.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter OTP", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callVerifyOTPAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [
            "otp": txtEnterOTP.text ?? "",
            "email": email
        ]
      //  print("PARAM :=> \(params)")
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + VERIFY_CODE, param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
//                        if let resp = res.value(forKey: "data") as? NSDictionary {
//                            print(resp)
//
//                            let model = UserModel()
//                            model.initModel(attributeDict: resp)
//                            UserManager.shared = model
//                            UserManager.saveUserData()
                            
                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PersonalInfoVC") as! PersonalInfoVC
                        self.navigationController?.pushViewController(VC, animated: true)
//                        }
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
    @IBAction func btnVerifyClick(_ sender: UIButton) {
        if (self.validation()) {
            callVerifyOTPAPI()
        }
        
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PersonalInfoVC") as! PersonalInfoVC
//        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    @IBAction func btnResendClick(_ sender: UIButton) {
    }
    
}

//MARK:- Textfield Delegate Methods
extension AccountVerifyVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtEnterOTP.resignFirstResponder()
        return true
    }
}
