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
    func addTask(catId: Int)
    func editCategory(catId: Int, catName: String)
    func deleteCategory(catId: Int)
    func callChangeCategory(destCategoryId: Int, sourceTaskId: Int)
    func taskPreview(taskId: Int)
}

class ToDoVC: UIViewController,UIScrollViewDelegate {
    
    //MARK:- Outlet
 //   @IBOutlet var tblToDo: UITableView!
    @IBOutlet weak var todoColview: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrShowAllCategory = [ShowAllTodoCategory]()
    var selectedCatName = String()
    var selectedCatID = Int()
    var selectedDeleteCatID = Int()
    var arrEmployee = [EmployeeList]()
    var isToDoCat = false
    
    var delegate: ToDoCollectionCell?
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        todoColview.isPagingEnabled = true
      //  tblToDo.reorder.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    @IBAction func btnArchiveClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ToDoArchiveVC") as! ToDoArchiveVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        VC.delegate = self
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnAddCategoryClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryVC") as! AddCategoryVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        VC.delegate = self
        self.present(VC, animated: true, completion: nil)
    }
    
//    @objc func btnAddTask(_ sender: UIButton) {
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
//        VC.modalTransitionStyle = .crossDissolve
//        VC.modalPresentationStyle = .overCurrentContext
//        VC.categoryId = arrShowAllCategory[sender.tag].id
//        VC.delegate = self
//        VC.isTodoCat = isToDoCat
//        self.present(VC, animated: true, completion: nil)
//    }
    
//    @objc func btnEditCategory(_ sender: UIButton) {
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryVC") as! AddCategoryVC
//        VC.modalTransitionStyle = .crossDissolve
//        VC.modalPresentationStyle = .overCurrentContext
//        VC.isEdit = true
//        VC.delegate = self
//        VC.catName = arrShowAllCategory[sender.tag].catname
//        VC.catId = arrShowAllCategory[sender.tag].id
//        self.present(VC, animated: true, completion: nil)
//    }
    
//    @objc func btnDeleteCategory(_ sender: UIButton) {
//        selectedDeleteCatID = arrShowAllCategory[sender.tag].id
//        showDeleteAlert(alertTitle: "Are you sure?", alertSubtitle: "Archive: 'Move all task to Archive List' Delete: 'Permanent delete can not be recover.")
//    }
    
    @objc func deleteCatPermanently(_ sender: UIButton) {
        callDeleteCategory(deleteId: selectedDeleteCatID, action: "delete")
    }
    
    @objc func archiveCat(_ sender: UIButton) {
        callDeleteCategory(deleteId: selectedDeleteCatID, action: "archive")
    }
    
    @objc func changePage(_ sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * todoColview.frame.size.width
        todoColview.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
        
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
//        pageControl.currentPage = Int(pageNumber)
//    }
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
                            
                            self.pageControl.numberOfPages = self.arrShowAllCategory.count
                            self.pageControl.currentPage = 0
                            self.pageControl.addTarget(self, action: #selector(self.changePage(_ :)), for: UIControl.Event.valueChanged)
                            
                            DispatchQueue.main.async {
                                self.todoColview.reloadData()
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
    
    func editCategory(catId: Int, catName: String) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryVC") as! AddCategoryVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        VC.isEdit = true
        VC.delegate = self
        VC.catName = catName
        VC.catId = catId
        self.present(VC, animated: true, completion: nil)
    }
    
    func deleteCategory(catId: Int) {
        selectedDeleteCatID = catId
        showDeleteAlert(alertTitle: "Are you sure?", alertSubtitle: "Archive: 'Move all task to Archive List' Delete: 'Permanent delete can not be recover.")
    }
    
    func addTask(catId: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
        VC.categoryId = catId
        VC.delegate = self
        VC.isTodoCat = isToDoCat
        self.present(VC, animated: true, completion: nil)
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
    
    func taskPreview(taskId: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "TaskPreviewVC") as! TaskPreviewVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.taskId = taskId
        self.present(VC, animated: true, completion: nil)
    }
}

extension ToDoVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrShowAllCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = todoColview.dequeueReusableCell(withReuseIdentifier: "ToDoCollectionCell", for: indexPath) as! ToDoCollectionCell
        cell.delegate = self
        cell.parent = self
        cell.dict = arrShowAllCategory[indexPath.item]
        cell.arrShowAllCategory = arrShowAllCategory
        cell.tblToDo.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: todoColview.frame.size.width, height: todoColview.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
