//
//  SendEmailVC.swift
//  MySunless
//
//  Created by iMac on 03/05/22.
//

import UIKit
import iOSDropDown
import Alamofire

class SendEmailVC: UIViewController {

    @IBOutlet var vw_from: UIView!
    @IBOutlet var txtFrom: UITextField!
    @IBOutlet var vw_to: UIView!
    @IBOutlet var txtTo: DropDown!
    @IBOutlet var txtToColview: UICollectionView!
    @IBOutlet var vw_template: UIView!
    @IBOutlet var txtTemplate: DropDown!
    @IBOutlet var vw_subject: UIView!
    @IBOutlet var txtSubject: UITextField!
    @IBOutlet var vw_message: UIView!
    @IBOutlet var txtVwMessage: UITextView!
    
    var token = String()
    var selectedClient = String()
    var arrClients = [ClientList]()
    var arrSMSClient = [String]()
    var arrSelectedClientIds = [String]()
    var arrSelectedClientEmails = [String]()
    var arrTemplate = [ShowTemplate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        hideKeyboardWhenTappedAround()
        didSelectUser()
    }
    
    func setInitially() {
        vw_from.layer.borderWidth = 0.5
        vw_from.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_to.layer.borderWidth = 0.5
        vw_to.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_template.layer.borderWidth = 0.5
        vw_template.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_subject.layer.borderWidth = 0.5
        vw_subject.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_message.layer.borderWidth = 0.5
        vw_message.layer.borderColor = UIColor.init("15B0DA").cgColor
        txtFrom.delegate = self
        txtTo.delegate = self
        txtTemplate.delegate = self
        txtSubject.delegate = self
        txtVwMessage.delegate = self
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        txtToColview?.addGestureRecognizer(tap)
        txtToColview.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowTemplateAPI()
    }
    
    func setValidation() -> Bool {
        if txtFrom.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter your email id", viewController: self)
        } else if arrSMSClient.count == 0 {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select at least one recipient", viewController: self)
        } else if txtSubject.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter email subject", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func didSelectUser() {
        self.txtTo.optionArray = arrClients.map{$0.firstName + " " + $0.lastName + " (" + $0.email + ")"}
        self.txtTo.optionIds = arrClients.map{$0.id}
        self.txtTo.didSelect { (selectedText, index, id) in
            self.txtTo.selectedIndex = index
            self.txtToColview.isHidden = false
            self.selectedClient = selectedText
            if !self.arrSMSClient.contains(self.selectedClient) {
                self.arrSMSClient.append(self.selectedClient)
                self.arrSelectedClientIds.append("\(id)")
            }
            DispatchQueue.main.async {
                self.txtToColview.reloadData()
            }
        }
    }
    
    func getEmailById() {
        var arrSelectedClient = [ClientList]()
        arrSelectedClientEmails.removeAll()
        for i in self.arrSelectedClientIds {
            if self.arrClients.contains(where: {$0.id == Int(i)}) {
                arrSelectedClient = self.arrClients.filter{$0.id == Int(i)}
                arrSelectedClientEmails.append(contentsOf: arrSelectedClient.map{$0.email})
            }
        }
    }
    
    func callShowTemplateAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + VIEW_TEMPLATE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "message") as? [[String:Any]] {
                            self.arrTemplate.removeAll()
                            for dict in response {
                                self.arrTemplate.append(ShowTemplate(dict: dict))
                            }
                            self.txtTemplate.optionArray = self.arrTemplate.map{$0.Name}
                            self.txtTemplate.optionIds = self.arrTemplate.map{$0.id}
                            self.txtTemplate.didSelect { (selectedText, index, id) in
                                for dic in self.arrTemplate {
                                    if id == dic.id {
                                        self.txtSubject.text = dic.Subject
                                        self.txtTemplate.text = dic.Name
                                    }
                                }
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "message") as? String {
                            print(response)
                        }
                    }
                }
            }
        }
    }
    
    func callSendMailAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["from": txtFrom.text ?? "",
                  "to": arrSelectedClientEmails.joined(separator: ","),
                  "subject": txtSubject.text ?? "",
                  "message": txtVwMessage.text ?? "",
                  "cid": arrSelectedClientIds.joined(separator: ",")
        ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SEND_MAIL, param: params, header: headers) { (respnse, error) in
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
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnManageTemplateClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "TemplatesVC") as! TemplatesVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnCreateTemplateClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateTemplateVC") as! CreateTemplateVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnResetClick(_ sender: UIButton) {
        txtTo.text = ""
        txtToColview.isHidden = true
        txtTemplate.text = ""
        txtSubject.text = ""
        txtVwMessage.text = ""
        arrSMSClient.removeAll()
        arrSelectedClientIds.removeAll()
        arrSelectedClientEmails.removeAll()
    }
    
    @IBAction func btnSendClick(_ sender: UIButton) {
        if setValidation() {
            getEmailById()
            callSendMailAPI()
        }
    }
    
    @IBAction func btnCloseTxtToCell(_ sender: UIButton) {
        arrSMSClient.remove(at: sender.tag)
        arrSelectedClientIds.remove(at: sender.tag)
        txtToColview.reloadData()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 100
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension SendEmailVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtTo.resignFirstResponder()
        txtTemplate.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFrom.resignFirstResponder()
        txtSubject.resignFirstResponder()
        return true
    }
}

extension SendEmailVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == txtVwMessage {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        txtVwMessage.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
}

extension SendEmailVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: txtToColview)
        if let indexPath = txtToColview?.indexPathForItem(at: point),
           let cell = txtToColview?.cellForItem(at: indexPath) {
            return touch.location(in: cell).y > 50
        }
        txtTo.showList()
        return true
    }
}

//MARK:- Collection view Delegate Methods
extension SendEmailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSMSClient.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = txtToColview.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.cellView.layer.cornerRadius = 8
        cell.lblName.text = arrSMSClient[indexPath.item]
        cell.btnClose.tag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: arrSMSClient[indexPath.item].size(withAttributes: nil).width + 120, height: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        txtTo.showList()
    }
}
