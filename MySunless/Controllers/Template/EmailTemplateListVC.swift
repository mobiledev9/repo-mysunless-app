//
//  EmailTemplateListVC.swift
//  MySunless
//
//  Created by Daydream Soft on 15/04/22.
//

import UIKit
import Alamofire

protocol EmailTemplateProtocol {
    func callDeleteTemplateAPI(templateId:Int)
    func editTemplate(index: Int)
    func viewTemplate(index: Int)
}

class EmailTemplateListVC: UIViewController {
    
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblEmailTemplateList: UITableView!
    
    var token = String()
    var arrTemplate = [ShowTemplate]()
    var filterdata = [ShowTemplate]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        hideKeyboardWhenTappedAround()
        tblEmailTemplateList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblEmailTemplateList.refreshControl = UIRefreshControl()
        tblEmailTemplateList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
     }
    
    override func viewWillAppear(_ animated: Bool) {
       callShowEmailTemplateAPI()
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        searchBar.delegate = self
    }
    
    func callShowEmailTemplateAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + VIEW_TEMPLATE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "message") as? [[String:Any]] {
                            self.arrTemplate.removeAll()
                            for dict in response {
                                self.arrTemplate.append(ShowTemplate(dict: dict))
                            }
                            self.filterdata = self.arrTemplate
                            
                            DispatchQueue.main.async {
                                self.tblEmailTemplateList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrTemplate.removeAll()
                            self.filterdata.removeAll()
                            self.tblEmailTemplateList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filterdata = arrTemplate.filter({ (template: ShowTemplate) -> Bool in
            let name = template.Name
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let subject = template.Subject
            let Subject = subject.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let message = template.TextMassage
            let Message = message.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || Subject != nil || Message != nil 
        })
    }
    
    @IBAction func btnCreateNewEmailTemplateClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateTemplateVC") as! CreateTemplateVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowEmailTemplateAPI()
            self.tblEmailTemplateList.refreshControl?.endRefreshing()
            self.tblEmailTemplateList.reloadData()
        }
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension EmailTemplateListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filterdata.count
        } else {
            return arrTemplate.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblEmailTemplateList.dequeueReusableCell(withIdentifier: "EmailTemplateCell", for: indexPath) as! EmailTemplateCell
        if searching {
            cell.model = filterdata[indexPath.row]
        } else {
            cell.model = arrTemplate[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension EmailTemplateListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension EmailTemplateListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                filterdata = arrTemplate
            }
            tblEmailTemplateList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblEmailTemplateList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension EmailTemplateListVC: EmailTemplateProtocol {
    func callDeleteTemplateAPI(templateId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["tmp_id":templateId]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_TEMPLATE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: message)
                            self.callShowEmailTemplateAPI()
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: message)
                        }
                    }
                }
            }
        }
    }
    
    func editTemplate(index: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateTemplateVC") as! CreateTemplateVC
        VC.isForEdit = true
        VC.emailTemplate = searching ? filterdata[index] : arrTemplate[index]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func viewTemplate(index: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "EmailTemplateDetailVC") as! EmailTemplateDetailVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.emailTemplate = searching ? filterdata[index] : arrTemplate[index]
        self.present(VC, animated: true, completion: nil)
    }
    
}
