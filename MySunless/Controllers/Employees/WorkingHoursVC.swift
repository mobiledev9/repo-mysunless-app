//
//  WorkingHoursVC.swift
//  MySunless
//
//  Created by iMac on 17/12/21.
//

import UIKit
import Alamofire

class WorkingHoursVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var vw_blockTime: UIView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var vw_setCustomDateTime: UIView!
    @IBOutlet var vw_date: UIView!
    @IBOutlet var btnCalendar: UIButton!
    @IBOutlet var vw_customStartTime: UIView!
    @IBOutlet var txtCustomStartTime: UITextField!
    @IBOutlet var vw_customEndTime: UIView!
    @IBOutlet var txtCustomEndTime: UITextField!
    @IBOutlet var vw_setDefaultTime: UIView!
    @IBOutlet var vw_defaultStartTime: UIView!
    @IBOutlet var txtDefaultStartTime: UITextField!
    @IBOutlet var vw_defaultEndTime: UIView!
    @IBOutlet var txtDefaultEndTime: UITextField!
    @IBOutlet var vw_workingHrsTable: UIView!
    @IBOutlet var tblWorkingHours: UITableView!
    @IBOutlet var vw_datePicker: UIView!
    @IBOutlet var lblStartTime: UILabel!
    @IBOutlet var lblEndTime: UILabel!
    @IBOutlet var vw_note: UIView!
    @IBOutlet var btnSaveCustomDateTime: UIButton!
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var datepicker: UIDatePicker!
    @IBOutlet var vw_setCustomDateTimeHeightConstraint: NSLayoutConstraint!
    @IBOutlet var vw_mainHeightConstraint: NSLayoutConstraint!
    @IBOutlet var vw_blockTimeHeightConstant: NSLayoutConstraint!
    
    //MARK:- Variable Declarations
    var username = String()
    var employeeId = Int()
    var arrDaysOfWeek = [String]()
    let dateFormatter = DateFormatter()
    var applyToAll = false
    var token = String()
    var setCustomDateTime = true
    var saveCustomDateTime = Bool()
    var customStartTime = String()
    var customEndTime = String()
    var customDate = String()
    
    var monday = String()
    var tuesday = String()
    var wednesday = String()
    var thursday = String()
    var friday = String()
    var saturday = String()
    var sunday = String()
    var mondayStartTime = String()
    var tuesdayStartTime = String()
    var wednesdayStartTime = String()
    var thursdayStartTime = String()
    var fridayStartTime = String()
    var saturdayStartTime = String()
    var sundayStartTime = String()
    var mondayEndTime = String()
    var tuesdayEndTime = String()
    var wednesdayEndTime = String()
    var thursdayEndTime = String()
    var fridayEndTime = String()
    var saturdayEndTime = String()
    var sundayEndTime = String()
    
    var isFirst = false
    var arrWorkingHours = [WorkingHoursData]()
    var day = String()
    var status = String()
    var startTime = String()
    var endTime = String()
    var arrBlockTime = [BlockTime]()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        addDatePicker()
        txtCustomStartTime.delegate = self
        txtCustomEndTime.delegate = self
        txtDefaultStartTime.delegate = self
        txtDefaultEndTime.delegate = self
        lblTitle.text = "Working timetable for" + " " + username
        arrDaysOfWeek = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
        
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        saveCustomDateTime = UserDefaults.standard.bool(forKey: "setCustomDateTime")
        setCustomDateTime = UserDefaults.standard.bool(forKey: "showCustomDateTime")
        
        customDate = UserDefaults.standard.value(forKey: "customDate") as? String ?? ""
        customStartTime = UserDefaults.standard.value(forKey: "customStartTime") as? String ?? ""
        customEndTime = UserDefaults.standard.value(forKey: "customEndTime") as? String ?? ""
        lblDate.text = customDate
        lblTime.text = "(" + customStartTime + " " + "-" + " " + customEndTime + ")"
        
        if saveCustomDateTime == true {
            vw_blockTime.isHidden = false
            vw_blockTimeHeightConstant.constant = 130
            vw_mainHeightConstraint.constant = 1420
        } else {
            vw_blockTime.isHidden = true
            vw_blockTimeHeightConstant.constant = 0
            vw_mainHeightConstraint.constant = 1290
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_blockTime.layer.cornerRadius = 12
        vw_blockTime.layer.masksToBounds = true
        vw_blockTime.backgroundColor = UIColor.white
        vw_blockTime.layer.shadowColor = UIColor.lightGray.cgColor
        vw_blockTime.layer.shadowOpacity = 0.1
        vw_blockTime.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_blockTime.layer.shadowRadius = 6.0
        vw_blockTime.layer.masksToBounds = false
        
        vw_setCustomDateTime.layer.cornerRadius = 12
        vw_setCustomDateTime.layer.masksToBounds = true
        vw_setCustomDateTime.backgroundColor = UIColor.white
        vw_setCustomDateTime.layer.shadowColor = UIColor.lightGray.cgColor
        vw_setCustomDateTime.layer.shadowOpacity = 0.1
        vw_setCustomDateTime.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_setCustomDateTime.layer.shadowRadius = 6.0
        vw_setCustomDateTime.layer.masksToBounds = false
        
        vw_setDefaultTime.layer.cornerRadius = 12
        vw_setDefaultTime.layer.masksToBounds = true
        vw_setDefaultTime.backgroundColor = UIColor.white
        vw_setDefaultTime.layer.shadowColor = UIColor.lightGray.cgColor
        vw_setDefaultTime.layer.shadowOpacity = 0.1
        vw_setDefaultTime.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_setDefaultTime.layer.shadowRadius = 6.0
        vw_setDefaultTime.layer.masksToBounds = false
        
        vw_date.layer.borderWidth = 0.5
        vw_date.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_customStartTime.layer.borderWidth = 0.5
        vw_customStartTime.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_customEndTime.layer.borderWidth = 0.5
        vw_customEndTime.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_defaultStartTime.layer.borderWidth = 0.5
        vw_defaultStartTime.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_defaultEndTime.layer.borderWidth = 0.5
        vw_defaultEndTime.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_datePicker.layer.borderWidth = 0.5
        vw_datePicker.layer.borderColor = UIColor.init("#15B0DA").cgColor
        
        btnCalendar.roundCorners(corners: [.topRight, .bottomRight], radius: 8)
        vw_workingHrsTable.layer.borderColor = UIColor.init("#E5E4E2").cgColor
        vw_workingHrsTable.layer.borderWidth = 1
        vw_workingHrsTable.layer.cornerRadius = 12
        
        vw_datePicker.isHidden = true
        vw_setCustomDateTimeHeightConstraint.constant = 0
        vw_setCustomDateTime.isHidden = true
        
        //customdatetime
       // vw_mainHeightConstraint.constant = 1420
    }
    
    func addDatePicker() {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        datepicker.datePickerMode = .date
    }
    
    func customDateValidation() -> Bool {
        if txtDate.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Select Date", viewController: self)
        } else if txtCustomStartTime.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Select Start Time", viewController: self)
        } else if txtCustomEndTime.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Select End Time", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func defaultTimeValidation() -> Bool {
        if txtDefaultStartTime.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Select Start Time", viewController: self)
        } else if txtDefaultEndTime.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Select End Time", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callSetCustomDateTimeAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["emp_id" : employeeId,
                  "custom_date" : txtDate.text ?? "",
                  "start_time" : txtCustomStartTime.text ?? "",
                  "end_time" : txtCustomEndTime.text ?? ""
        ]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SET_CUSTOM_DATETIME, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        UserDefaults.standard.set(true, forKey: "setCustomDateTime")
                        if let message = res.value(forKey: "message") as? String {
                          //  AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
                            let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (dd) -> Void in
                                self.saveCustomDateTime = UserDefaults.standard.bool(forKey: "setCustomDateTime")
                                
                                DispatchQueue.main.async {
                                    if self.saveCustomDateTime == true {
                                        self.vw_blockTime.isHidden = false
                                        self.vw_blockTimeHeightConstant.constant = 130
                                        self.vw_mainHeightConstraint.constant = 1420
                                    } else {
                                        self.vw_blockTime.isHidden = true
                                        self.vw_blockTimeHeightConstant.constant = 0
                                        self.vw_mainHeightConstraint.constant = 1290
                                    }
                                    self.view.setNeedsLayout()
                                }
                            }
                            alert.addAction(action1)
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        UserDefaults.standard.set(false, forKey: "setCustomDateTime")
                        if let message = res.value(forKey: "message") as? String {
                          //  AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
                            let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (dd) -> Void in
                                self.saveCustomDateTime = UserDefaults.standard.bool(forKey: "setCustomDateTime")
                                
                                DispatchQueue.main.async {
                                    if self.saveCustomDateTime == true {
                                        self.vw_blockTime.isHidden = false
                                        self.vw_blockTimeHeightConstant.constant = 130
                                        self.vw_mainHeightConstraint.constant = 1420
                                    } else {
                                        self.vw_blockTime.isHidden = true
                                        self.vw_blockTimeHeightConstant.constant = 0
                                        self.vw_mainHeightConstraint.constant = 1290
                                    }
                                    self.view.setNeedsLayout()
                                }
                                
                            }
                            alert.addAction(action1)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
