//
//  ToDoVC.swift
//  MySunless
//
//  Created by Daydream Soft on 21/06/22.
//

import UIKit
import Alamofire
import SCLAlertView
import SwiftReorder

//MARK:- Protocol
protocol ToDoProtocol {
    func callShowAllTodoCategory()
    func editTask(model: NSDictionary, taskId: Int, catId: Int)
    func callDeleteTask(deleteId: Int, action: String)
    func moveTask(taskName: String, taskId: Int)
}

class ToDoVC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet var tblToDo: UITableView!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrShowAllCategory = [ShowAllTodoCategory]()
    var arrShowAllTask = [ShowAllTask]()
    var selectedCatName = String()
    var selectedCatID = Int()
    var selectedDeleteCatID = Int()
    var arrEmployee = [EmployeeList]()
    var isToDoCat = false
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblToDo.tableFooterView = UIView()
        tblToDo.register(UINib(nibName: "ToDoHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ToDoHeaderView")
        tblToDo.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
        let dummyViewHeight = CGFloat(40)
        tblToDo.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tblToDo.bounds.size.width, height: dummyViewHeight))
        tblToDo.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        tblToDo.allowsSelection = false
        tblToDo.reorder.delegate = self
        
        callShowAllTodoCategory()
    }
    
    func showDeleteAlert(alertTitle: String, alertSubtitle: String) {
        let alert = SCLAlertView()
        alert.addButton("Cancel", backgroundColor: UIColor.init("#757575"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.addButton("Delete", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteCatPermanently(_:)))
        alert.addButton("Archive", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(archiveCat(_:)))
        
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    func callDeleteCategory(deleteId: Int, action: String) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["deleteId": deleteId,
                  "action": action
        ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_CATEGORY, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: message) {
                                self.callShowAllTodoCategory()
                            }
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: message) {
                                self.callShowAllTodoCategory()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callChangeCategory(destCategoryId: Int, sourceTaskId: Int) {
     //   AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["categoryId": destCategoryId,
                  "taskId": sourceTaskId
        ]
//        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
//            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
//                AppData.sharedInstance.dismissLoader()
//            }
//            return
//        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CHANGE_CATEGORY, param: params, header: headers) { respnse, error in
    //        AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "message") as? String {
//                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: message) {
//
//                            }
                            print(message)
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
//                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: message) {
//
//                            }
                            print(message)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnArchiveClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ToDoArchiveVC") as! ToDoArchiveVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnAddCategoryClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryVC") as! AddCategoryVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        VC.delegate = self
        self.present(VC, animated: true, completion: nil)
    }
    
    @objc func btnAddTask(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        VC.categoryId = arrShowAllCategory[sender.tag].id
        VC.delegate = self
        VC.isTodoCat = isToDoCat
        self.present(VC, animated: true, completion: nil)
    }
    
    @objc func btnEditCategory(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryVC") as! AddCategoryVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        VC.isEdit = true
        VC.delegate = self
        VC.catName = arrShowAllCategory[sender.tag].catname
        VC.catId = arrShowAllCategory[sender.tag].id
        self.present(VC, animated: true, completion: nil)
    }
    
    @objc func btnDeleteCategory(_ sender: UIButton) {
        selectedDeleteCatID = arrShowAllCategory[sender.tag].id
        showDeleteAlert(alertTitle: "Are you sure?", alertSubtitle: "Archive: 'Move all task to Archive List' Delete: 'Permanent delete can not be recover.")
    }
    
    @objc func deleteCatPermanently(_ sender: UIButton) {
        callDeleteCategory(deleteId: selectedDeleteCatID, action: "delete")
    }
    
    @objc func archiveCat(_ sender: UIButton) {
        callDeleteCategory(deleteId: selectedDeleteCatID, action: "archive")
    }
}

extension ToDoVC: ToDoProtocol {
    func callShowAllTodoCategory() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOWALL_TODO_CATEGORY, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrShowAllCategory.removeAll()
                            for dict in response {
                                self.arrShowAllCategory.append(ShowAllTodoCategory(dict: dict))
                            }
                            DispatchQueue.main.async {
                                self.tblToDo.reloadData()
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
    
    func editTask(model: NSDictionary, taskId: Int, catId: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        VC.delegate = self
        VC.selectedTaskId = taskId
        VC.categoryId = catId
        VC.isEdit = true
        VC.model = model
        self.present(VC, animated: true, completion: nil)
    }
    
    func moveTask(taskName: String, taskId: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "MoveTaskVC") as! MoveTaskVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        VC.delegate = self
        VC.taskName = taskName
        VC.arrShowAllToDoCategory = arrShowAllCategory
        VC.taskId = taskId
        self.present(VC, animated: true, completion: nil)
    }
    
    func callDeleteTask(deleteId: Int, action: String) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["deleteId": deleteId,
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
                                self.callShowAllTodoCategory()
                            }
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.addCustomAlert(alertMainTitle: "", subTitle: message) {
                                self.callShowAllTodoCategory()
                            }
                        }
                    }
                }
            }
        }
    }
}
    
extension ToDoVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrShowAllCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrShowAllCategory[section].todoTasks.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tblToDo.dequeueReusableHeaderFooterView(withIdentifier: "ToDoHeaderView") as! ToDoHeaderView
        if arrShowAllCategory[section].catname == "To-do" {
            headerView.lblTitle.text = "TODO (SELF)"
            headerView.btnEdit.isHidden = true
            headerView.btnCancel.isHidden = true
            headerView.btnAddTrailingConstraint.constant = 10
            isToDoCat = true
        } else {
            headerView.lblTitle.text = arrShowAllCategory[section].catname
            headerView.btnEdit.isHidden = false
            headerView.btnCancel.isHidden = false
            headerView.btnAddTrailingConstraint.constant = 78
            isToDoCat = false
        }
        headerView.btnAdd.tag = section
        headerView.btnEdit.tag = section
        headerView.btnCancel.tag = section
        
        selectedCatName = headerView.lblTitle.text ?? ""
       // selectedCatID = arrShowAllCategory[section].id
        headerView.btnEdit.addTarget(self, action: #selector(btnEditCategory(_:)), for: .touchUpInside)
        headerView.btnCancel.addTarget(self, action: #selector(btnDeleteCategory(_:)), for: .touchUpInside)
        headerView.btnAdd.addTarget(self, action: #selector(btnAddTask(_:)), for: .touchUpInside)
        
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let spacer = tblToDo.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        let cell = tblToDo.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        cell.delegate = self
        let model:NSDictionary = arrShowAllCategory[indexPath.section].todoTasks[indexPath.row] as NSDictionary
        cell.model = model
        cell.dictShowCategory = arrShowAllCategory[indexPath.section]
        cell.setCell(model: model, index: indexPath.row)
        
        return cell
    }
    
}

extension ToDoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ToDoVC: TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = arrShowAllCategory[sourceIndexPath.section].todoTasks[sourceIndexPath.row]
        let sourceItem:NSDictionary = arrShowAllCategory[sourceIndexPath.section].todoTasks[sourceIndexPath.row] as NSDictionary
        let sourceTaskId = sourceItem.value(forKey: "id") as? Int ?? 0
        let destCatId = arrShowAllCategory[destinationIndexPath.section].id
        
        arrShowAllCategory[sourceIndexPath.section].todoTasks.remove(at: sourceIndexPath.row)
        arrShowAllCategory[destinationIndexPath.section].todoTasks.insert(item, at: destinationIndexPath.row)
        
        callChangeCategory(destCategoryId: destCatId, sourceTaskId: sourceTaskId)
    }
    
}
