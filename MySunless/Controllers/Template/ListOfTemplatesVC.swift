//
//  ListOfTemplatesVC.swift
//  MySunless
//
//  Created by iMac on 03/01/22.
//

import UIKit
import Alamofire

class ListOfTemplatesVC: UIViewController {

    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblTemplateList: UITableView!
    
    var token = String()
    var arrTemplate = [ShowTemplate]()
    var filterdata = [ShowTemplate]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        hideKeyboardWhenTappedAround()
        tblTemplateList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblTemplateList.refreshControl = UIRefreshControl()
        tblTemplateList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowTemplateAPI()
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        searchBar.delegate = self
    }
    
    func callShowTemplateAPI() {
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
                                self.tblTemplateList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrTemplate.removeAll()
                            self.filterdata.removeAll()
                            self.tblTemplateList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callDeleteTemplateAPI(templateId:Int) {
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
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.callShowTemplateAPI()
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
    
    func callChangeStatusTemplateAPI(templateId:Int,isActive:Bool) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["tmp_id":templateId,
                  "isactive":isActive ? 1 : 0 ]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CHANGE_TEMPLATE_STATUS, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.callShowTemplateAPI()
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
        filterdata = arrTemplate.filter({ (template: ShowTemplate) -> Bool in
            let name = template.Name
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let subject = template.Subject
            let Subject = subject.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let message = template.TextMassage
            let Message = message.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let dateCreated = template.datecreated
            let DateCreated = dateCreated.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || Subject != nil || Message != nil || DateCreated != nil
        })
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowTemplateAPI()
            self.tblTemplateList.refreshControl?.endRefreshing()
            self.tblTemplateList.reloadData()
        }
    }
    
    @IBAction func btnCreateTemplateClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateTemplateVC") as! CreateTemplateVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnViewTemplateClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "EmailTemplateDetailVC") as! EmailTemplateDetailVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        if searching {
            VC.emailTemplate = filterdata[sender.tag]
        } else {
            VC.emailTemplate = arrTemplate[sender.tag]
        }
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnEditTemplateClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateTemplateVC") as! CreateTemplateVC
        VC.isForEdit = true
        if searching {
            VC.emailTemplate = filterdata[sender.tag]
        } else {
            VC.emailTemplate = arrTemplate[sender.tag]
        }
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    @IBAction func btnDeleteTemplateClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Permanently Delete?", message: "Once deleted, You will not be able to recover this!", preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (dd) -> Void in
            
        }
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (dd) -> Void in
            self.callDeleteTemplateAPI(templateId: self.arrTemplate[sender.tag].id)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        self.callChangeStatusTemplateAPI(templateId: arrTemplate[sender.tag].id, isActive: sender.isOn)
    }
    
}

//MARK:- TableView Delegate and Datasource Methods
extension ListOfTemplatesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filterdata.count
        } else {
            return arrTemplate.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblTemplateList.dequeueReusableCell(withIdentifier: "TemplateListCell", for: indexPath) as! TemplateListCell
//        cell.btnProfile.tag = indexPath.row
//        cell.btnDelete.tag = indexPath.row
//
        cell.btnView.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnEdit.tag = indexPath.row
        cell.switchValue.tag = indexPath.row
        cell.lblMessage.textColor = UIColor.init("#6D778E")
        if searching {
            let model = filterdata[indexPath.row]
            cell.lblName.text = model.Name
            cell.lblSubject.text = model.Subject
            cell.lblMessage.setHTMLFromString(htmlText: model.TextMassage)
            cell.lblCreatedDate.text = model.datecreated
            
            if (model.isactive == 1) {
                cell.switchValue.setOn(true, animated: true)
            } else {
                cell.switchValue.setOn(false, animated: true)
            }
            
        } else {
            let model = arrTemplate[indexPath.row]
            cell.lblName.text = model.Name
            cell.lblSubject.text = model.Subject
            cell.lblMessage.setHTMLFromString(htmlText: model.TextMassage)
            cell.lblCreatedDate.text = model.datecreated
            
            if (model.isactive == 1) {
                cell.switchValue.setOn(true, animated: true)
            } else {
                cell.switchValue.setOn(false, animated: true)
            }
            
        }
        
        return cell
    }
}

extension ListOfTemplatesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      //  return 210
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension ListOfTemplatesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                filterdata = arrTemplate
            }
            tblTemplateList.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblTemplateList.reloadData()
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}


