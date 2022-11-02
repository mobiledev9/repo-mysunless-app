//
//  RequestedEventListVC.swift
//  MySunless
//
//  Created by Daydream Soft on 04/04/22.
//

import UIKit
import Alamofire

@objc protocol RequestedEventProtocol {
    func callAcceptAppointmentAPI(id: Int)
    @objc optional func callNotAcceptAppointmentAPI(id: Int)
}

class RequestedEventListVC: UIViewController {
    
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblRequestedEventList: UITableView!
    
    var token = String()
    var arrRequestedList = [RequestedEventList]()
    var arrFilterRequestedList = [RequestedEventList]()
    var searching = false
    var delegate : chnageEventProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        tblRequestedEventList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblRequestedEventList.refreshControl = UIRefreshControl()
        tblRequestedEventList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callRequestedEventListAPI()
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        searchBar.delegate = self
    }
    
    func callRequestedEventListAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + REQUESTED_EVENT_LIST, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    self.arrRequestedList.removeAll()
                    self.arrFilterRequestedList.removeAll()
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                           for dict in response {
                                self.arrRequestedList.append(RequestedEventList(dictionary: dict)!)
                            }
                            self.arrFilterRequestedList = self.arrRequestedList
                            DispatchQueue.main.async {
                                self.tblRequestedEventList.reloadData()
                                
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                            DispatchQueue.main.async {
                                self.tblRequestedEventList.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterRequestedList = arrRequestedList.filter({(appointment: RequestedEventList) -> Bool in
            let title = appointment.title
            let Title = title?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let serviceProvider = (appointment.firstname ?? "") + " " + (appointment.lastname ?? "")
            let ServiceProvider = serviceProvider.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let clientName = (appointment.firstName ?? "") + " " + (appointment.lastName ?? "")
            let ClientName = clientName.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let phone = appointment.phone
            let Phone = phone?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let eventDate = appointment.eventDate
            let EventDate = eventDate?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Title != nil || ServiceProvider != nil || ClientName != nil || Phone != nil || EventDate != nil 
        })
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callRequestedEventListAPI()
            self.tblRequestedEventList.refreshControl?.endRefreshing()
            self.tblRequestedEventList.reloadData()
        }
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension RequestedEventListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterRequestedList.count
        } else {
            return arrRequestedList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblRequestedEventList.dequeueReusableCell(withIdentifier: "RequestedEventsCell", for: indexPath) as! RequestedEventsCell
        if searching {
            cell.model = arrFilterRequestedList[indexPath.row]
        } else {
            cell.model = arrRequestedList[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension RequestedEventListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension RequestedEventListVC: RequestedEventProtocol {
    func callAcceptAppointmentAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["id": id]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ACCEPT_APPOINTMENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                            self.callRequestedEventListAPI()
                            self.delegate?.callLoadCalenderView()
                            
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
    
    func callNotAcceptAppointmentAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["id": id]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + NOT_ACCEPT_APPOINTMENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                            self.callRequestedEventListAPI()
                      
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
}

//MARK:- SearchBar Delegate Methods
extension RequestedEventListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterRequestedList = arrRequestedList
            }
            tblRequestedEventList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblRequestedEventList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}
