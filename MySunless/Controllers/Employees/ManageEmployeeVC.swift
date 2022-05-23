//
//  ManageEmployeeVC.swift
//  MySunless
//
//  Created by iMac on 03/12/21.
//

import UIKit
import Alamofire

class ManageEmployeeVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblEmployeeList: UITableView!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrEmployee = [EmployeeList]()
    var filterdata = [EmployeeList]()
    var searching = false
    var isFirst = true

    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        searchBar.delegate = self
        tblEmployeeList.tableFooterView = UIView()
        
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        callShowEmployeesAPI()
        self.hideKeyboardWhenTappedAround()
        tblEmployeeList.refreshControl = UIRefreshControl()
        tblEmployeeList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            if self.isFirst == false {
                self.arrEmployee.removeAll()
                self.callShowEmployeesAPI()
            }
        }
    }
    
    //MARK:- UserDefined Functions
    func callShowEmployeesAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_EMPLOYEE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
                AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                    AppData.sharedInstance.dismissLoader()
                }
                return
            }
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            for dict in response {
                                self.arrEmployee.append(EmployeeList.init(dict: dict))
                            }
                            self.filterdata = self.arrEmployee
                            DispatchQueue.main.async {
                                self.tblEmployeeList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrEmployee.removeAll()
                            self.filterdata.removeAll()
                            self.tblEmployeeList.reloadData()
                        }
                    }
                }
            }
        }
     }
    
    func callDeleteEmployeesAPI(employeeId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["employee_id" : employeeId]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_EMPLOYEE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.callShowEmployeesAPI()
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
        filterdata = arrEmployee.filter({ (employee:EmployeeList) -> Bool in
            let name = "\(employee.firstName)" + " " + "\(employee.lastName)"
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            return Name != nil
        })
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowEmployeesAPI()
            self.tblEmployeeList.refreshControl?.endRefreshing()
            self.tblEmployeeList.reloadData()
        }
    }
    
    //MARK:- Actions
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        if searching {
            callDeleteEmployeesAPI(employeeId: filterdata[sender.tag].id)
            filterdata.remove(at: sender.tag)
        } else {
            callDeleteEmployeesAPI(employeeId: arrEmployee[sender.tag].id)
            arrEmployee.remove(at: sender.tag)
        }
        
        tblEmployeeList.reloadData()
    }
    
    @IBAction func btnHoursClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "WorkingHoursVC") as! WorkingHoursVC
        let dict = arrEmployee[sender.tag]
        VC.username = dict.userName
        VC.employeeId = dict.id
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnProfile(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "EditEmployeeVC") as! EditEmployeeVC
        let dict = arrEmployee[sender.tag]
        VC.employeeId = dict.id
        isFirst = false
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnAddNewEmployeeClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewEmployeeVC") as! AddNewEmployeeVC
        isFirst = false
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

//MARK:- TableView Delegate and Datasource Methods
extension ManageEmployeeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filterdata.count
        } else {
            return arrEmployee.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblEmployeeList.dequeueReusableCell(withIdentifier: "EmployeeListCell", for: indexPath) as! EmployeeListCell
        cell.btnProfile.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        
        if searching {
            let model = filterdata[indexPath.row]
            let url = URL(string: model.user_image)
            if model.user_image != "" {
                cell.imgEmployee.kf.setImage(with: url)
            } else {
                cell.imgEmployee.image = UIImage(named: "user-profile")
            }
            cell.lblName.text = model.firstName + " " + model.lastName
            cell.lblUsername.text = "(" + model.userName + ")"
            cell.lblEmail.text = model.email
            cell.lblPhonenumber.text = model.phoneNumber
        } else {
            let model = arrEmployee[indexPath.row]
            let url = URL(string: model.user_image)
            if model.user_image != "" {
                cell.imgEmployee.kf.setImage(with: url)
            } else {
                cell.imgEmployee.image = UIImage(named: "user-profile")
            }
            cell.lblName.text = model.firstName + " " + model.lastName
            cell.lblUsername.text = "(" + model.userName + ")"
            cell.lblEmail.text = model.email
            cell.lblPhonenumber.text = model.phoneNumber
        }

        return cell
    }
}

extension ManageEmployeeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//MARK:- SearchBar Delegate Methods
extension ManageEmployeeVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                filterdata = arrEmployee
            }
            tblEmployeeList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblEmployeeList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}
