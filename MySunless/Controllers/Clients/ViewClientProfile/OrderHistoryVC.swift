//
//  OrderHistoryVC.swift
//  MySunless
//
//  Created by Daydream Soft on 23/03/22.
//

import UIKit
import Alamofire

protocol OrderHistoryProtocol {
    func showUserDetail()
    func viewInvoice()
}

class OrderHistoryVC: UIViewController {

    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblOrderHistoryList: UITableView!
    
    var token = String()
    var arrOrderHistory = [OrderHistory]()
    var arrFilterOrderHistory = [OrderHistory]()
    var searching = false
    var selectedClientId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        tblOrderHistoryList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblOrderHistoryList.refreshControl = UIRefreshControl()
        tblOrderHistoryList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        callOrderHistoryAPI(clientId: selectedClientId)
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        searchBar.delegate = self
    }
    
    func callOrderHistoryAPI(clientId: Int) {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ORDER_HISTORY, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrOrderHistory.removeAll()
                            self.arrFilterOrderHistory.removeAll()
                            for dict in response {
                                self.arrOrderHistory.append(OrderHistory(dictionary: dict)!)
                            }
                            self.arrFilterOrderHistory = self.arrOrderHistory
                            DispatchQueue.main.async {
                                self.tblOrderHistoryList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrOrderHistory.removeAll()
                            self.arrFilterOrderHistory.removeAll()
                            self.tblOrderHistoryList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterOrderHistory = arrOrderHistory.filter({ (orderList: OrderHistory) -> Bool in
            let name = orderList.username
            let Name = name?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let orderdate = AppData.sharedInstance.convertToUTC(dateToConvert: orderList.orderdate ?? "")
            let Orderdate = orderdate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let invoice = orderList.invoiceNumber
            let Invoice = invoice?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let paymentType = orderList.paymentType
            let PaymentType = paymentType?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let amount = "$" + (orderList.paymentAmount ?? "")
            let Amount = amount.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let timediff = orderList.timediff
            let Timediff = timediff?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || Orderdate != nil || Invoice != nil || PaymentType != nil || Amount != nil || Timediff != nil
        })
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPlaceNewOrderClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddOrderVC") as! AddOrderVC
        VC.selectedClientId = selectedClientId
        VC.isEditCompletedOrder = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
  
    @objc func callPullToRefresh() {
        DispatchQueue.main.async {
            self.callOrderHistoryAPI(clientId: self.selectedClientId)
            self.tblOrderHistoryList.refreshControl?.endRefreshing()
            self.tblOrderHistoryList.reloadData()
        }
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension OrderHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterOrderHistory.count
        } else {
            return arrOrderHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOrderHistoryList.dequeueReusableCell(withIdentifier: "OrderHistoryCell", for: indexPath) as! OrderHistoryCell
        if searching {
            cell.model = arrFilterOrderHistory[indexPath.row]
        } else {
            cell.model = arrOrderHistory[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension OrderHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
//MARK:- SearchBar Delegate Methods
extension OrderHistoryVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterOrderHistory = arrOrderHistory
            }
            tblOrderHistoryList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblOrderHistoryList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension OrderHistoryVC: OrderHistoryProtocol {
    func showUserDetail() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func viewInvoice() {
        
    }
}