//    func alert() {
//        let alert = UIAlertController(title: "", message: "Login Successfully", preferredStyle: UIAlertController.Style.alert)
//        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (dd) -> Void in
//
//            let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//            self.navigationController?.pushViewController(VC, animated: true)
//
//        }
//        alert.addAction(action1)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    func callDeleteBlockTimeAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["emp_id" : employeeId]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_BLOCKTIME, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            
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
    
    func callSetTimeAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        if isFirst {
            employeeId = UserDefaults.standard.value(forKey: "userid") as? Int ?? 0
        }
        params = ["emp_id" : employeeId,
                  "monday" : monday,
                  "monday_start_time" : mondayStartTime.lowercased(),
                  "monday_end_time" : mondayEndTime.lowercased(),
                  "tuesday" : tuesday,
                  "tuesday_start_time" : tuesdayStartTime.lowercased(),
                  "tuesday_end_time" : tuesdayEndTime.lowercased(),
                  "wednesday" : wednesday,
                  "wednesday_start_time" : wednesdayStartTime.lowercased(),
                  "wednesday_end_time" : wednesdayEndTime.lowercased(),
                  "thursday" : thursday,
                  "thursday_start_time" : thursdayStartTime.lowercased(),
                  "thursday_end_time" : thursdayEndTime.lowercased(),
                  "friday" : friday,
                  "friday_start_time" : fridayStartTime.lowercased(),
                  "friday_end_time" : fridayEndTime.lowercased(),
                  "saturday" : saturday,
                  "saturday_start_time" : saturdayStartTime.lowercased(),
                  "saturday_end_time" : saturdayEndTime.lowercased(),
                  "sunday" : sunday,
                  "sunday_start_time" : sundayStartTime.lowercased(),
                  "sunday_end_time" : sundayEndTime.lowercased()
        ]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SET_TIME, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            
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
    
    //MARK:- Actions
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        if (setCustomDateTime == true) {
            vw_setCustomDateTime.isHidden = true
            vw_setCustomDateTimeHeightConstraint.constant = 0
            vw_mainHeightConstraint.constant = 1420
            setCustomDateTime = false
        } else {
            vw_setCustomDateTime.isHidden = false
            vw_setCustomDateTimeHeightConstraint.constant = 400
            vw_mainHeightConstraint.constant = 1820
            setCustomDateTime = true
            
        }
    }
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        callDeleteBlockTimeAPI()
        vw_blockTime.isHidden = true
        vw_blockTimeHeightConstant.constant = 0
        UserDefaults.standard.set(false, forKey: "setCustomDateTime")
    }
    
    @IBAction func btnSetCustomDateTime(_ sender: UIButton) {
        if (setCustomDateTime == true) {
            vw_setCustomDateTime.isHidden = true
            vw_setCustomDateTimeHeightConstraint.constant = 0
            vw_mainHeightConstraint.constant = 1420
            setCustomDateTime = false
            
        } else {
            vw_setCustomDateTime.isHidden = false
            vw_setCustomDateTimeHeightConstraint.constant = 400
            vw_mainHeightConstraint.constant = 1820
            setCustomDateTime = true
            
        }
    }
    
    @IBAction func btnCalendarClick(_ sender: UIButton) {
        if sender.isSelected == true {
            vw_datePicker.isHidden = true
            lblStartTime.isHidden = false
            vw_customStartTime.isHidden = false
            lblEndTime.isHidden = false
            vw_customEndTime.isHidden = false
            vw_note.isHidden = false
            sender.isSelected = false
        } else {
            vw_datePicker.isHidden = false
            lblStartTime.isHidden = true
            vw_customStartTime.isHidden = true
            lblEndTime.isHidden = true
            vw_customEndTime.isHidden = true
            vw_note.isHidden = true
            sender.isSelected = true
        }
    }
    
    @IBAction func btnSaveCustomDateTimeClick(_ sender: UIButton) {
        if (customDateValidation()) {
            callSetCustomDateTimeAPI()
            saveCustomDateTime = UserDefaults.standard.bool(forKey: "setCustomDateTime")
            vw_setCustomDateTime.isHidden = true
            vw_setCustomDateTimeHeightConstraint.constant = 0
            vw_mainHeightConstraint.constant = 1420
            
            customDate = txtDate.text ?? ""
            lblDate.text = customDate
            customStartTime = txtCustomStartTime.text ?? ""
            customEndTime = txtCustomEndTime.text ?? ""
            UserDefaults.standard.set(customStartTime, forKey: "customStartTime")
            UserDefaults.standard.set(customEndTime, forKey: "customEndTime")
            UserDefaults.standard.set(customDate, forKey: "customDate")
            lblTime.text = "(" + customStartTime + " " + "-" + " " + customEndTime + ")"
            
//            DispatchQueue.main.async {
//                if self.saveCustomDateTime == true {
//                    self.vw_blockTime.isHidden = false
//                    self.vw_blockTimeHeightConstant.constant = 130
//                    self.vw_mainHeightConstraint.constant = 1420
//                } else {
//                    self.vw_blockTime.isHidden = true
//                    self.vw_blockTimeHeightConstant.constant = 0
//                    self.vw_mainHeightConstraint.constant = 1290
//                }
//                self.view.setNeedsLayout()
//            }
            
        }
    }
    
    @IBAction func btnApplyToAllClick(_ sender: UIButton) {
        if (self.defaultTimeValidation()) {
            applyToAll = true
            tblWorkingHours.reloadData()
        }
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        txtDate.text = dateFormatter.string(from: sender.date)
        view.endEditing(true)
    }
    
