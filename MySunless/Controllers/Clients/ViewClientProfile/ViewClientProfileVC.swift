//
//  ViewClientProfileVC.swift
//  MySunless
//
//  Created by Daydream Soft on 16/03/22.
//

import UIKit
import Alamofire
import Kingfisher
import SCLAlertView

struct clientAction {
    var title : String = ""
    var image : UIImage = UIImage()
}

class ViewClientProfileVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var vw_clientDetails: UIView!
    @IBOutlet var imgClientProfile: UIImageView!
    @IBOutlet var lblClientName: UILabel!
    @IBOutlet var lblClientEmail: UILabel!
    @IBOutlet var lblClientPhone: UILabel!
    @IBOutlet var lblClientAddress: UILabel!
    @IBOutlet var tblListOfAction: UITableView!
    @IBOutlet var vw_lastServiceDate: UIView!
    @IBOutlet var lblLastServiceDate: UILabel!
    @IBOutlet var vw_giftCardBalance: UIView!
    @IBOutlet var lblGiftCardBalance: UILabel!
    
    var selctedIndex = -1
    var arrClientAction : [clientAction] = [clientAction(title: "Note",
                                                         image: UIImage(named:"sticky-note")!),
                                            clientAction(title: "Event History",
                                                         image: UIImage(named: "date")!),
                                            clientAction(title: "Document",
                                                         image: UIImage(named: "folder")!),
                                            clientAction(title: "Contact Client",
                                                         image: UIImage(named: "id-card")!),
                                            clientAction(title: "Order History",
                                                         image: UIImage(named: "history-1")!),
                                            clientAction(title: "Package",
                                                         image: UIImage(named: "box-1")!)
                                       ]
    var token = String()
    var selectedID = Int()
    var streetaddress = String()
    var city = String()
    var zip = String()
    var state = String()
    var country = String()
    var alertTitle = "Temporary Delete?"
    var alertSubtitle = "Once deleted, it will move to Archive list!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callViewSingleClient(id: selectedID)
        callLastServiceDateAPI(id: selectedID)
        callGiftCardBalanceAPI(id: selectedID)
    }
    
    func setInitially() {
        vw_clientDetails.layer.borderWidth = 0.5
        vw_clientDetails.layer.borderColor = UIColor.init("#15B0DA").cgColor
        tblListOfAction.layer.borderWidth = 0.5
        tblListOfAction.layer.borderColor = UIColor.init("#6D778E").cgColor
        tblListOfAction.layer.cornerRadius = 8
        vw_lastServiceDate.layer.borderWidth = 0.5
        vw_lastServiceDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_giftCardBalance.layer.borderWidth = 0.5
        vw_giftCardBalance.layer.borderColor = UIColor.init("#15B0DA").cgColor
        imgClientProfile.layer.cornerRadius = imgClientProfile.frame.size.height / 2
    }
    
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteClick(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    func callViewSingleClient(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["clientid": id]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SINGLE_CLIENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? NSDictionary {
                            if let imgProfile = response.value(forKey: "ProfileImg") as? String {
                                if let imgUrl = URL(string: imgProfile) {
                                    self.imgClientProfile.kf.setImage(with: imgUrl)
                                }
                            }
                            if let fname = response.value(forKey: "FirstName") as? String {
                                if let lname = response.value(forKey: "LastName") as? String {
                                    self.lblClientName.text = fname.capitalized + " " + lname.capitalized
                                }
                            }
                            if let email = response.value(forKey: "email") as? String {
                                self.lblClientEmail.text = email
                            }
                            if let phone = response.value(forKey: "Phone") as? String {
                                self.lblClientPhone.text = phone
                            }
                            if let address = response.value(forKey: "Address") as? String {
                                self.streetaddress = address
                            }
                            if let city = response.value(forKey: "City") as? String {
                                self.city = city
                            }
                            if let zip = response.value(forKey: "Zip") as? String {
                                self.zip = zip
                            }
                            if let state = response.value(forKey: "State") as? String {
                                self.state = state
                            }
                            if let country = response.value(forKey: "Country") as? String {
                                self.country = country
                            }
                            self.lblClientAddress.text = self.streetaddress + ", " + self.city + ", " + self.zip + ", " + self.state + ", " + self.country
                        }
                    }
                }
            }
        }
    }
    
    func callDeleteClientAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_CLIENTID, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.alert(message: message, viewController: self) { (action) in
                                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ClientsVC") as! ClientsVC
                                self.navigationController?.pushViewController(VC, animated: true)
                            }
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callLastServiceDateAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["clientid": id]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + LAST_SERVICE_DATE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let lastservicedate = res.value(forKey: "lastservicedate") as? String {
                            self.lblLastServiceDate.text = lastservicedate
                        }
                    } else {
//                        if let lastservicedate = res.value(forKey: "lastservicedate") as? String {
//                            AppData.sharedInstance.showAlert(title: "", message: lastservicedate, viewController: self)
//                        }
                    }
                }
            }
        }
    }
    
    func callGiftCardBalanceAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["clientid": id]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + GIFT_CARD_BALANCE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let giftbal = res.value(forKey: "giftbal") as? Int {
                            self.lblGiftCardBalance.text = "$\(giftbal)"
                        }
                    } else {
//                        if let giftbal = res.value(forKey: "giftbal") as? String {
//                            AppData.sharedInstance.showAlert(title: "", message: giftbal, viewController: self)
//                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnEditClient(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerDetailsVC") as! CustomerDetailsVC
        VC.isFromClientDetail = true
        VC.selectedClientDetailID = selectedID
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnDeleteClient(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @objc func deleteClick(_ sender: UIButton) {
        callDeleteClientAPI(id: selectedID)
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension ViewClientProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrClientAction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblListOfAction.dequeueReusableCell(withIdentifier: "SelectClientCell", for: indexPath) as! SelectClientCell
        let model = arrClientAction[indexPath.row]
        
        if selctedIndex == indexPath.row {
            cell.view.backgroundColor = UIColor.init("15B0DA")
            cell.imgView.setImageColor(color: UIColor.white)
            cell.lblText.textColor = UIColor.white
            cell.imgView.image = model.image
            cell.lblText.text = model.title
        } else if selctedIndex != indexPath.row {
            cell.view.backgroundColor = UIColor.white
            cell.imgView.setImageColor(color: UIColor.init("#6D778E"))
            cell.lblText.textColor = UIColor.init("#6D778E")
            cell.imgView.image = model.image
            cell.lblText.text = model.title
        }
        return cell
    }
}

extension ViewClientProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return 60 //140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selctedIndex = indexPath.row
        switch indexPath.row {
            case 0:
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "NoteListVC") as! NoteListVC
                VC.selectedClientId = selectedID
                self.navigationController?.pushViewController(VC, animated: true)
            case 1:
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "EventHistoryVC") as! EventHistoryVC
                VC.selectedClientId = selectedID
                self.navigationController?.pushViewController(VC, animated: true)
            case 2:
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "DocumentVC") as! DocumentVC
                VC.selectedClientId = selectedID
                self.navigationController?.pushViewController(VC, animated: true)
            case 3:
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ContactClientVC") as! ContactClientVC
                VC.selectedClientId = selectedID
                VC.clientEmail = lblClientEmail.text ?? ""
                VC.clientPhone = lblClientPhone.text ?? ""
                VC.clientAddress = lblClientAddress.text ?? ""
                self.navigationController?.pushViewController(VC, animated: true)
            case 4:
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "OrderHistoryVC") as! OrderHistoryVC
                VC.selectedClientId = selectedID
                self.navigationController?.pushViewController(VC, animated: true)
            case 5:
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "PackageListVC") as! PackageListVC
                VC.selectedClientId = selectedID
                self.navigationController?.pushViewController(VC, animated: true)
            default:
                print("Default")
        }
       // tblListOfAction.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tblListOfAction.reloadData()
//    }
}

//MARK:- UITableViewCell Method
class SelectClientCell : UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var view: UIView!
    @IBOutlet var lblText: UILabel!
}
