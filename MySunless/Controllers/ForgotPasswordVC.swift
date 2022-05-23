//
//  ForgotPasswordVC.swift
//  MySunless
//
//  Created by iMac on 18/10/21.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var vw_email: UIView!
    @IBOutlet var txtEmail: UITextField!
    
    //MARK:- Variable Declarations
    
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vw_email.layer.borderWidth = 0.5
        vw_email.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    //MARK:- User-Defined Functions
    func validation() -> Bool {
        if txtEmail.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter email", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callResetPasswordAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [
            "email" : txtEmail.text ?? ""
        ]
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + FORGOT_PASSWORD, param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                          //  print(message)
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
    
    //MARK:- Actions
    @IBAction func btnResetPasswordClick(_ sender: UIButton) {
        if (self.validation()) {
            callResetPasswordAPI()
        }
    }
    
    @IBAction func btnLoginClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    

}
