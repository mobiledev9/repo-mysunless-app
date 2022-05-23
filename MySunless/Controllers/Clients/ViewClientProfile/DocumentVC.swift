//
//  DocumentVC.swift
//  MySunless
//
//  Created by Daydream Soft on 24/03/22.
//

import UIKit
import Alamofire
import iOSDropDown

protocol AddDocumentProtocol {
    func callShowDocumentAPI(clientId: Int)
    func callDeleteDocumentAPI(id: Int)
}

class DocumentVC: UIViewController {

    @IBOutlet var btnUploadDoc: UIButton!
    @IBOutlet var vw_fromDate: UIView!
    @IBOutlet var vw_toDate: UIView!
    @IBOutlet var tblDocumentList: UITableView!
    @IBOutlet var vw_filter: UIView!
    @IBOutlet var heightFilterVw: NSLayoutConstraint!
    @IBOutlet var vw_filterByDate: UIView!
    @IBOutlet var heightFilterByDateVw: NSLayoutConstraint!
    @IBOutlet var txtFromDate: UITextField!
    @IBOutlet var txtToDate: UITextField!
    @IBOutlet var heightFilterByTitleVw: NSLayoutConstraint!
    @IBOutlet var vw_filterByTitle: UIView!
    @IBOutlet var txtChooseUser: DropDown!
    @IBOutlet var topFilterByTitle: NSLayoutConstraint!
    @IBOutlet var btnRefresh: UIButton!
    @IBOutlet var btnFilterByDate: UIButton!
    @IBOutlet var btnFilterByTitle: UIButton!
    
