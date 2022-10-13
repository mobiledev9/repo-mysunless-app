//
//  SendSMSVC.swift
//  MySunless
//
//  Created by Daydream Soft on 17/03/22.
//

import UIKit
import iOSDropDown
import Alamofire

class SendSMSVC: UIViewController {

    @IBOutlet var vw_To: UIView!
    @IBOutlet var txtTo: DropDown!
    @IBOutlet var toClientCollectionView: UICollectionView!
    @IBOutlet var vw_BookingURL: UIView!
    @IBOutlet var txtBookingURL: UITextField!
    @IBOutlet var vw_txtVwAddMessage: UIView!
    @IBOutlet var txtVwAddMessage: UITextView!
    
    var token = String()
    var selectedClient = String()
    var arrClients = [ClientList]()
    var arrSMSClient = [String]()
    var arrSelectedClientIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        hideKeyboardWhenTappedAround()
        txtTo.delegate = self
        txtBookingURL.delegate = self
       // txtVwAddMessage.delegate = self
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        didSelectUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        toClientCollectionView.isHidden = true
    }
    
    func setInitially() {
        vw_To.layer.borderWidth = 0.5
        vw_To.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_BookingURL.layer.borderWidth = 0.5
        vw_BookingURL.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_txtVwAddMessage.layer.borderWidth = 0.5
        vw_txtVwAddMessage.layer.borderColor = UIColor.init("15B0DA").cgColor
        txtBookingURL.text = "https://new.mysunless.com/crm/Book-now?ref=NA=="
        
        let tap = UITapGestureRecognizer(target: self, action: nil)
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        toClientCollectionView?.addGestureRecognizer(tap)
        
        toClientCollectionView.isHidden = true
    
    }
    
    func validation() -> Bool {
        if arrSMSClient.count < 0 {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select at least one recipient", viewController: self)
        } else if txtVwAddMessage.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter message", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func didSelectUser() {
        self.txtTo.optionArray = arrClients.map{$0.firstName + " " + $0.lastName + " - " + $0.phone}
        self.txtTo.optionIds = arrClients.map{$0.id}
        self.txtTo.didSelect { (selectedText, index, id) in
            self.txtTo.selectedIndex = index
            self.toClientCollectionView.isHidden = false
            self.selectedClient = selectedText
            if !self.arrSMSClient.contains(self.selectedClient) {
                self.arrSMSClient.append(self.selectedClient)
                self.arrSelectedClientIds.append("\(id)")
            }
            DispatchQueue.main.async {
                self.toClientCollectionView.reloadData()
            }
        }
    }
    
    func callSendSmsToClientAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["clientId": arrSelectedClientIds.joined(separator: ","),
                  "message": txtVwAddMessage.text ?? "",
                  "bookingUrl": txtBookingURL.text ?? ""
                 ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SEND_SMS_TO_CLIENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [String] {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response.joined(separator: ","))
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
    
    @IBAction func btnCloseClientCellClick(_ sender: UIButton) {
        arrSMSClient.remove(at: sender.tag)
        arrSelectedClientIds.remove(at: sender.tag)
        toClientCollectionView.reloadData()
    }
    
    @IBAction func btnSendClick(_ sender: UIButton) {
        if validation() {
            callSendSmsToClientAPI()
        }
    }

}

//MARK:- Textfield Delegate Methods
extension SendSMSVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtBookingURL.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtTo.resignFirstResponder()
    }
}

//MARK:- TextView Delegate Methods
extension SendSMSVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        //txtVwAddMessage.resignFirstResponder()
    }
    
}

//MARK:- Collection view Delegate Methods
extension SendSMSVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSMSClient.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = toClientCollectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.cellView.layer.cornerRadius = 8
        cell.lblName.text = arrSMSClient[indexPath.item]
        cell.btnClose.tag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: arrSMSClient[indexPath.item].size(withAttributes: nil).width + 100, height: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        txtTo.showList()
    }
}

extension SendSMSVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: toClientCollectionView)
        if let indexPath = toClientCollectionView?.indexPathForItem(at: point),
           let cell = toClientCollectionView?.cellForItem(at: indexPath) {
            return touch.location(in: cell).y > 50
        }
        txtTo.showList()
        return false
    }
}

