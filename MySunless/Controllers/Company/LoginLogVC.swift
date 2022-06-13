//
//  LoginLogVC.swift
//  MySunless
//
//  Created by iMac on 01/03/22.
//

import UIKit
import Alamofire

protocol UpdateLoginLog {
    func updateLoginLogList(date: String, userId: Int, filterBadgeCount: Int)
}

class LoginLogVC: UIViewController {

    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet var tblLoginLog: UITableView!
    @IBOutlet var lblFilterBadgeCount: UILabel!
    
    var token = String()
    var arrShowLoginLog = [ShowLoginLog]()
    var arrFilterLoginLog = [ShowLoginLog]()
    var searching = false
    var model = ShowLoginLog(dict: [:])
    var userID = Int()
    var daate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        tblLoginLog.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        searchBar.delegate = self
        callShowLoginLogAPI(filter: false)
        tblLoginLog.refreshControl = UIRefreshControl()
        tblLoginLog.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnFilter.layer.borderWidth = 0.5
        btnFilter.layer.borderColor = UIColor.init("#15B0DA").cgColor
        lblFilterBadgeCount.layer.cornerRadius = lblFilterBadgeCount.frame.size.width / 2
        lblFilterBadgeCount.layer.masksToBounds = true
        lblFilterBadgeCount.isHidden = true
    }
    
    func callShowLoginLogAPI(filter: Bool) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        if filter {
            params = ["SubscriberID": userID,
                      "Date": daate
            ]
        } else {
            params = [:]
        }
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_LOGINLOG, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.tblLoginLog.isHidden = false
                            self.arrShowLoginLog.removeAll()
                            for dict in response {
                                self.arrShowLoginLog.append(ShowLoginLog(dict: dict))
                            }
                            
                            self.arrFilterLoginLog = self.arrShowLoginLog
                            DispatchQueue.main.async {
                                self.tblLoginLog.reloadData()
                            }
                        }
                    } else if success == 0 {
                        if let message = res.value(forKey: "message") as? String {
                            self.arrShowLoginLog.removeAll()
                            self.arrFilterLoginLog.removeAll()
                            self.tblLoginLog.isHidden = true
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func convertToUTC(dateToConvert:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var convertedDate = formatter.date(from: dateToConvert)
        formatter.timeZone = TimeZone(identifier: "UTC")
        let date = formatter.date(from: dateToConvert)
        convertedDate = Calendar.current.date(byAdding: .minute, value: 330, to: date ?? Date())
        return formatter.string(from: convertedDate!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterLoginLog = arrShowLoginLog.filter({ (loginLog: ShowLoginLog) -> Bool in
            let username = loginLog.username
            let UserName = username.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let localLoginTime = "Local:" + " " + loginLog.LoginTime
            let LocalLoginTime = localLoginTime.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let utcLoginTime = "UTC:" + " " + convertToUTC(dateToConvert: model.LoginTime)
            let UTCLoginTime = utcLoginTime.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let localLogoutTime = "Local:" + " " + loginLog.LogoutTime
            let LocalLogoutTime = localLogoutTime.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let utcLogoutTime = "UTC:" + " " + convertToUTC(dateToConvert: model.LogoutTime)
            let UTCLogoutTime = utcLogoutTime.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            var runTime = String()
            runTime = "\(loginLog.RunTime)"
            if runTime == "0" {
                runTime = "Invalid date"
            }
            let RunTime = runTime.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let ip = loginLog.REMOTE_ADDR
            let IP = ip.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let device = loginLog.HTTP_USER_AGENT
            let Device = device.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return UserName != nil || LocalLoginTime != nil || UTCLoginTime != nil || LocalLogoutTime != nil || UTCLogoutTime != nil || RunTime != nil || IP != nil || Device != nil
        })  
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowLoginLogAPI(filter: false)
            self.tblLoginLog.refreshControl?.endRefreshing()
            self.tblLoginLog.reloadData()
        }
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginLogFilterVC") as! LoginLogFilterVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.isFromLoginLog = true
        VC.delegate = self
        self.present(VC, animated: true, completion: nil)
    }
    
    

}

//MARK:- UITableView Datasource Methods
extension LoginLogVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterLoginLog.count
        } else {
            return arrShowLoginLog.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblLoginLog.dequeueReusableCell(withIdentifier: "LoginLogCell", for: indexPath) as! LoginLogCell
        
        if searching {
            model = arrFilterLoginLog[indexPath.row]
        } else {
            model = arrShowLoginLog[indexPath.row]
        }
        
        let userimgUrl = URL(string: model.userimg)
        cell.imgUser.kf.setImage(with: userimgUrl)
        cell.lblUsername.text = model.username
        cell.lblLocalLoginTime.text = "Local:" + " " + model.LoginTime
        
        if model.LoginTime != "" {
            cell.lblUTCLoginTime.text = "UTC:" + " " + convertToUTC(dateToConvert: model.LoginTime)
        } else {
            cell.lblUTCLoginTime.text = "UTC:"
        }
        
        cell.lblLocalLogoutTime.text = "Local:" + " " + model.LogoutTime
        
        if model.LogoutTime != "" {
            cell.lblUTCLogoutTime.text = "UTC:" + " " + convertToUTC(dateToConvert: model.LogoutTime)
        } else {
            cell.lblUTCLogoutTime.text = "UTC:"
        }
        
        if model.RunTime != 0 {
            cell.lblRunTime.text = "\(model.RunTime)"
        } else {
            cell.lblRunTime.text = "Invalid date"
        }
        
        cell.lblIP.text = model.REMOTE_ADDR
        cell.txtVwDevice.text = model.HTTP_USER_AGENT
        
        return cell
    }
    
}

//MARK:- UITableView Delegate Methods
extension LoginLogVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

//MARK:- SearchBar Delegate Methods
extension LoginLogVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterLoginLog = arrShowLoginLog
            }
            tblLoginLog.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblLoginLog.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension LoginLogVC: UpdateLoginLog {
    func updateLoginLogList(date: String, userId: Int, filterBadgeCount: Int) {
        daate = date
        userID = userId
        if filterBadgeCount == 0 {
            lblFilterBadgeCount.isHidden = true
        } else {
            lblFilterBadgeCount.isHidden = false
            lblFilterBadgeCount.text = "\(filterBadgeCount)"
        }
        
        callShowLoginLogAPI(filter: true)
    }
}