//    @IBAction func switchValueChanged(_ sender: UISwitch) {
//        tblWorkingHours.reloadData()
//    }
    
    @IBAction func btnSaveClick(_ sender: UIButton) {
//        print(monday)
//        print(mondayStartTime)
//        print(mondayEndTime)
        callSetTimeAPI()
    }
    
    @objc func tapCustomStartTimeDone() {
        if let datePicker = self.txtCustomStartTime.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm a"
            self.txtCustomStartTime.text = dateformatter.string(from: datePicker.date).lowercased()
        }
        self.txtCustomStartTime.resignFirstResponder()
    }
    
    @objc func tapCustomEndTimeDone() {
        if let datePicker = self.txtCustomEndTime.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm a"
            self.txtCustomEndTime.text = dateformatter.string(from: datePicker.date).lowercased()
        }
        self.txtCustomEndTime.resignFirstResponder()
    }
    
    @objc func tapDefaultStartTimeDone() {
        if let datePicker = self.txtDefaultStartTime.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm a"
            self.txtDefaultStartTime.text = dateformatter.string(from: datePicker.date).lowercased()
        }
        self.txtDefaultStartTime.resignFirstResponder()
    }
    
    @objc func tapDefaultEndTimeDone() {
        if let datePicker = self.txtDefaultEndTime.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm a"
            self.txtDefaultEndTime.text = dateformatter.string(from: datePicker.date).lowercased()
        }
        self.txtDefaultEndTime.resignFirstResponder()
    }
    
}

