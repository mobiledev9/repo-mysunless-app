//
//  ToDoArchiveVC.swift
//  MySunless
//
//  Created by Daydream Soft on 02/07/22.
//

import UIKit
import Alamofire
import SCLAlertView

protocol ToDoArchiveProtocol {
    func callDeleteTask(deleteIds: [String], action: String)
}

class ToDoArchiveVC: UIViewController {

    @IBOutlet weak var vw_main: UIView!
    @IBOutlet weak var vw_top: UIView!
    @IBOutlet weak var vw_bottom: UIView!
    @IBOutlet weak var tblToDoArchive: UITableView!
    @IBOutlet weak var btnDelete: UIButton!
    
    var token = String()
    var arrToDoArchive = [ToDoArchiveList]()
    var delegate: ToDoProtocol?
    var arrSelectedIds = [String]()
    var arrArchiveIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblToDoArchive.tableFooterView = UIView()
        tblToDoArchive.register(UINib(nibName: "ToDoArchiveCell", bundle: nil), forCellReuseIdentifier: "ToDoArchiveCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowArchiveTaskAPI()
    }
    
    func setInitially() {
        vw_main.layer.borderWidth = 1.0
        vw_main.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.masksToBounds = true
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.masksToBounds = true
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        btnDelete.layer.cornerRadius = 5
    }
    
    func showDeleteAlert(alertTitle: String, alertSubtitle: String) {
        let alert = SCLAlertView()
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.addButton("All", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteAll(_:)))
        alert.addButton("Selected", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteSelected(_:)))
        
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    func callShowArchiveTaskAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_ARCHIVE_TASK , param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrToDoArchive.removeAll()
                            for dict in response {
                                self.arrToDoArchive.append(ToDoArchiveList(dict: dict))
                            }
                            self.arrArchiveIds = self.arrToDoArchive.map{ "\($0.id)" }
                            DispatchQueue.main.async {
                                self.tblToDoArchive.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    }
                }
            }
        }
    }
    
    func callDeleteTask(deleteIds: [String], action: String) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["deleteId": deleteIds.joined(separator: ","),
                  "action": action
        ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_TASK, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: message) {
                                self.dismiss(animated: true) {
                                    self.delegate?.callShowAllTodoCategory()
                                }
                            }
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: message) {
                                self.dismiss(animated: true) {
                                    self.delegate?.callShowAllTodoCategory()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        showDeleteAlert(alertTitle: "Are you sure?", alertSubtitle: "All: Delete all tasks. \n Selected: Delete selected task.")
    }
    
    @objc func deleteAll(_ sender: UIButton) {
        callDeleteTask(deleteIds: arrArchiveIds, action: "delete")
    }
    
    @objc func deleteSelected(_ sender: UIButton) {
        callDeleteTask(deleteIds: arrSelectedIds, action: "delete")
    }
}

extension ToDoArchiveVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrToDoArchive.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblToDoArchive.dequeueReusableCell(withIdentifier: "ToDoArchiveCell", for: indexPath) as! ToDoArchiveCell
        cell.model = arrToDoArchive[indexPath.row]
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        cell.parent = self
        return cell
    }
}

extension ToDoArchiveVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ToDoArchiveVC: ToDoArchiveProtocol {
    
}
