//
//  InvoiceTemplateVC.swift
//  MySunless
//
//  Created by Daydream Soft on 15/04/22.
//

import UIKit
import Alamofire

class InvoiceTemplateVC: UIViewController {

    @IBOutlet weak var txtvwNotes: UITextView!
    @IBOutlet weak var vw_Notes: UIView!
    @IBOutlet weak var txtvwFooter: UITextView!
    @IBOutlet weak var vw_Footer: UIView!
    
    var token = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    func setInitially() {
        vw_Notes.layer.borderWidth = 0.5
        vw_Notes.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_Notes.layer.cornerRadius = 12
        vw_Footer.layer.borderWidth = 0.5
        vw_Footer.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_Footer.layer.cornerRadius = 12
        txtvwNotes.delegate = self
        txtvwFooter.delegate = self
    }
    
    func callupdateInvoiceNotesAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["note": txtvwNotes.text ?? "",
                  "footer": txtvwFooter.text ?? ""
        ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + UPDATE_INVOICE_NOTES, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
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

    @IBAction func btnSubmitClick(_ sender: UIButton) {
        callupdateInvoiceNotesAPI()
    }
    
    @IBAction func btnPreviewClick(_ sender: UIButton) {
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension InvoiceTemplateVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == txtvwNotes {
            
        } else if textView == txtvwFooter {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtvwNotes {
            txtvwNotes.resignFirstResponder()
        } else if textView == txtvwFooter {
            txtvwFooter.resignFirstResponder()
            NotificationCenter.default.removeObserver(self)
        }
    }
}

