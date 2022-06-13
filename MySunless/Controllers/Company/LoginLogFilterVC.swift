//
//  LoginLogFilterVC.swift
//  MySunless
//
//  Created by iMac on 02/03/22.
//

import UIKit
import iOSDropDown
import Alamofire

class LoginLogFilterVC: UIViewController {

    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_date: UIView!
    @IBOutlet var txtDate: DropDown!
    @IBOutlet var vw_chooseUser: UIView!
    @IBOutlet var txtChooseUser: DropDown!
    @IBOutlet var vw_popView: UIView!
    @IBOutlet var vw_popTopView: UIView!
    @IBOutlet var vw_popBottomView: UIView!
    @IBOutlet var vw_startDate: UIView!
    @IBOutlet var txtStartDate: UITextField!
    @IBOutlet var vw_endDate: UIView!
    @IBOutlet var txtEndDate: UITextField!
    @IBOutlet var vw_datePicker: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var vw_mainHeightConstant: NSLayoutConstraint!       //280  400
    @IBOutlet var vw_chooseCustomer: UIView!
    @IBOutlet var txtChooseCustomer: DropDown!
    @IBOutlet var vw_paymentStatus: UIView!
    @IBOutlet var txtPaymentStatus: DropDown!
    
    var arrChooseUser = [ChooseUser]()
    var token = String()
    var delegate: UpdateLoginLog?
    var userID = Int()
    var arrIds = [Int]()
    var startdate = String()
    var enddate = String()
    var finaldate = String()
    var arr7Days = [String]()
    var isFromStartDate = false
    var isFromEndDate = false
    var filterBadgeCount = Int()
    
    var isFromLoginLog = false
    var isFromCompletedOrder = false
    var arrChooseCustomer = [ChooseCustomerList]()
    var arrPaymentStatus = ["Cash", "Cheque", "Card"]
    var arrCustomerIds = [Int]()
    var selectedCustomerId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        dateDropdown()
        callFilterListUserAPI()
        if isFromCompletedOrder {
            callFilterListCustomerAPI()
            txtPaymentStatus.optionArray = arrPaymentStatus
            txtPaymentStatus.didSelect{(selectedText , index ,id) in
                //  print( "Selected String: \(selectedText) \n index: \(index),id: \(id)")
                self.txtPaymentStatus.selectedIndex = index
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "loginlogdate")
        UserDefaults.standard.removeObject(forKey: "loginloguser")
    }
    
    func setInitially() {
        vw_mainView.layer.borderWidth = 1.0
        vw_mainView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.masksToBounds = true
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.masksToBounds = true
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        vw_date.layer.borderWidth = 0.5
        vw_date.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_chooseUser.layer.borderWidth = 0.5
        vw_chooseUser.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_chooseCustomer.layer.borderWidth = 0.5
        vw_chooseCustomer.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_paymentStatus.layer.borderWidth = 0.5
        vw_paymentStatus.layer.borderColor = UIColor.init("#15B0DA").cgColor
        
        vw_popView.layer.borderWidth = 1.0
        vw_popView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_popTopView.layer.cornerRadius = 12
        vw_popTopView.layer.masksToBounds = true
        vw_popTopView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_popBottomView.layer.cornerRadius = 12
        vw_popBottomView.layer.masksToBounds = true
        vw_popBottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        vw_startDate.layer.borderWidth = 0.5
        vw_startDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_endDate.layer.borderWidth = 0.5
        vw_endDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_popView.isHidden = true
        txtStartDate.delegate = self
        txtEndDate.delegate = self
        
        if isFromLoginLog {
            vw_mainHeightConstant.constant = 280
            vw_chooseCustomer.isHidden = true
            vw_paymentStatus.isHidden = true
        } else if isFromCompletedOrder {
            vw_mainHeightConstant.constant = 400
            vw_chooseCustomer.isHidden = false
            vw_paymentStatus.isHidden = false
        }
        
        txtDate.text = UserDefaults.standard.value(forKey: "loginlogdate") as? String ?? ""
        txtChooseUser.text = UserDefaults.standard.value(forKey: "loginloguser") as? String ?? ""
    }
    
    func dateDropdown() {
        txtDate.optionArray = filterDays
        self.txtDate.didSelect{(selectedText, index, id) in
            print("Selected String: \(selectedText) \n index: \(index), id: \(id)")
           // self.txtDate.selectedIndex = index
            self.txtDate.isFromLoginLogFilterVC = true
            
            switch index {
                case 0:
                    self.txtDate.selectText = Date.getCurrentDate() + " - " + Date.getCurrentDate()
                case 1:
                    self.txtDate.selectText = AppData.sharedInstance.convertDateToString(date: Date.yesterday) + " - " + AppData.sharedInstance.convertDateToString(date: Date.yesterday)
                case 2:
                    self.arr7Days = Date.getDates(forLastNDays: 7)
                    self.txtDate.selectText = self.arr7Days[5] + " - " + Date.getCurrentDate()
                case 3:
                    self.arr7Days = Date.getDates(forLastNDays: 30)
                    self.txtDate.selectText = self.arr7Days[28] + " - " + Date.getCurrentDate()
                case 4:
                    self.txtDate.selectText = AppData.sharedInstance.convertDateToString(date: Date().startDateOfMonth) + " - " + Date.getCurrentDate()
                case 5:
                    self.txtDate.selectText = AppData.sharedInstance.convertDateToString(date: Date().startDateOfPreviousMonth) + " - " + AppData.sharedInstance.convertDateToString(date: Date().endOfPreviousMonth)
                case 6:
                    self.txtDate.selectText = AppData.sharedInstance.convertDateToString(date: Date().getPreviousYearDate) + " - " + Date.getCurrentDate()
                case 7:
                    self.txtDate.hideList()
                    self.vw_popView.isHidden = false
                default:
                    print("Default")
            }
        }
    }
  
