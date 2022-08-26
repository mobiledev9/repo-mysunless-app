//
//  EventsTableListVC.swift
//  MySunless
//
//  Created by iMac on 18/05/22.
//

import UIKit
import Alamofire
import Kingfisher
import iOSDropDown
import SCLAlertView

protocol FilterEventsProtocol {
    func updatedEventList(eventDatas : (String,Int)?,
                          userDatas: [(String,String)]?,
                          CustomerDatas:[(String,String)]?,
                          eventStatusDatas :[(String,String)]?,
                          filterBadgeCount: Int
                          )
    
}

class EventsTableListVC: UIViewController {

    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblEventList: UITableView!
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet var lblBadgeCount: UILabel!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrEventList = [EventList]()
    var arrFilterEventList = [EventList]()
    var searching = false
    var alertTitle = "Temporary Delete?"
    var alertSubtitle = "Once deleted, it will move to Archive list!"
    var valSelctedEventDates : (String,Int) = ("",-1)
    var arrSelctedCustomers = [(String,String)]()
    var arrSelctedUsers = [(String,String)]()
    var arrSelctedStatus = [(String,String)]()
    
    //MARK:- ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblEventList.refreshControl = UIRefreshControl()
        tblEventList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        searchBar.delegate = self
        callEventListAPI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callEventListAPI()
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        btnFilter.layer.borderWidth = 0.5
        btnFilter.layer.borderColor = UIColor.init("#FFCA00").cgColor
    }
    
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteButton(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    func callEventListAPI(isFilter : Bool? = false) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        if isFilter! {
            var dict :[String:String] = [:]
            if valSelctedEventDates != ("",-1) {
                dict["FilterDate"] = valSelctedEventDates.0
            }
            if arrSelctedUsers.count > 0 {
                dict["user"] = arrSelctedUsers.map{$0.1}.joined(separator:",")
             }
            if arrSelctedCustomers.count > 0 {
                dict["customer"] = arrSelctedCustomers.map{$0.1}.joined(separator:",")
            }
            if arrSelctedStatus.count > 0 {
                dict["status"] = arrSelctedStatus.map{$0.0}.joined(separator:",")
            }
            params = dict as NSDictionary
            
        } else {
            params = [:]
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
    
    func callUpdateEventStatusAPI(id: Int, status: String) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id,
                  "status": status
        ]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + UPDATE_EVENT_STATUS, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
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
    
    func callDeleteEventAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_EVENT, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.callEventListAPI()
                        }
                    } else {
                        
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterEventList = arrEventList.filter({ (eventList: EventList) -> Bool in
            let username = eventList.username
            let UserName = username.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let name = eventList.FirstName + " " + eventList.LastName
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let email = eventList.Email
            let Email = email.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let phone = eventList.Phone
            let Phone = phone.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let appointmentID = "\(eventList.id)"
            let AppointmentID = appointmentID.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let service = eventList.title
            let Service = service.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let cost = eventList.CostOfService
            let Cost = cost.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let dateTime = eventList.EventDate
            let DateTime = dateTime.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let status = eventList.eventstatus
            let Status = status.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let location = eventList.Location_radio
            let Location = location.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let bookingDate = eventList.datecreated
            let BookingDate = bookingDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return UserName != nil || Name != nil || Email != nil || Phone != nil || AppointmentID != nil || Service != nil || Cost != nil || DateTime != nil || Status != nil || Location != nil || BookingDate != nil
        })
    }
    
    @objc func callPullToRefresh() {
        DispatchQueue.main.async {
            self.callEventListAPI()
            self.tblEventList.refreshControl?.endRefreshing()
            self.tblEventList.reloadData()
        }
    }
    
    //MARK:- Actions
    @IBAction func btnAddClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookAppointmentVC") as! BookAppointmentVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "EventFilterVC") as! EventFilterVC
        VC.isFromFilterList = true
        VC.delegateFilterEventsProtocol = self
        VC.valSelctedEventDates = valSelctedEventDates
        VC.arrSelctedUsers = arrSelctedUsers
        VC.arrSelctedCustomers = arrSelctedCustomers
        VC.arrSelctedStatus = arrSelctedStatus
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnServiceProviderImgClick(_ sender: UIButton) {
    }
    
    @IBAction func btnCustomerImgClick(_ sender: UIButton) {
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookAppointmentVC") as! BookAppointmentVC
        VC.isEditEventList = true
        VC.editEventList = searching ? arrFilterEventList[sender.tag] : arrEventList[sender.tag]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func deleteButton(_ sender: UIButton) {
        if searching {
            callDeleteEventAPI(id: arrFilterEventList[sender.tag].id)
            arrFilterEventList.remove(at: sender.tag)
        } else {
            callDeleteEventAPI(id: arrEventList[sender.tag].id)
            arrEventList.remove(at: sender.tag)
        }
        tblEventList.reloadData()
    }
    
}

