//
//  NotesListVC.swift
//  MySunless
//
//  Created by iMac on 19/02/22.
//

import UIKit
import Alamofire

class NotesListVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblNotesList: UITableView!
    
    //MARK:- Variable Declarations
    var token = String()
    var selectedCustomerID = Int()
    var arrNoteDetail = [NoteDetail]()
    var arrFilterNoteDetail = [NoteDetail]()
    var searching = false
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        searchBar.delegate = self
        tblNotesList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblNotesList.refreshControl = UIRefreshControl()
        tblNotesList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowClientAllNotesAPI()
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
    }
    
    func callShowClientAllNotesAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": selectedCustomerID]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_CLIENT_ALLNOTES, param: params, header: headers) { (respnse, error) in
            print(respnse ?? "")
            AppData.sharedInstance.dismissLoader()
          
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrNoteDetail.removeAll()
                            self.arrFilterNoteDetail.removeAll()
                            for dict in response {
                                self.arrNoteDetail.append(NoteDetail(dict: dict))
                            }
                            self.arrFilterNoteDetail = self.arrNoteDetail
                            DispatchQueue.main.async {
                                self.tblNotesList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrNoteDetail.removeAll()
                            self.arrFilterNoteDetail.removeAll()
                            self.tblNotesList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callDeleteNoteAPI(selectedNoteID: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": selectedNoteID]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_NOTE, param: params, header: headers) { (response, error) in
            print(response ?? "")
            AppData.sharedInstance.dismissLoader()
             
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.callShowClientAllNotesAPI()
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
        arrFilterNoteDetail = arrNoteDetail.filter({ (noteList: NoteDetail) -> Bool in
            let title = noteList.noteTitle
            let Title = title.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let desc = noteList.noteDetail
            let Desc = desc.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let date = noteList.datelastupdated
            let Date = date.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            return Title != nil || Desc != nil || Date != nil
        })
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowClientAllNotesAPI()
            self.tblNotesList.refreshControl?.endRefreshing()
            self.tblNotesList.reloadData()
        }
    }
    
    //MARK:- Actions
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddNoteClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddNoteVC") as! AddNoteVC
        VC.selectedCustomerID = selectedCustomerID
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddNoteVC") as! AddNoteVC
        VC.dictNote = searching ? arrFilterNoteDetail[sender.tag] : arrNoteDetail[sender.tag]
        VC.isForEdit = true
        VC.selectedNoteID = searching ? arrFilterNoteDetail[sender.tag].id : arrNoteDetail[sender.tag].id
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        if searching {
            callDeleteNoteAPI(selectedNoteID: arrFilterNoteDetail[sender.tag].id)
            arrFilterNoteDetail.remove(at: sender.tag)
        } else {
            callDeleteNoteAPI(selectedNoteID: arrNoteDetail[sender.tag].id)
            arrNoteDetail.remove(at: sender.tag)
        }
        tblNotesList.reloadData()
    }
    
}

//MARK:- UITableview Datasource Methods
extension NotesListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterNoteDetail.count
        } else {
            return arrNoteDetail.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblNotesList.dequeueReusableCell(withIdentifier: "NotesListCell", for: indexPath) as! NotesListCell
        
        if searching {
            let model = arrFilterNoteDetail[indexPath.row]
            cell.lblTitle.text = model.noteTitle
            cell.txtVwDescription.setHTMLFromString(htmlText: model.noteDetail)
            
            var date = model.datelastupdated
            date.removeLast(9)
            cell.lblDate.text = date
        } else {
            let model = arrNoteDetail[indexPath.row]
            cell.lblTitle.text = model.noteTitle
            cell.txtVwDescription.setHTMLFromString(htmlText: model.noteDetail)
            
            var date = model.datelastupdated
            date.removeLast(9)
            cell.lblDate.text = date
        }
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        return cell
    }
    
}

//MARK:- UITableview Delegate Methods
extension NotesListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
}

//MARK:- SearchBar Delegate Methods
extension NotesListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterNoteDetail = arrNoteDetail
            }
            tblNotesList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblNotesList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}
