//
//  PackageListVC.swift
//  MySunless
//
//  Created by Daydream Soft on 23/03/22.
//

import UIKit
import Alamofire

protocol PackageHistoryProtocol {
    func showUserDetail()
}

class PackageListVC: UIViewController {

    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblPackageList: UITableView!
    
    var token = String()
    var selectedClientId = Int()
    var arrPackageHistory = [PackageHistory]()
    var arrFilterPackageHistory = [PackageHistory]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        tblPackageList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblPackageList.refreshControl = UIRefreshControl()
        tblPackageList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        callPackageHistoryAPI(clientId: selectedClientId)
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        searchBar.delegate = self
    }
    
    func callPackageHistoryAPI(clientId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["clientid": clientId]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + PACKAGE_HISTORY, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrPackageHistory.removeAll()
                            self.arrFilterPackageHistory.removeAll()
                            for dict in response {
                                self.arrPackageHistory.append(PackageHistory(dict: dict))
                            }
                            self.arrFilterPackageHistory = self.arrPackageHistory
                            DispatchQueue.main.async {
                                self.tblPackageList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrPackageHistory.removeAll()
                            self.arrFilterPackageHistory.removeAll()
                            self.tblPackageList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterPackageHistory = arrPackageHistory.filter({(packageList: PackageHistory) -> Bool in
            let name = packageList.packageCreatorName
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let datetime = AppData.sharedInstance.convertToUTC(dateToConvert: packageList.odatecreated)
            let Datetime = datetime.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let packageName = packageList.Name
            let PackageName = packageName.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let serviceReamining = packageList.Noofvisit
            let ServiceReamining = serviceReamining.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let timediff = packageList.timediff
            let Timediff = timediff.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || Datetime != nil || PackageName != nil || ServiceReamining != nil || Timediff != nil
        })
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddPackageClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddOrderVC") as! AddOrderVC
        VC.selectedClientId = selectedClientId
        VC.isEditCompletedOrder = true
        VC.isFromPackageListVC = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func callPullToRefresh() {
        DispatchQueue.main.async {
            self.callPackageHistoryAPI(clientId: self.selectedClientId)
            self.tblPackageList.refreshControl?.endRefreshing()
            self.tblPackageList.reloadData()
        }
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension PackageListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterPackageHistory.count
        } else {
            return arrPackageHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPackageList.dequeueReusableCell(withIdentifier: "Client_PackageCell", for: indexPath) as! Client_PackageCell
        if searching {
            cell.model = arrFilterPackageHistory[indexPath.row]
        } else {
            cell.model = arrPackageHistory[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension PackageListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension PackageListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterPackageHistory = arrPackageHistory
            }
            tblPackageList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblPackageList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension PackageListVC: PackageHistoryProtocol {
    func showUserDetail() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