//MARK:- TableView Delegate and Datasource Methods
extension EventsTableListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterEventList.count
        } else {
            return arrEventList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblEventList.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as! EventListCell
        
        cell.dropDownStatus.optionArray = ["completed","pending","confirmed","canceled","pending-payment","in-progress"]
        if searching {
            let model = arrFilterEventList[indexPath.row]
            cell.lblServiceProvider.text = model.username
            cell.lblCustomer.text = model.FirstName + " " + model.LastName
            cell.lblEmail.text = model.Email
            cell.lblPhone.text = model.Phone
            cell.lblAppointmentID.text = "\(model.id)"
            cell.lblService.text = model.title
            cell.lblCost.text = model.CostOfService
            cell.lblDateTime.text = model.EventDate
            cell.dropDownStatus.text = model.eventstatus
            cell.lblLocation.text = model.Location_radio
            cell.lblBookingDate.text = AppData.sharedInstance.convertToUTC(dateToConvert: model.datecreated)
            
            let url = URL(string: model.userimg)
            cell.imgServiceProvider.kf.setImage(with: url)
            let profileUrl = URL(string: model.ProfileImg)
            cell.imgCustomer.kf.setImage(with: profileUrl)
            
            cell.dropDownStatus.didSelect{(selectedText, index ,id) in
                print("Selected String: \(selectedText) \n index: \(index),id: \(id)")
                cell.dropDownStatus.selectedIndex = index
                print(model.id)
                self.callUpdateEventStatusAPI(id: model.id, status: selectedText)
            }
        } else {
            let model = arrEventList[indexPath.row]
            cell.lblServiceProvider.text = model.username
            cell.lblCustomer.text = model.FirstName + " " + model.LastName
            cell.lblEmail.text = model.Email
            cell.lblPhone.text = model.Phone
            cell.lblAppointmentID.text = "\(model.id)"
            cell.lblService.text = model.title
            cell.lblCost.text = model.CostOfService
            cell.lblDateTime.text = model.EventDate
            cell.dropDownStatus.text = model.eventstatus
            cell.lblLocation.text = model.Location_radio
            cell.lblBookingDate.text = AppData.sharedInstance.convertToUTC(dateToConvert: model.datecreated)
            
            let url = URL(string: model.userimg)
            cell.imgServiceProvider.kf.setImage(with: url)
            let profileUrl = URL(string: model.ProfileImg)
            cell.imgCustomer.kf.setImage(with: profileUrl)
            
            cell.dropDownStatus.didSelect{(selectedText, index, id) in
                print("Selected String: \(selectedText) \n index: \(index),id: \(id)")
                cell.dropDownStatus.selectedIndex = index
                print(model.id)
                self.callUpdateEventStatusAPI(id: model.id, status: selectedText)
            }
        }
        
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        
        return cell
    }
}

extension EventsTableListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 420
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK:- SearchBar Delegate Methods
extension EventsTableListVC: UISearchBarDelegate {
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

//MARK:- Filter Delegate Methods
extension EventsTableListVC: FilterEventsProtocol {
    func updatedEventList(eventDatas: (String, Int)?, userDatas: [(String, String)]?, CustomerDatas: [(String, String)]?, eventStatusDatas: [(String, String)]?, filterBadgeCount: Int) {

        self.valSelctedEventDates = eventDatas ?? ("",-1)
        self.arrSelctedUsers = userDatas ?? []
        self.arrSelctedCustomers = CustomerDatas ?? []
        self.arrSelctedStatus = eventStatusDatas ?? []
        lblBadgeCount.text = "\(filterBadgeCount)"
        self.callEventListAPI(isFilter: true)
    }
    
    
    
    
}

