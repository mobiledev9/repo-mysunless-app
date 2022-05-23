//
//  EventHistoryVC.swift
//  MySunless
//
//  Created by Daydream Soft on 23/03/22.
//

import UIKit
import iOSDropDown
import Alamofire

protocol EventHistoryProtocol {
    func showUserDetail()
    func editEventHistory(eventId: Int)
    func deleteEventHistory(eventId: Int)
}

class EventHistoryVC: UIViewController {

    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var vw_Filter: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblEventList: UITableView!
    @IBOutlet var txtEventStatus: DropDown!
    
    var token = String()
    var arrEventList = [EventList]()
    var arrFilterEventList = [EventList]()
    var searching = false
    var selectedClientId = Int()
    var eventStatus = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        setEventStatus()
        tblEventList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblEventList.refreshControl = UIRefreshControl()
        tblEventList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        callEventHistoryAPI(filter: false)
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        vw_Filter.layer.borderWidth = 0.5
        vw_Filter.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_Filter.layer.cornerRadius = 12
        searchBar.delegate = self
        txtEventStatus.text = "All"
    }
    
    func setEventStatus() {
        txtEventStatus.optionArray = ["all","completed","pending","confirmed","canceled","pending-payment","in-progress"]
        txtEventStatus.didSelect{(selectedText, index, id) in
            self.txtEventStatus.selectedIndex = index
            switch selectedText {
                case "all":
                    self.eventStatus = ""
                    self.callEventHistoryAPI(filter: false)
                case "completed":
                    self.eventStatus = "completed"
                    self.callEventHistoryAPI(filter: true)
                case "pending":
                    self.eventStatus = "pending"
                    self.callEventHistoryAPI(filter: true)
                case "confirmed":
                    self.eventStatus = "confirmed"
                    self.callEventHistoryAPI(filter: true)
                case "canceled":
                    self.eventStatus = "canceled"
                    self.callEventHistoryAPI(filter: true)
                case "pending-payment":
                    self.eventStatus = "pending-payment"
                    self.callEventHistoryAPI(filter: true)
                case "in-progress":
                    self.eventStatus = "in-progress"
                    self.callEventHistoryAPI(filter: true)
                default:
                    self.callEventHistoryAPI(filter: false)
            }
        }
    }
    
    func callEventHistoryAPI(filter: Bool) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        if filter {
            params = ["customer": selectedClientId,
                      "status": eventStatus
            ]
        } else {
            params = ["customer": selectedClientId]
        }
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_EVENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrEventList.removeAll()
                            self.arrFilterEventList.removeAll()
                            for dict in response {
                                self.arrEventList.append(EventList(dict: dict))
                            }
                            self.arrFilterEventList = self.arrEventList
                            DispatchQueue.main.async {
                                self.tblEventList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrEventList.removeAll()
                            self.arrFilterEventList.removeAll()
                            self.tblEventList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterEventList = arrEventList.filter({ (eventList: EventList) -> Bool in
            let name = eventList.FirstName + " " + eventList.LastName + "(" + eventList.username + ")"
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let appointmentID = "\(eventList.id)"
            let AppointmentID = appointmentID.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let service = eventList.title
            let Service = service.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let dateTime = eventList.EventDate
            let DateTime = dateTime.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let status = eventList.eventstatus
            let Status = status.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let bookingDate = eventList.datecreated
            let BookingDate = bookingDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let timediff = eventList.timediff
            let Timediff = timediff.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || AppointmentID != nil || Service != nil || DateTime != nil || Status != nil || BookingDate != nil || Timediff != nil
        })
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRefreshClick(_ sender: UIButton) {
        txtEventStatus.text = "All"
        callEventHistoryAPI(filter: false)
    }
    
    @objc func callPullToRefresh() {
        DispatchQueue.main.async {
            self.txtEventStatus.text = "All"
            self.callEventHistoryAPI(filter: false)
            self.tblEventList.refreshControl?.endRefreshing()
            self.tblEventList.reloadData()
        }
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension EventHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterEventList.count
        } else {
            return arrEventList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblEventList.dequeueReusableCell(withIdentifier: "EventHistoryCell", for: indexPath) as! EventHistoryCell
        if searching {
            cell.model = arrFilterEventList[indexPath.row]
        } else {
            cell.model = arrEventList[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension EventHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension EventHistoryVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterEventList = arrEventList
            }
            tblEventList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblEventList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension EventHistoryVC: EventHistoryProtocol {
    func showUserDetail() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func editEventHistory(eventId: Int) {
        
    }
    
    func deleteEventHistory(eventId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": eventId]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_EVENT, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.callPullToRefresh()
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
}
