//
//  CreateTemplateVC.swift
//  MySunless
//
//  Created by iMac on 03/01/22.
//

import UIKit
import Alamofire

class CreateTemplateVC: UIViewController {

    @IBOutlet var vw_name: UIView!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var vw_subject: UIView!
    @IBOutlet var txtSubject: UITextField!
    @IBOutlet var vw_txtVwMessage: UIView!
    @IBOutlet var txtVwMessage: UITextView!
    
    var token = String()
    var isForEdit = false
    var emailTemplate:ShowTemplate = ShowTemplate(dict:[:])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        self.hideKeyboardWhenTappedAround()
        
        txtName.delegate = self
        txtSubject.delegate = self
        txtVwMessage.delegate = self
        
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isForEdit {
            self.txtName.text = emailTemplate.Name
            self.txtSubject.text = emailTemplate.Subject
            self.txtVwMessage.setHTMLFromString(htmlText: emailTemplate.TextMassage)
        }
    }
    
    func setInitially() {
        vw_name.layer.borderWidth = 0.5
        vw_name.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_subject.layer.borderWidth = 0.5
        vw_subject.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_txtVwMessage.layer.borderWidth = 0.5
        vw_txtVwMessage.layer.borderColor = UIColor.init("15B0DA").cgColor
    }
    
    func validation() -> Bool {
        if txtName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Enter Name", viewController: self)
        } else if txtSubject.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Enter Subject", viewController: self)
        } else if txtVwMessage.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Enter Message", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callAddTemplateAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["name" : txtName.text ?? "",
                  "subject" : txtSubject.text ?? "",
                  "message" : txtVwMessage.text ?? ""
        ]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_TEMPLATE, param: params, header: headers) { (response, error) in
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
    
    func callEditTemplateAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["name" : txtName.text ?? "",
                  "subject" : txtSubject.text ?? "",
                  "message" : txtVwMessage.text ?? "",
                  "tmp_id" : emailTemplate.id
        ]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + EDIT_TEMPLATE, param: params, header: headers) { (response, error) in
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
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: UIButton) {
        if isForEdit {
            if (validation()) {
                callEditTemplateAPI()
            }
        } else {
            if (validation()) {
                callAddTemplateAPI()
            }
        }
       // _ = navigationController?.popViewController(animated: true)
        
    }

}

//MARK:- Textfield Delegate Methods
extension CreateTemplateVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtName.resignFirstResponder()
        txtSubject.resignFirstResponder()
        return true
    }
}

//MARK:- TextView Delegate Methods
extension CreateTemplateVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        txtVwMessage.resignFirstResponder()
    }
}
