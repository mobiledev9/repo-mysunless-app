//
//  TblProfileVC.swift
//  MySunless
//
//  Created by iMac on 16/12/21.
//

import UIKit
import SideMenu
import Alamofire
import SCLAlertView
import GoogleSignIn

class TblProfileVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var tblProfile: UITableView!
    @IBOutlet var lblName: UILabel!
    
    //MARK:- Variable Declarations
    var arrData = [Category]()
    var token = String()
    var alertTitle = "Account Delete?"
    var alertSubtitle = "Once Your account deleted, your current subscription will end and all data of your account will be delete!"
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        arrData = [Category(name: "Account Settings", image: UIImage(named: "user-profile")!, subcategories: []),
                   Category(name: "Logout", image: UIImage(named: "logout")!, subcategories: []),
                   Category(name: "Delete Account", image: UIImage(named: "delete-user")!, subcategories: [])]
        tblProfile.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        tblProfile.tableFooterView = UIView()
       // sidemenu.menuWidth = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetProfileAPI()
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            UserDefaults.standard.set(false, forKey: "setUser")
            UserDefaults.standard.removeObject(forKey: "token")
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(VC, animated: true)
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func addDeleteAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deletePermanently))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }

    @objc func deletePermanently() {
        callDeleteUserAPI()
    }
    
    func callGetProfileAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.GetDictAPICallWith(url: BASE_URL + USER_PROFILE, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let username = res.value(forKey: "username") as? String {
                    self.lblName.text = username
                }
            }
        }
    }
    
    func callLogoutAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + LOGOUT, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Bool {
                    if success == true {
                        if let message = res.value(forKey: "message") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: message)
                            UserDefaults.standard.setValue(false, forKey: "currentSubscription")
                            GIDSignIn.sharedInstance().signOut()
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: message)
                        }
                    }
                }
            }
        }
    }
    
 func callDeleteUserAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_ACCOUNT, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "response") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: message)
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: message)
                        }
                    }
                }
            }
        }
    }
}

//MARK:- Tableview Datasource Methods
extension TblProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProfile.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as! SideMenuCell
        cell.titleLabel.text = arrData[indexPath.row].name
        cell.iconImageView.image = arrData[indexPath.row].image
        cell.expandImageView.isHidden = true
        cell.vw_lock.isHidden = true
        
        return cell
    }
}

//MARK:- Tableview Delegate Methods
extension TblProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "PrrofileVC") as! PrrofileVC
            self.navigationController?.pushViewController(VC, animated: true)
        case 1:
            callLogoutAPI()
        case 2:
            addDeleteAlert()
            
        default:
            print("Default")
        }
    }
    
}
