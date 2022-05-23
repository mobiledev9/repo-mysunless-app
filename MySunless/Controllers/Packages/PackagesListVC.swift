//
//  PackagesListVC.swift
//  MySunless
//
//  Created by iMac on 10/01/22.
//

import UIKit
import Alamofire
import SCLAlertView

class PackagesListVC: UIViewController {
    
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblPackagesList: UITableView!
    
    var token = String()
    var arrPackages = [ShowPackageList]()
    var filterdata = [ShowPackageList]()
    var model = ShowPackageList(dict: [:])
    var searching = false
    
    var alertTitle = "Temporary Delete?"
    var alertSubtitle = "Once deleted, it will move to Archive list!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        searchBar.delegate = self
        tblPackagesList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblPackagesList.refreshControl = UIRefreshControl()
        tblPackagesList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        tblPackagesList.rowHeight = UITableView.automaticDimension
        tblPackagesList.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowPackageAPI()
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
    }
    
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteButton(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    func callShowPackageAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_PACKAGE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrPackages.removeAll()
                            for dict in response {
                                self.arrPackages.append(ShowPackageList(dict: dict))
                            }
                            self.filterdata = self.arrPackages
                            DispatchQueue.main.async {
                                self.tblPackagesList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrPackages.removeAll()
                            self.filterdata.removeAll()
                            self.tblPackagesList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callDeletePackageAPI(packageId:Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["id":packageId]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_PACKAGE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.callShowPackageAPI()
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
    
    func filterContentForSearchText(_ searchText: String) {
        filterdata = arrPackages.filter({ (package:ShowPackageList) -> Bool in
            let name = package.name
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let price = "$" + "\(package.price)"
            let Price = price.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let packageDate = package.tracking
            let PackageDate = packageDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let visit = "\(package.noofvisit)"
            let Visit = visit.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let desc = package.description
            let Desc = desc.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            return Name != nil || Price != nil || PackageDate != nil || Visit != nil || Desc != nil
        })
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowPackageAPI()
            self.tblPackagesList.refreshControl?.endRefreshing()
            self.tblPackagesList.reloadData()
        }
    }
    
    @IBAction func btnAddPackage(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddPackagesVC") as! AddPackagesVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnEditPackage(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddPackagesVC") as! AddPackagesVC
        VC.isForEdit = true
        VC.package = searching ? filterdata[sender.tag] : arrPackages[sender.tag]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnDeletePackage(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @objc func deleteButton(_ sender: UIButton) {
        if searching {
            callDeletePackageAPI(packageId: filterdata[sender.tag].id)
            filterdata.remove(at: sender.tag)
        } else {
            callDeletePackageAPI(packageId: arrPackages[sender.tag].id)
            arrPackages.remove(at: sender.tag)
        }
        tblPackagesList.reloadData()
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        
    }
    
}

//MARK:- TableView Delegate and Datasource Methods
extension PackagesListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filterdata.count
        } else {
            return arrPackages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPackagesList.dequeueReusableCell(withIdentifier: "PackageListCell", for: indexPath) as! PackageListCell
        cell.btnDelete.tag = indexPath.row
        cell.btnEdit.tag = indexPath.row
        if searching {
            model = filterdata[indexPath.row]
        } else {
            model = arrPackages[indexPath.row]
        }
        cell.lblName.text = model.name
        cell.lblPrice.text = "$" + model.price
        cell.lblPackageDate.text = model.tracking
        cell.lblRemainingVisit.text  = model.noofvisit
        cell.lblDescription.text = model.description
        return cell
    }
}

extension PackagesListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension PackagesListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                filterdata = arrPackages
            }
            tblPackagesList.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblPackagesList.reloadData()
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

