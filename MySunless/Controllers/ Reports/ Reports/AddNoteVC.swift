//
//  AddNoteVC.swift
//  MySunless
//
//  Created by iMac on 22/02/22.
//

import UIKit
import Alamofire

class AddNoteVC: UIViewController {

    @IBOutlet var vw_title: UIView!
    @IBOutlet var txtTitle: UITextField!
    @IBOutlet var vw_detail: UIView!
    @IBOutlet var txtVwDetail: UITextView!
    
    var selectedCustomerID = Int()
    var token = String()
    var dictNote = NoteDetail(dict: [:])
    var isForEdit = false
    var selectedNoteID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        self.hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isForEdit {
            txtTitle.text = dictNote.noteTitle
            txtVwDetail.setHTMLFromString(htmlText: dictNote.noteDetail)
        }
    }
    
    func setInitially() {
        vw_title.layer.borderWidth = 0.5
        vw_title.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_detail.layer.borderWidth = 0.5
        vw_detail.layer.borderColor = UIColor.init("#15B0DA").cgColor
    }
    
    func validation() -> Bool {
        if txtTitle.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Note Title", viewController: self)
        } else if txtVwDetail.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Note Detail", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callAddNoteAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["note_title": txtTitle.text ?? "",
                  "note_disc": txtVwDetail.text ?? "",
                  "cid": selectedCustomerID
        ]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_NOTE, param: params, header: headers) { (response, error) in
            print(response ?? "")
            AppData.sharedInstance.dismissLoader()
            
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
    
    func callEditNoteAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["note_title": txtTitle.text ?? "",
                  "note_disc": txtVwDetail.text ?? "",
                  "cid": selectedCustomerID,
                  "id": selectedNoteID
        ]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_NOTE, param: params, header: headers) { (response, error) in
            print(response ?? "")
            AppData.sharedInstance.dismissLoader()
            
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
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        if isForEdit {
            if self.validation() {
                callEditNoteAPI()
            }
        } else {
            if self.validation() {
                callAddNoteAPI()
            }
        }
        
    }
    

}
