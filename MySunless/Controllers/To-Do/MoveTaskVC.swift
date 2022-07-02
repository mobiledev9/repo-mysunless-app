//
//  MoveTaskVC.swift
//  MySunless
//
//  Created by Daydream Soft on 01/07/22.
//

import UIKit
import iOSDropDown
import Alamofire

class MoveTaskVC: UIViewController {

    @IBOutlet weak var vw_main: UIView!
    @IBOutlet weak var vw_top: UIView!
    @IBOutlet weak var vw_bottom: UIView!
    @IBOutlet weak var lblTaskName: UILabel!
    @IBOutlet weak var vw_selectCategory: UIView!
    @IBOutlet weak var txtSelectCategory: DropDown!
    
    var delegate: ToDoProtocol?
    var taskId = Int()
    var categoryId = Int()
    var taskName = String()
    var token = String()
    var arrShowAllToDoCategory = [ShowAllTodoCategory]()
    var arrCategoryName = [String]()
    var arrCategoryId = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblTaskName.text = taskName
        arrCategoryName = arrShowAllToDoCategory.map{ $0.catname }
        arrCategoryName[0] = "To-Do (SELF)"
        arrCategoryId = arrShowAllToDoCategory.map{ $0.id }
        txtSelectCategory.optionArray = arrCategoryName
        txtSelectCategory.optionIds = arrCategoryId
        txtSelectCategory.didSelect { selectedText, index, id in
            self.categoryId = id
        }
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
        vw_selectCategory.layer.borderWidth = 0.5
        vw_selectCategory.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_selectCategory.layer.cornerRadius = 12
        txtSelectCategory.delegate = self
    }
    
    func setValidation() -> Bool {
        if txtSelectCategory.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Select Category", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callChangeCategory(destCategoryId: Int, sourceTaskId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["categoryId": destCategoryId,
                  "taskId": sourceTaskId
        ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CHANGE_CATEGORY, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
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
    
    @IBAction func btnMoveClick(_ sender: UIButton) {
        if setValidation() {
            callChangeCategory(destCategoryId: categoryId, sourceTaskId: taskId)
        }
    }
}

extension MoveTaskVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtSelectCategory.resignFirstResponder()
    }
}
