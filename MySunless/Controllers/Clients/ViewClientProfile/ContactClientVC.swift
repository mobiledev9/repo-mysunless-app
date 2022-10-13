//
//  ContactClientVC.swift
//  MySunless
//
//  Created by Daydream Soft on 24/03/22.
//

import UIKit
import Alamofire

protocol ContactHistoryProtocol {
    func showUserDetail()
}

class ContactClientVC: UIViewController {

    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var vw_ContactDetail: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblContactClientList: UITableView!
    
    var token = String()
    var selectedClientId = Int()
    var arrContactHistory = [ContactHistory]()
    var arrFilterContactHistory = [ContactHistory]()
    var searching = false
    var clientEmail = String()
    var clientPhone = String()
    var clientAddress = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        tblContactClientList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblContactClientList.refreshControl = UIRefreshControl()
        tblContactClientList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        lblEmail.text = clientEmail
        lblPhone.text = clientPhone
        lblAddress.text = clientAddress
        callContactClientAPI(clientId: selectedClientId)
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        vw_ContactDetail.layer.borderWidth = 0.5
        vw_ContactDetail.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_ContactDetail.layer.cornerRadius = 12
        searchBar.delegate = self
     }
    
    func callContactClientAPI(clientId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["custid": clientId]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CONTACT_CLIENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrContactHistory.removeAll()
                            self.arrFilterContactHistory.removeAll()
                            for dict in response {
                                self.arrContactHistory.append(ContactHistory(dict: dict))
                            }
                            self.arrFilterContactHistory = self.arrContactHistory
                            DispatchQueue.main.async {
                                self.tblContactClientList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrContactHistory.removeAll()
                            self.arrFilterContactHistory.removeAll()
                            self.tblContactClientList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterContactHistory = arrContactHistory.filter({ (contactList: ContactHistory) -> Bool in
            let name = contactList.firstname + " " + contactList.lastname
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let type = contactList.type
            let Type = type.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let communicationDetail = contactList.subject
            let CommunicationDetail = communicationDetail.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let dateTime = AppData.sharedInstance.convertToUTC(dateToConvert: contactList.comtime)
            let DateTime = dateTime.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || Type != nil || CommunicationDetail != nil || DateTime != nil
        })
    }
 
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendSMSClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SendSMSVC") as! SendSMSVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnSendMailClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SendEmailVC") as! SendEmailVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
   
    @objc func callPullToRefresh() {
        DispatchQueue.main.async {
            self.callContactClientAPI(clientId: self.selectedClientId)
            self.tblContactClientList.refreshControl?.endRefreshing()
            self.tblContactClientList.reloadData()
        }
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension ContactClientVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterContactHistory.count
        } else {
            return arrContactHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblContactClientList.dequeueReusableCell(withIdentifier: "ContactClientCell", for: indexPath) as! ContactClientCell
        if searching {
            cell.model = arrFilterContactHistory[indexPath.row]
        } else {
            cell.model = arrContactHistory[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension ContactClientVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension ContactClientVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterContactHistory = arrContactHistory
            }
            tblContactClientList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblContactClientList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension ContactClientVC: ContactHistoryProtocol {
    func showUserDetail() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
