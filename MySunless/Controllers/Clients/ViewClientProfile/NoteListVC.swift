//
//  NoteListVC.swift
//  MySunless
//
//  Created by Daydream Soft on 22/03/22.
//

import UIKit
import Alamofire
import SCLAlertView

protocol NoteListDelegate {
    func editNote(noteId: Int, dict: NoteDetail)
    func deleteNote(noteId: Int)
    func showNote(noteId: Int)
}

class NoteListVC: UIViewController {

    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblNoteList: UITableView!
    
    var token = String()
    var arrNoteDetail = [NoteDetail]()
    var arrFilterNoteDetail = [NoteDetail]()
    var searching = false
    var selectedClientId = Int()
    var model = NoteDetail(dict: [:])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        tblNoteList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblNoteList.refreshControl = UIRefreshControl()
        tblNoteList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowClientAllNotesAPI(id: selectedClientId)
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        searchBar.delegate = self
    }
    
    func callShowClientAllNotesAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id]
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
                                self.tblNoteList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrNoteDetail.removeAll()
                            self.arrFilterNoteDetail.removeAll()
                            self.tblNoteList.reloadData()
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
                            self.callShowClientAllNotesAPI(id: self.selectedClientId)
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
        arrFilterNoteDetail = arrNoteDetail.filter({ (note:NoteDetail) -> Bool in
            let name = note.noteCreaterName
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let tittle = note.noteTitle
            let Title = tittle.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let detail = note.noteDetail
            let Detail = detail.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let createdDate = AppData.sharedInstance.convertToUTC(dateToConvert: model.datelastupdated)
            let CreatedDate = createdDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let time = note.timediff
            let Time = time.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || Title != nil || Detail != nil || CreatedDate != nil || Time != nil
        })
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowClientAllNotesAPI(id: self.selectedClientId)
            self.tblNoteList.refreshControl?.endRefreshing()
            self.tblNoteList.reloadData()
        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddNoteClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddNoteVC") as! AddNoteVC
        VC.selectedCustomerID = selectedClientId
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnRefreshClick(_ sender: UIButton) {
        callShowClientAllNotesAPI(id: selectedClientId)
        tblNoteList.reloadData()
    }
    
}

//MARK:- TableView Delegate and Datasource Methods
extension NoteListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterNoteDetail.count
        } else {
            return arrNoteDetail.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblNoteList.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        if searching {
            cell.model = arrFilterNoteDetail[indexPath.row]
        } else {
            cell.model = arrNoteDetail[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension NoteListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension NoteListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterNoteDetail = arrNoteDetail
            }
            tblNoteList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblNoteList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension NoteListVC: NoteListDelegate {
    func editNote(noteId: Int, dict: NoteDetail) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddNoteVC") as! AddNoteVC
        VC.selectedCustomerID = selectedClientId
        VC.selectedNoteID = noteId
        VC.dictNote = dict
        VC.isForEdit = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func deleteNote(noteId: Int) {
        callDeleteNoteAPI(selectedNoteID: noteId)
        tblNoteList.reloadData()
    }
    
    func showNote(noteId: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewNoteVC") as! ViewNoteVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.selectedNoteId = noteId
        self.present(VC, animated: true, completion: nil)
    }
}
