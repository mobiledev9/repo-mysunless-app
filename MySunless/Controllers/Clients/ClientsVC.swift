//
//  ClientsVC.swift
//  MySunless
//
//  Created by iMac on 29/11/21.
//

import UIKit
import Alamofire
import Kingfisher
import SCLAlertView

protocol UpdateClientData {
    func editButton(id: Int)
    func callDeleteClientAPI(id: [String])
    func showClientDetailVC(id: Int)
    func showClientProfileVC(id: Int)
}

class ClientsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var btnImgCheckAll: UIButton!
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet var tblClientList: UITableView!
    @IBOutlet var lblFilterBadgeCount: UILabel!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrClients = [ClientList]()
    var filterdata = [ClientList]()
    var searching = false
    var model = ClientList(dict: [:])
    var alertTitle = "Temporary Delete?"
    var alertSubtitle = "Once deleted, it will move to Archive list!"
    var arrSelectedIds = [String]()
    var isCheckAll = false
  //  var arrSMSClientList = [String]()
    var arrImport : [ClientAction] = [ClientAction(title: "Google",
                                                         image: UIImage(named: "google") ?? UIImage()),
                                            ClientAction(title: "Outlook",
                                                         image: UIImage(named: "outlook") ?? UIImage()),
                                            ClientAction(title: "Excel",
                                                         image: UIImage(named: "excel") ?? UIImage())
    ]
    var arrExport : [ClientAction] = [ClientAction(title: "Google",
                                                         image: UIImage(named: "google") ?? UIImage()),
                                            ClientAction(title: "Excel",
                                                         image: UIImage(named: "excel") ?? UIImage()),
                                            ClientAction(title: "OneDrive",
                                                         image: UIImage(named: "onedrive") ?? UIImage()),
                                            ClientAction(title: "DropBox",
                                                         image: UIImage(named: "dropbox") ?? UIImage())
    ]
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        tblClientList.tableFooterView = UIView()
        btnFilter.layer.borderWidth = 0.5
        btnFilter.layer.borderColor = UIColor.init("#FFCA00").cgColor
        
        searchBar.delegate = self
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        self.hideKeyboardWhenTappedAround()
        
        tblClientList.refreshControl = UIRefreshControl()
        tblClientList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrSelectedIds.removeAll()
        callGetAllClientsAPI()
        searchBar.text = ""
    }
    
    //MARK:- User-defined Functions
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteButton(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    func callGetAllClientsAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ALL_CLIENTS, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrClients.removeAll()
                            for dict in response {
                                self.arrClients.append(ClientList.init(dict: dict))
                            }
//                            for dic in self.arrClients {
//                                self.arrSMSClientList.append(dic.firstName + " " + dic.lastName + " - " + dic.phone)
//                            }
                            self.filterdata = self.arrClients
                            DispatchQueue.main.async {
                                self.tblClientList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrClients.removeAll()
                            self.filterdata.removeAll()
                            self.tblClientList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filterdata = arrClients.filter({ (client:ClientList) -> Bool in
            let name = "\(client.firstName)" + " " + "\(client.lastName)"
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let phone = client.phone
            let Phone = phone.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let email = client.email
            let Email = email.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || Phone != nil || Email != nil
        })
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callGetAllClientsAPI()
            self.tblClientList.refreshControl?.endRefreshing()
            self.tblClientList.reloadData()
        }
    }
    
    //MARK:- Actions
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddCustomerClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerDetailsVC") as! CustomerDetailsVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnSendSMSClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SendSMSVC") as! SendSMSVC
        VC.arrClients = arrClients
//        VC.arrSMSClient = arrSMSClientList
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnImportClick(_ sender: UIButton) {
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ImportExportVC") as! ImportExportVC
//        VC.headerTitle = "Import"
//        VC.arrImportExport = arrImport
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnExportClick(_ sender: UIButton) {
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ImportExportVC") as! ImportExportVC
//        VC.headerTitle = "Export"
//        VC.arrImportExport = arrExport
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnCheckAllImgClick(_ sender: UIButton) {
        if (sender.currentImage?.description.contains("square.fill") == true) {
            sender.setImage(UIImage(named: "check-box"), for: .normal)
            isCheckAll = true
            for dic in arrClients {
                arrSelectedIds.append("\(dic.id)")
            }
        } else {
            sender.setImage(UIImage(systemName: "square.fill"), for: .normal)
            isCheckAll = false
            arrSelectedIds.removeAll()
        }
        tblClientList.reloadData()
    }
    
    @IBAction func btnSendEmailClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SendEmailVC") as! SendEmailVC
        VC.arrClients = arrClients
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        if arrSelectedIds.count != 0 {
            addRestoreAlert()
        } else {
            AppData.sharedInstance.showAlert(title: "", message: "Please select client", viewController: self)
        }
        
    }
    
    @objc func deleteButton(_ sender: UIButton) {
        callDeleteClientAPI(id: arrSelectedIds)
//        if searching {
//            callDeleteClientAPI(id: ["\(filterdata[sender.tag].id)"])
//            filterdata.remove(at: sender.tag)
//        } else {
//            callDeleteClientAPI(id: ["\(arrClients[sender.tag].id)"])
//            arrClients.remove(at: sender.tag)
//        }
        arrSelectedIds.removeAll()
        tblClientList.reloadData()
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ClientsFilterVC") as! ClientsFilterVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        self.present(VC, animated: true, completion: nil)
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension ClientsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filterdata.count
        } else {
            return arrClients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblClientList.dequeueReusableCell(withIdentifier: "ClientListCell", for: indexPath) as! ClientListCell
        if searching {
            cell.modelClient = filterdata[indexPath.row]
        } else {
            cell.modelClient = arrClients[indexPath.row]
        }
        cell.setCell(index: indexPath.row, isCheckAll: isCheckAll)
        cell.delegate = self
        cell.parent = self
        return cell
    }
}

extension ClientsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            showClientProfileVC(id: filterdata[indexPath.row].id)
        } else {
            showClientProfileVC(id: arrClients[indexPath.row].id)
        }
    }
}

extension ClientsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                filterdata = arrClients
            }
            tblClientList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblClientList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension ClientsVC: UpdateClientData {
    func editButton(id: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerDetailsVC") as! CustomerDetailsVC
        let mod = arrClients.filter{ $0.id == id }
        VC.model = mod.first ?? ClientList(dict: [:])
        VC.isForEdit = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func callDeleteClientAPI(id: [String]) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id.joined(separator: ",")]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_CLIENTID, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.callGetAllClientsAPI()
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func showClientDetailVC(id: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ClientDetailVC") as! ClientDetailVC
        VC.selectedId = id
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func showClientProfileVC(id: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewClientProfileVC") as! ViewClientProfileVC
        VC.selectedID = id
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