    func dateValidation() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let startDate = dateFormatter.date(from: txtStartDate.text ?? "")
        let endDate = dateFormatter.date(from: txtEndDate.text ?? "")
        if txtStartDate.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter start date", viewController: self)
        } else if txtEndDate.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter end date", viewController: self)
        } else if startDate! > endDate! {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Startdate should be less than Enddate", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func getStartEndDate() {
        startdate = txtDate.text ?? ""
        enddate = txtDate.text ?? ""
        if startdate != "" && enddate != "" {
            startdate.removeLast(14)
            enddate.removeFirst(14)
        }
        startdate = AppData.sharedInstance.formattedDateFromString(dateString: startdate, withFormat: "dd-MM-yyyy") ?? ""
        enddate = AppData.sharedInstance.formattedDateFromString(dateString: enddate, withFormat: "dd-MM-yyyy") ?? ""
        
        if startdate != "" && enddate != "" {
            finaldate = startdate + ", " + enddate
        } else {
            finaldate = ""
        }
    }
    
    func countFilterBadge() {
        if txtDate.text == "" && txtChooseUser.text == "" {
            filterBadgeCount = 0
        } else if txtDate.text == "" || txtChooseUser.text == "" {
            filterBadgeCount = 1
        } else {
            filterBadgeCount = 2
        }
    }
    
    func callFilterListUserAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        APIUtilities.sharedInstance.PpOSTArrayAPICallWith(url: BASE_URL + FILTER_CHOOSE_USER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? [[String:Any]] {
                self.arrChooseUser.removeAll()
                for dict in res {
                    self.arrChooseUser.append(ChooseUser(dict: dict))
                }
                
                for dic in self.arrChooseUser {
                    self.arrIds.append(dic.id)
                }
                
                self.txtChooseUser.optionArray = self.arrChooseUser.map { $0.UserName }
                self.txtChooseUser.optionIds = self.arrIds
                self.txtChooseUser.didSelect{(selectedText , index ,id) in
                  //  print( "Selected String: \(selectedText) \n index: \(index),id: \(id)")
                    self.txtChooseUser.selectedIndex = index
                    self.userID = id
                }
            }
        }
    }
    
    func callFilterListCustomerAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        APIUtilities.sharedInstance.PpOSTArrayAPICallWith(url: BASE_URL + FILTER_CHOOSE_CUSTOMER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? [[String:Any]] {
                self.arrChooseCustomer.removeAll()
                for dict in res {
                    self.arrChooseCustomer.append(ChooseCustomerList(dict: dict))
                }
                for dic in self.arrChooseCustomer {
                    self.arrCustomerIds.append(dic.id)
                }
                self.txtChooseCustomer.optionArray = self.arrChooseCustomer.map { $0.FirstName + " " + $0.LastName }
                self.txtChooseCustomer.optionIds = self.arrCustomerIds
                self.txtChooseCustomer.didSelect{ (selectedText, index, id) in
                  //  print( "Selected String: \(selectedText) \n index: \(index),id: \(id)")
                    self.txtChooseCustomer.selectedIndex = index
                    self.selectedCustomerId = id
                }
            }
        }
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCalendarClick(_ sender: UIButton) {
        txtDate.showList()
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        getStartEndDate()
        countFilterBadge()
        UserDefaults.standard.set(txtDate.text, forKey: "loginlogdate")
        UserDefaults.standard.set(txtChooseUser.text, forKey: "loginloguser")
        if isFromLoginLog {
            delegate?.updateLoginLogList(date: finaldate, userId: userID, filterBadgeCount: filterBadgeCount)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnResetClick(_ sender: UIButton) {
        txtDate.text = ""
        txtChooseUser.text = ""
        finaldate = ""
        userID = 0
        getStartEndDate()
        countFilterBadge()
        UserDefaults.standard.removeObject(forKey: "loginlogdate")
        UserDefaults.standard.removeObject(forKey: "loginloguser")
        delegate?.updateLoginLogList(date: finaldate, userId: userID, filterBadgeCount: filterBadgeCount)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCloseDateRangeClick(_ sender: UIButton) {
        vw_popView.isHidden = true
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy"
        if isFromStartDate {
            self.txtStartDate.text = dateformatter.string(from: datePicker.date)
        } else if isFromEndDate {
            self.txtEndDate.text = dateformatter.string(from: datePicker.date)
        }
    }
    
    @IBAction func btnSubmitDateRangeClick(_ sender: UIButton) {
        if dateValidation() {
            txtDate.text = (txtStartDate.text ?? "") + " - " + (txtEndDate.text ?? "")
            vw_popView.isHidden = true
        }
    }
}

extension LoginLogFilterVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtStartDate {
            isFromStartDate = true
            isFromEndDate = false
        } else if textField == txtEndDate {
            isFromEndDate = true
            isFromStartDate = false
        }
        
    }
}
