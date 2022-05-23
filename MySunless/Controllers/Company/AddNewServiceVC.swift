//
//  AddNewServiceVC.swift
//  MySunless
//
//  Created by Daydream Soft on 04/03/22.
//

import UIKit
import Alamofire
import iOSDropDown

class AddNewServiceVC: UIViewController {
    
    @IBOutlet var vw_name: UIView!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var vw_price: UIView!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var vw_duration: UIView!
    @IBOutlet var txtDuration: DropDown!
    @IBOutlet var vw_user: UIView!
    @IBOutlet var txtUser: DropDown!
    @IBOutlet var vw_appointmentInstruction: UIView!
    @IBOutlet var txtVwappointmentInstruction: UITextView!
    @IBOutlet var userCollectionView: UICollectionView!

    var token = String()
    var arrChooseUser = [ChooseUser]()
    var arrSelectedIds = [String]()
    var arrUsers = [String]()
    var selectedUser = String()
    var isForEdit = false
    var showServiceData = ShowListOfService(dict:[:])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        callFilterListUserAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callFilterListUserAPI()
        if isForEdit {
            txtName.text = showServiceData.ServiceName
            txtPrice.text = showServiceData.Price
            txtDuration.text = showServiceData.Duration
            
            arrUsers = showServiceData.userbane.components(separatedBy: ",")

            userCollectionView.reloadData()
            if arrUsers.count != 0 {
                for item in arrChooseUser {
                    if arrUsers.contains(item.UserName) {
                        arrSelectedIds.append("\(item.id)")
                    }
                }
                userCollectionView.isHidden = false
            } else {
                userCollectionView.isHidden = true
            }
            txtVwappointmentInstruction.text = showServiceData.Info
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        arrUsers.removeAll()
//    }
    
    func setInitially() {
        vw_name.layer.borderWidth = 0.5
        vw_name.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_price.layer.borderWidth = 0.5
        vw_price.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_duration.layer.borderWidth = 0.5
        vw_duration.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_user.layer.borderWidth = 0.5
        vw_user.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_appointmentInstruction.layer.borderWidth = 0.5
        vw_appointmentInstruction.layer.borderColor = UIColor.init("15B0DA").cgColor
        txtDuration.optionArray = serviceDuration
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(gesture(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        userCollectionView?.addGestureRecognizer(tap)
        
        userCollectionView.isHidden = true
    }
    
    func validation() -> Bool {
        if txtName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter service name", viewController: self)
        } else if txtPrice.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter service price", viewController: self)
        } else if txtDuration.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select service duration", viewController: self)
        } else if txtUser.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select user", viewController: self)
        } else if txtVwappointmentInstruction.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter service info", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callFilterListUserAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        
        APIUtilities.sharedInstance.PpOSTArrayAPICallWith(url: BASE_URL + FILTER_CHOOSE_USER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? [[String:Any]] {
                self.arrChooseUser.removeAll()
                for dict in res {
                    self.arrChooseUser.append(ChooseUser(dict: dict))
                }
            
                self.didSelectUser()
                
            }
        }
    }
    
    func callAddNewServiceAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["Service_Name": txtName.text ?? "",
                  "Service_Price": txtPrice.text ?? "",
                  "Duration": txtDuration.text ?? "",
                  "User": arrSelectedIds.joined(separator: ","),
                  "Appointment_Instruction": txtVwappointmentInstruction.text ?? ""
        ]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_NEW_SERVICE, param: params, header: headers) { (respnse, error) in
            print(respnse ?? "")
            AppData.sharedInstance.dismissLoader()
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
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
    
    func callUpdateServiceAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["Service_Name": txtName.text ?? "",
                  "Service_Price": txtPrice.text ?? "",
                  "Duration": txtDuration.text ?? "",
                  "User": arrSelectedIds.joined(separator: ","),
                  "Appointment_Instruction": txtVwappointmentInstruction.text ?? "",
                  "id": showServiceData.id
        ]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_NEW_SERVICE, param: params, header: headers) { (respnse, error) in
            print(respnse ?? "")
            AppData.sharedInstance.dismissLoader()
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
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
    
    func didSelectUser() {
        self.txtUser.optionArray = self.arrChooseUser.map { $0.UserName }
        self.txtUser.optionIds = self.arrChooseUser.map { $0.id }
        self.txtUser.didSelect{(selectedText, index ,id) in
            self.txtUser.selectedIndex = index
            self.userCollectionView.isHidden = false
            self.selectedUser = selectedText
            if !self.arrUsers.contains(self.selectedUser) {
                self.arrUsers.append(self.selectedUser)
                self.arrSelectedIds.append("\(id)")
            }
            DispatchQueue.main.async {
                self.userCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func btnCloseUserCellClick(_ sender: UIButton) {
//        arrUsers.remove(at: sender.tag)
//        arrSelectedIds.remove(at: sender.tag)
//        userCollectionView.reloadData()
//    }
    
    @IBAction func btnSubmitServiceClick(_ sender: UIButton) {
        if isForEdit {
            callUpdateServiceAPI()
        } else {
            if validation() {
                callAddNewServiceAPI()
            }
        }
        
    }
    
    @objc func gesture(_ sender: UITapGestureRecognizer) {
//        let point = sender.location(in: userCollectionView)
//        if let indexPath = userCollectionView?.indexPathForItem(at: point) {
//            print(#function, indexPath)
//            txtUser.showList()
//        }
    }
    
    @objc func closeUserCellClick(_ sender: UIButton) {
        arrUsers.remove(at: sender.tag)
        arrSelectedIds.remove(at: sender.tag)
        userCollectionView.reloadData()
    }

}

extension AddNewServiceVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: userCollectionView)
        if let indexPath = userCollectionView?.indexPathForItem(at: point),
           let cell = userCollectionView?.cellForItem(at: indexPath) {
            return touch.location(in: cell).y > 50
        }
        txtUser.showList()
        return false
    }
}

//MARK:- CollectionView Delegate Methods
extension AddNewServiceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userCollectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.cellView.layer.cornerRadius = 8
        cell.lblName.text = arrUsers[indexPath.item]
        cell.btnClose.tag = indexPath.item
        cell.btnClose.addTarget(self, action: #selector(closeUserCellClick(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        txtUser.showList()
    }
}

class UserCell: UICollectionViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var lblName: UILabel!
}
