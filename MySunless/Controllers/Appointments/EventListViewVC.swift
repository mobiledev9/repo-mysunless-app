//
//  EventListViewVC.swift
//  MySunless
//
//  Created by Daydream Soft on 04/04/22.
//

import UIKit
import Alamofire

class EventListViewVC: UIViewController {
    
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblListView: UITableView!
    @IBOutlet var vw_BtnFilter: UIView!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrAppointment = [ShowAppointmentList]()
    var filterdata = [ShowAppointmentList]()
    var searching = false

    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblListView.tableFooterView = UIView()
        tblListView.refreshControl = UIRefreshControl()
        tblListView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowListAppointment()
    }
    
    //MARK:- User-Defined Functions
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 5.0
        searchBar.delegate = self
    }
    
    //MARK:- API Call
    func callShowListAppointment() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + LIST_APPOINTMENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrAppointment.removeAll()
                            for dict in response {
                                self.arrAppointment.append(ShowAppointmentList(dictionary: dict as NSDictionary)!)
                            }
                            self.filterdata = self.arrAppointment
                            
                            DispatchQueue.main.async {
                                self.tblListView.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrAppointment.removeAll()
                            self.filterdata.removeAll()
                            DispatchQueue.main.async {
                                self.tblListView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filterdata = arrAppointment.filter({(appointment: ShowAppointmentList) -> Bool in
            let client_firstname = appointment.client_firstname
            let ClientFirstname = client_firstname?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let client_Lastname = appointment.client_Lastname
            let ClientLastname = client_Lastname?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let eventDate = appointment.eventDate
            let EventDate = eventDate?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let end_date = appointment.end_date
            let EndDate = end_date?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let title = appointment.title
            let Title = title?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let client_email = appointment.client_email
            let ClientEmail = client_email?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let client_phone = appointment.client_phone
            let ClientPhone = client_phone?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let eventstatus = appointment.eventstatus
            let EventStatus = eventstatus?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let username = appointment.username
            let UserName = username?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return ClientFirstname != nil || ClientLastname != nil || EventDate != nil || EndDate != nil || Title != nil || ClientEmail != nil || ClientPhone != nil || EventStatus != nil || UserName != nil
        })
    }
    
    //MARK:- Actions
    @objc func callPullToRefresh() {
        DispatchQueue.main.async {
            self.callShowListAppointment()
            self.tblListView.refreshControl?.endRefreshing()
            self.tblListView.reloadData()
        }
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension EventListViewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filterdata.count
        } else {
            return arrAppointment.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblListView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as! ListViewCell
        if searching {
            cell.modelAppointment = arrAppointment[indexPath.row]
        } else {
            cell.modelAppointment = arrAppointment[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension EventListViewVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension EventListViewVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                filterdata = arrAppointment
            }
            tblListView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblListView.reloadData()
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

//MARK:- Protocol Methods
extension EventListViewVC: PaymentHistoryCellProtocol {
    func updatePaymentHistory(ReportDatas: (String, Int)?, userDatas: [(String, String)]?, CustomerDatas: [(String, String)]?, CategoryDatas: (String, Int)?, filterBadgeCount: Int) {
        
    }
    
    func showUserDetail() {
    }
    
    func viewInvoice(orderId: Int) {
        
    }
    
    func showClientDetail(clientId: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ClientDetailVC") as! ClientDetailVC
        VC.selectedId = clientId
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func editEventListView(index: Int) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
        VC.appointment = arrAppointment[index]
        navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
    
}

