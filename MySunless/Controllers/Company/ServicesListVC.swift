//
//  ServicesListVC.swift
//  MySunless
//
//  Created by Daydream Soft on 04/03/22.
//

import UIKit
import Alamofire
import SCLAlertView

class ServicesListVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblServicesList: UITableView!
   
    //MARK:- Variable Declarations
    var token = String()
    var arrListOfService = [ShowListOfService]()
    var arrFilterListOfService = [ShowListOfService]()
    var searching = false
    var model = ShowListOfService(dict: [:])
    var arrChooseuser = [ChooseUser]()
    var alertTitle = "Temporary Delete?"
    var alertSubtitle = "Once deleted, it will move to Archive list!"
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        callShowListOfServiceAPI()
        
        tblServicesList.tableFooterView = UIView()
        tblServicesList.estimatedRowHeight = 180
        tblServicesList.rowHeight = UITableView.automaticDimension
        tblServicesList.refreshControl = UIRefreshControl()
        tblServicesList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        tblServicesList.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowListOfServiceAPI()
        callFilterListUserAPI()
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        searchBar.delegate = self
    }
    
    func callShowListOfServiceAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_LISTOFSERVICE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
                AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                    AppData.sharedInstance.dismissLoader()
                }
                return
            }
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrListOfService.removeAll()
                            for dict in response {
                                self.arrListOfService.append(ShowListOfService(dict: dict))
                            }
                            self.arrFilterListOfService = self.arrListOfService
                            DispatchQueue.main.async {
                                self.tblServicesList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            self.arrListOfService.removeAll()
                            self.arrFilterListOfService.removeAll()
                            self.tblServicesList.reloadData()
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callDeleteServiceAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["delid": id]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_SERVICE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.callShowListOfServiceAPI()
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
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterListOfService = arrListOfService.filter({ (servicelist: ShowListOfService) -> Bool in
            let name = servicelist.ServiceName
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let price = "$" + servicelist.Price
            let Price = price.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let duration = servicelist.Duration
            let Duration = duration.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let user = servicelist.userbane
            let User = user.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || Price != nil || Duration != nil || User != nil
        })
    }
    
    func callFilterListUserAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        
        APIUtilities.sharedInstance.PpOSTArrayAPICallWith(url: BASE_URL + FILTER_CHOOSE_USER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? [[String:Any]] {
                self.arrChooseuser.removeAll()
                for dict in res {
                    self.arrChooseuser.append(ChooseUser(dict: dict))
                }
            }
        }
    }
    
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteButton(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowListOfServiceAPI()
            self.tblServicesList.refreshControl?.endRefreshing()
            self.tblServicesList.reloadData()
        }
    }
    
    //MARK:- Actions
    @IBAction func btnAddNewServiceClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewServiceVC") as! AddNewServiceVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnManagePackageClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PackagesListVC") as! PackagesListVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewServiceVC") as! AddNewServiceVC
        VC.isForEdit = true
        VC.showServiceData = arrListOfService[sender.tag]
        VC.arrChooseUser = arrChooseuser
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func deleteButton(_ sender: UIButton) {
        if searching {
            callDeleteServiceAPI(id: arrFilterListOfService[sender.tag].id)
            arrFilterListOfService.remove(at: sender.tag)
        } else {
            callDeleteServiceAPI(id: arrListOfService[sender.tag].id)
            arrListOfService.remove(at: sender.tag)
        }
        tblServicesList.reloadData()
    }
}

//MARK:- UITableView Datasource Methods
extension ServicesListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterListOfService.count
        } else {
            return arrListOfService.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblServicesList.dequeueReusableCell(withIdentifier: "ServicesListCell", for: indexPath) as! ServicesListCell
        if searching {
            model = arrFilterListOfService[indexPath.row]
        } else {
            model = arrListOfService[indexPath.row]
        }
        cell.lblServiceName.text = model.ServiceName
        cell.lblPrice.text = "$" + model.Price
        cell.lblDuration.text = model.Duration
        cell.lblUser.text = model.userbane
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        
        return cell
    }
    
}

//MARK:- UITableView Delegate Methods
/*extension ServicesListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
} */

//MARK:- SearchBar Delegate Methods
extension ServicesListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterListOfService = arrListOfService
            }
            tblServicesList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblServicesList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}
