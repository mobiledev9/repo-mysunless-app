//
//  AllSubscribersVC.swift
//  MySunless
//
//  Created by Daydream Soft on 11/06/22.
//

import UIKit
import Alamofire
import SCLAlertView

protocol SubscriberProtocol {
    func callSubscriberListAPI(isFilter: Bool, userId: String?, filterBadgeCount: Int?)
    func callSubscriberStatusAPI(subscriberId: Int, loginPermission: String)
}

class AllSubscribersVC: UIViewController {

    @IBOutlet weak var vw_searchBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblFilterBadge: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var tblSubscribersList: UITableView!
    
    var token = String()
    var arrSubscriber = [SubscriberList]()
    var arrFilterSubscriber = [SubscriberList]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        tblSubscribersList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        callSubscriberListAPI(isFilter: false)
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        searchBar.delegate = self
        lblFilterBadge.layer.cornerRadius = lblFilterBadge.frame.size.width / 2
        lblFilterBadge.layer.masksToBounds = true
        lblFilterBadge.isHidden = true
        btnFilter.layer.cornerRadius = 12
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            DispatchQueue.main.async {
                self.callSubscriberListAPI(isFilter: false)
            }
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterSubscriber = arrSubscriber.filter({ (subscriberList: SubscriberList) -> Bool in
            let username = subscriberList.username
            let UserName = username.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let usertype = "(" + subscriberList.usertype + ")"
            let UserType = usertype.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let name = subscriberList.firstname + " " + subscriberList.lastname
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let companyname = subscriberList.companyname
            let CompanyName = companyname.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let email = subscriberList.email
            let Email = email.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let phone = subscriberList.phonenumber
            let Phone = phone.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let createdDate = subscriberList.created_at
            let CreatedDate = createdDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let customerProfile = "\(subscriberList.clientc)"
            let CustomerProfile = customerProfile.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let daysAgo = subscriberList.timediff
            let DaysAgo = daysAgo.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return UserName != nil || UserType != nil || Name != nil || CompanyName != nil || Email != nil || Phone != nil || CreatedDate != nil || CustomerProfile != nil || DaysAgo != nil
        })
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ClientsFilterVC") as! ClientsFilterVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        VC.isFromAdminSubscriber = true
        VC.delegateAdmin = self
        self.present(VC, animated: true, completion: nil)
    }
}

extension AllSubscribersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterSubscriber.count
        } else {
            return arrSubscriber.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSubscribersList.dequeueReusableCell(withIdentifier: "SubscriberListCell", for: indexPath) as! SubscriberListCell
        if searching {
            cell.model = arrFilterSubscriber[indexPath.row]
        } else {
            cell.model = arrSubscriber[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension AllSubscribersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension AllSubscribersVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterSubscriber = arrSubscriber
            }
            tblSubscribersList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblSubscribersList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension AllSubscribersVC: SubscriberProtocol {
    func callSubscriberListAPI(isFilter: Bool, userId: String? = nil, filterBadgeCount: Int? = nil) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        if isFilter {
            params = ["userId": userId ?? 0]
        } else {
            params = [:]
        }
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SUBSCRIBER_LIST, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrSubscriber.removeAll()
                            for dict in response {
                                self.arrSubscriber.append(SubscriberList(dict: dict))
                            }
                            self.arrFilterSubscriber = self.arrSubscriber
                            if isFilter {
                                if filterBadgeCount == 0 {
                                    self.lblFilterBadge.isHidden = true
                                } else {
                                    self.lblFilterBadge.isHidden = false
                                    self.lblFilterBadge.text = "\(filterBadgeCount ?? 0)"
                                }
                            }
                            DispatchQueue.main.async {
                                self.tblSubscribersList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callSubscriberStatusAPI(subscriberId: Int, loginPermission: String) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["subscriberId": subscriberId,
                  "loginPermission": loginPermission
        ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SUBSCRIBER_STATUS, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let Message = res.value(forKey: "Message") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: Message)
                        }
                    } else {
                        if let Message = res.value(forKey: "Message") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: Message)
                        }
                    }
                }
            }
        }
    }
}