    var token = String()
    var searching = false
    var isFilterByDateOpen = false
    var isFilterbyTitleOpen = false
    var arrShowDocument = [ShowDocument]()
    var selectedClientId = Int()
    var datePicker = UIDatePicker()
    var isFilterDate = false
    var isFilterTitle = false
    var arrTitle = [String]()
    var arrIds = [Int]()
    var finalDate = String()
    var selectedTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        tblDocumentList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblDocumentList.refreshControl = UIRefreshControl()
        tblDocumentList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowDocumentAPI(clientId: selectedClientId)
    }
    
    func setInitially() {
        btnUploadDoc.layer.borderWidth = 0.5
        btnUploadDoc.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_filter.layer.borderWidth = 0.5
        vw_filter.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_fromDate.layer.borderWidth = 0.5
        vw_fromDate.layer.borderColor = UIColor.lightGray.cgColor
        vw_toDate.layer.borderWidth = 0.5
        vw_toDate.layer.borderColor = UIColor.lightGray.cgColor
        vw_filterByTitle.layer.borderWidth = 0.5
        vw_filterByTitle.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnRefresh.layer.borderWidth = 0.5
        btnRefresh.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnFilterByDate.layer.borderWidth = 0.5
        btnFilterByDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnFilterByTitle.layer.borderWidth = 0.5
        btnFilterByTitle.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_filter.isHidden = true
        heightFilterVw.constant = 0
        txtFromDate.delegate = self
        txtToDate.delegate = self
     }
 
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUploadDocClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddDocumentVC") as! AddDocumentVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.selectedClientId = selectedClientId
        VC.delegate = self
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
        if sender.isSelected {
            vw_filter.isHidden = true
            heightFilterVw.constant = 0
            sender.isSelected.toggle()
        } else {
            vw_filter.isHidden = false
            heightFilterVw.constant = 130
            vw_filterByDate.isHidden = true
            heightFilterByDateVw.constant = 0
            vw_filterByTitle.isHidden = true
            heightFilterByTitleVw.constant = 0
            topFilterByTitle.constant = 5
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func btnRefreshClick(_ sender: UIButton) {
        isFilterDate = false
        isFilterTitle = false
        txtFromDate.text = ""
        txtToDate.text = ""
        txtChooseUser.text = ""
        finalDate = ""
        selectedTitle = ""
        callShowDocumentAPI(clientId: selectedClientId)
        tblDocumentList.reloadData()
    }
    
    @IBAction func btnFilterByDateClick(_ sender: UIButton) {
        if sender.isSelected {
            vw_filterByDate.isHidden = true
            heightFilterByDateVw.constant = 0
            topFilterByTitle.constant = 5
            if isFilterbyTitleOpen {
                heightFilterVw.constant = 175
            } else {
                heightFilterVw.constant = 130
            }
            isFilterByDateOpen = false
            isFilterDate = false
            sender.isSelected.toggle()
        } else {
            vw_filterByDate.isHidden = false
            heightFilterByDateVw.constant = 95
            topFilterByTitle.constant = 95
            if isFilterbyTitleOpen {
                heightFilterVw.constant = 265
            } else {
                heightFilterVw.constant = 220
            }
            isFilterByDateOpen = true
            isFilterDate = true
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func btnFilterByTitleClick(_ sender: UIButton) {
        if sender.isSelected {
            vw_filterByTitle.isHidden = true
            heightFilterByTitleVw.constant = 0
            if isFilterByDateOpen {
                heightFilterVw.constant = 220
            } else {
                heightFilterVw.constant = 130
            }
            isFilterbyTitleOpen = false
            isFilterTitle = false
            sender.isSelected.toggle()
        } else {
            vw_filterByTitle.isHidden = false
            heightFilterByTitleVw.constant = 40
            if isFilterByDateOpen {
                heightFilterVw.constant = 265
            } else {
                heightFilterVw.constant = 175
            }
            isFilterbyTitleOpen = true
            isFilterTitle = true
            sender.isSelected.toggle()
        }
    }
    
    @objc func handleFromDate() {
        if let datePicker = self.txtFromDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            txtFromDate.text = dateFormatter.string(from: datePicker.date)
            if (txtFromDate.text != "" && txtToDate.text != "") {
                finalDate = (txtFromDate.text ?? "") + "," + (txtToDate.text ?? "")
                isFilterDate = true
                callShowDocumentAPI(clientId: selectedClientId)
            }
        }
        self.txtFromDate.resignFirstResponder()
    }
    
    @objc func handleToDate() {
        if let datePicker = self.txtToDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            txtToDate.text = dateFormatter.string(from: datePicker.date)
            if (txtFromDate.text != "" && txtToDate.text != "") {
                finalDate = (txtFromDate.text ?? "") + "," + (txtToDate.text ?? "")
                isFilterDate = true
                callShowDocumentAPI(clientId: selectedClientId)
            }
        }
        self.txtToDate.resignFirstResponder()
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowDocumentAPI(clientId: self.selectedClientId)
            self.tblDocumentList.refreshControl?.endRefreshing()
            self.tblDocumentList.reloadData()
        }
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension DocumentVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrShowDocument.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDocumentList.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
        cell.model = arrShowDocument[indexPath.row]
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension DocumentVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DocumentVC: AddDocumentProtocol {
    func callShowDocumentAPI(clientId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        if isFilterDate || isFilterTitle {
            params = ["clientid": clientId,
                      "date": finalDate,
                      "title": selectedTitle
            ]
        } else {
            params = ["clientid": clientId]
        }
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_DOCUMENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrTitle.removeAll()
                            self.arrIds.removeAll()
                            self.arrShowDocument.removeAll()
                            for dict in response {
                                self.arrShowDocument.append(ShowDocument(dict: dict))
                            }
                            for dic in self.arrShowDocument {
                                self.arrTitle.append(dic.fileName)
                                self.arrIds.append(dic.UserID)
                            }
                            self.txtChooseUser.optionArray = self.arrTitle
                            self.txtChooseUser.optionIds = self.arrIds
                            self.txtChooseUser.didSelect{(selectedText, index, id) in
                                self.txtChooseUser.selectedIndex = index
                                self.selectedTitle = selectedText
                                self.isFilterTitle = true
                                self.callShowDocumentAPI(clientId: id)
                            }
                            DispatchQueue.main.async {
                                self.tblDocumentList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrShowDocument.removeAll()
                            self.tblDocumentList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callDeleteDocumentAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["delid": id]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_DOCUMENT, param: params, header: headers) { (response, error) in
            print(response ?? "")
            AppData.sharedInstance.dismissLoader()
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if (success == "1") {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.callShowDocumentAPI(clientId: self.selectedClientId)
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
}

extension DocumentVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFromDate {
            self.txtFromDate.setInputViewDatePicker(target: self, selector: #selector(handleFromDate))
        } else if textField == txtToDate {
            self.txtToDate.setInputViewDatePicker(target: self, selector: #selector(handleToDate))
        }
        
    }
}