extension WorkingHoursVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDaysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblWorkingHours.dequeueReusableCell(withIdentifier: "WorkingHoursCell", for: indexPath) as! WorkingHoursCell
        
        cell.lblDay.text = arrDaysOfWeek[indexPath.row]
        
//        if applyToAll == true {
//            cell.txtFrom.text = txtDefaultStartTime.text
//            cell.txtTo.text = txtDefaultEndTime.text
//            cell.switchValue.setOn(true, animated: true)
//           // applyToAll = false
//        }
        
        //cell.switchValue.tag = indexPath.row
        
        cell.switchValue.tag = indexPath.row
        cell.vc = self
        switch indexPath.row {
            case 0:
                if isFirst {
                    if arrWorkingHours[0].Status == "1" {
                        cell.switchValue.setOn(true, animated: true)
                    } else if arrWorkingHours[0].Status == "0" {
                        cell.switchValue.setOn(false, animated: true)
                    }
                    cell.txtFrom.text = arrWorkingHours[0].starttime
                    cell.txtTo.text = arrWorkingHours[0].endtime
                }
                if applyToAll == true {
                    cell.txtFrom.text = txtDefaultStartTime.text
                    cell.txtTo.text = txtDefaultEndTime.text
                    cell.switchValue.setOn(true, animated: true)
                    cell.cellView.layer.backgroundColor = UIColor.white.cgColor
                    cell.txtFrom.isUserInteractionEnabled = true
                    cell.txtTo.isUserInteractionEnabled = true
                    // applyToAll = false
                }
                mondayStartTime = cell.txtFrom.text ?? ""
                mondayEndTime = cell.txtTo.text ?? ""
                if cell.switchValue.isOn {
                    monday = "1"
                } else {
                    monday = "0"
                }
            case 1:
                if isFirst {
                    if arrWorkingHours[1].Status == "1" {
                        cell.switchValue.setOn(true, animated: true)
                    } else if arrWorkingHours[1].Status == "0" {
                        cell.switchValue.setOn(false, animated: true)
                    }
                    cell.txtFrom.text = arrWorkingHours[1].starttime
                    cell.txtTo.text = arrWorkingHours[1].endtime
                }
                if applyToAll == true {
                    cell.txtFrom.text = txtDefaultStartTime.text
                    cell.txtTo.text = txtDefaultEndTime.text
                    cell.switchValue.setOn(true, animated: true)
                    cell.cellView.layer.backgroundColor = UIColor.white.cgColor
                    cell.txtFrom.isUserInteractionEnabled = true
                    cell.txtTo.isUserInteractionEnabled = true
                    // applyToAll = false
                }
                tuesdayStartTime = cell.txtFrom.text ?? ""
                tuesdayEndTime = cell.txtTo.text ?? ""
                if cell.switchValue.isOn {
                    tuesday = "1"
                } else {
                    tuesday = "0"
                }
            case 2:
                if isFirst {
                    if arrWorkingHours[2].Status == "1" {
                        cell.switchValue.setOn(true, animated: true)
                    } else if arrWorkingHours[2].Status == "0" {
                        cell.switchValue.setOn(false, animated: true)
                    }
                    cell.txtFrom.text = arrWorkingHours[2].starttime
                    cell.txtTo.text = arrWorkingHours[2].endtime
                }
                if applyToAll == true {
                    cell.txtFrom.text = txtDefaultStartTime.text
                    cell.txtTo.text = txtDefaultEndTime.text
                    cell.switchValue.setOn(true, animated: true)
                    cell.cellView.layer.backgroundColor = UIColor.white.cgColor
                    cell.txtFrom.isUserInteractionEnabled = true
                    cell.txtTo.isUserInteractionEnabled = true
                    // applyToAll = false
                }
                wednesdayStartTime = cell.txtFrom.text ?? ""
                wednesdayEndTime = cell.txtTo.text ?? ""
                
                if cell.switchValue.isOn {
                    wednesday = "1"
                } else {
                    wednesday = "0"
                }
            case 3:
                if isFirst {
                    if arrWorkingHours[3].Status == "1" {
                        cell.switchValue.setOn(true, animated: true)
                    } else if arrWorkingHours[3].Status == "0" {
                        cell.switchValue.setOn(false, animated: true)
                    }
                    cell.txtFrom.text = arrWorkingHours[3].starttime
                    cell.txtTo.text = arrWorkingHours[3].endtime
                }
                if applyToAll == true {
                    cell.txtFrom.text = txtDefaultStartTime.text
                    cell.txtTo.text = txtDefaultEndTime.text
                    cell.switchValue.setOn(true, animated: true)
                    cell.cellView.layer.backgroundColor = UIColor.white.cgColor
                    cell.txtFrom.isUserInteractionEnabled = true
                    cell.txtTo.isUserInteractionEnabled = true
                    // applyToAll = false
                }
                thursdayStartTime = cell.txtFrom.text ?? ""
                thursdayEndTime = cell.txtTo.text ?? ""
                
                if cell.switchValue.isOn {
                    thursday = "1"
                } else {
                    thursday = "0"
                }
            case 4:
                if isFirst {
                    if arrWorkingHours[4].Status == "1" {
                        cell.switchValue.setOn(true, animated: true)
                    } else if arrWorkingHours[4].Status == "0" {
                        cell.switchValue.setOn(false, animated: true)
                    }
                    cell.txtFrom.text = arrWorkingHours[4].starttime
                    cell.txtTo.text = arrWorkingHours[4].endtime
                }
                if applyToAll == true {
                    cell.txtFrom.text = txtDefaultStartTime.text
                    cell.txtTo.text = txtDefaultEndTime.text
                    cell.switchValue.setOn(true, animated: true)
                    cell.cellView.layer.backgroundColor = UIColor.white.cgColor
                    cell.txtFrom.isUserInteractionEnabled = true
                    cell.txtTo.isUserInteractionEnabled = true
                    // applyToAll = false
                }
                fridayStartTime = cell.txtFrom.text ?? ""
                fridayEndTime = cell.txtTo.text ?? ""
                
                if cell.switchValue.isOn {
                    friday = "1"
                } else {
                    friday = "0"
                }
            case 5:
                if isFirst {
                    if arrWorkingHours[5].Status == "1" {
                        cell.switchValue.setOn(true, animated: true)
                    } else if arrWorkingHours[5].Status == "0" {
                        cell.switchValue.setOn(false, animated: true)
                    }
                    cell.txtFrom.text = arrWorkingHours[5].starttime
                    cell.txtTo.text = arrWorkingHours[5].endtime
                }
                if applyToAll == true {
                    cell.txtFrom.text = txtDefaultStartTime.text
                    cell.txtTo.text = txtDefaultEndTime.text
                    cell.switchValue.setOn(true, animated: true)
                    cell.cellView.layer.backgroundColor = UIColor.white.cgColor
                    cell.txtFrom.isUserInteractionEnabled = true
                    cell.txtTo.isUserInteractionEnabled = true
                    // applyToAll = false
                }
                saturdayStartTime = cell.txtFrom.text ?? ""
                saturdayEndTime = cell.txtTo.text ?? ""
                
                if cell.switchValue.isOn {
                    saturday = "1"
                } else {
                    saturday = "0"
                }
            case 6:
                if isFirst {
                    if arrWorkingHours[6].Status == "1" {
                        cell.switchValue.setOn(true, animated: true)
                    } else if arrWorkingHours[6].Status == "0" {
                        cell.switchValue.setOn(false, animated: true)
                    }
                    cell.txtFrom.text = arrWorkingHours[6].starttime
                    cell.txtTo.text = arrWorkingHours[6].endtime
                }
                if applyToAll == true {
                    cell.txtFrom.text = txtDefaultStartTime.text
                    cell.txtTo.text = txtDefaultEndTime.text
                    cell.switchValue.setOn(true, animated: true)
                    cell.cellView.layer.backgroundColor = UIColor.white.cgColor
                    cell.txtFrom.isUserInteractionEnabled = true
                    cell.txtTo.isUserInteractionEnabled = true
                    // applyToAll = false
                }
                sundayStartTime = cell.txtFrom.text ?? ""
                sundayEndTime = cell.txtTo.text ?? ""
                
                if cell.switchValue.isOn {
                    sunday = "1"
                } else {
                    sunday = "0"
                }
                
            default:
                print("Default")
        }
        
        if cell.switchValue.isOn {
            cell.cellView.layer.backgroundColor = UIColor.white.cgColor
            cell.txtFrom.isUserInteractionEnabled = true
            cell.txtTo.isUserInteractionEnabled = true
        } else {
            cell.cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
            cell.txtFrom.isUserInteractionEnabled = false
            cell.txtTo.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    
}

extension WorkingHoursVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension WorkingHoursVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtCustomStartTime {
            self.txtCustomStartTime.setInputViewTimePicker(target: self, selector: #selector(tapCustomStartTimeDone))
        } else if textField == txtCustomEndTime {
            self.txtCustomEndTime.setInputViewTimePicker(target: self, selector: #selector(tapCustomEndTimeDone))
        } else if textField == txtDefaultStartTime {
            self.txtDefaultStartTime.setInputViewTimePicker(target: self, selector: #selector(tapDefaultStartTimeDone))
        } else if textField == txtDefaultEndTime {
            self.txtDefaultEndTime.setInputViewTimePicker(target: self, selector: #selector(tapDefaultEndTimeDone))
        }
        
    }
}
