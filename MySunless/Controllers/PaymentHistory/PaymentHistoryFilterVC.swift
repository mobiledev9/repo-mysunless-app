//
//  PaymentHistoryFilterVC.swift
//  MySunless
//
//  Created by dds on 26/08/22.
//

import UIKit
import iOSDropDown
import Alamofire

class PaymentHistoryFilterVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_mainHeightConstant: NSLayoutConstraint!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_Date: UIView!
    @IBOutlet var chooseDateDropdown: DropDown!
    @IBOutlet var vw_chooseUser: UIView!
    @IBOutlet var chooseUserDropdown: DropDown!
    @IBOutlet var vw_chooseCustomer: UIView!
    @IBOutlet var chooseCustomerDropdown: DropDown!
    @IBOutlet var vw_choosePayment: UIView!
    @IBOutlet var choosePaymentDropdown: DropDown!
    @IBOutlet var chooseUserCollectionView: UICollectionView!
    @IBOutlet var chooseCustomerCollectionView: UICollectionView!
    @IBOutlet var choosePaymentCollectionView: UICollectionView!
    @IBOutlet var vw_popView: UIView!
    @IBOutlet var vw_popTopView: UIView!
    @IBOutlet var vw_popBottomView: UIView!
    @IBOutlet var vw_startDate: UIView!
    @IBOutlet var txtStartDate: UITextField!
    @IBOutlet var vw_endDate: UIView!
    @IBOutlet var txtEndDate: UITextField!
    @IBOutlet var vw_datePicker: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrChooseUser = [ChooseUser]()
    var arrChooseCustomer = [ChooseCustomerList]()
    var delegateOfPaymentHistory : FilterPaymentHistoryProtocol?
    var delegateOfPerformanceList : FilterPerformanceListProtocol?
    var arr7Days = [String]()
    var valSelctedPaymentDate : (String,Int) = ("",-1)
    var arrSelctedCustomers = [(String,String)]()
    var arrSelctedUsers = [(String,String)]()
    var arrSelctedPaymnetType = [(String,String)]()
    var isFromPaymentHistory : Bool = false
    var isFromPerformanceList : Bool = false
    var finaldate = String()
    var startdate = String()
    var enddate = String()
    var userID = Int()
    var filterBadgeCount = Int()
    var tapCustomer = UITapGestureRecognizer()
    var tapUser = UITapGestureRecognizer()
    var tapPaymentStatus = UITapGestureRecognizer()
    var arrPaymentStatus = ["Cash", "Cheque", "Card"]
   
    var isFromStartDate = false
    var isFromEndDate = false
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        dateDropdown(selectedIndex: valSelctedPaymentDate.1)
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        setPaymentfilter()
        callFilterListUserAPI()
        callFilterListCustomerAPI()
    }
    
    func dateDropdown(selectedIndex : Int) {
        chooseDateDropdown.optionArray = filterDays
        self.chooseDateDropdown.didSelect{(selectedText, index, id) in
            self.chooseDateDropdown.isFromLoginLogFilterVC = true
            self.chooseDateDropdown.selectText = selectedText
            self.setFilterDate(index: index)
            
        }
    }
    
    func setFilterDate(index: Int) {
        switch index {
        case 0:
            self.chooseDateDropdown.selectText = Date.getCurrentDate() + " - " + Date.getCurrentDate()
        case 1:
            self.chooseDateDropdown.selectText = AppData.sharedInstance.convertDateToString(date: Date.yesterday) + " - " + AppData.sharedInstance.convertDateToString(date: Date.yesterday)
        case 2:
            self.arr7Days = Date.getDates(forLastNDays: 7)
            self.chooseDateDropdown.selectText = self.arr7Days[5] + " - " + Date.getCurrentDate()
        case 3:
            self.arr7Days = Date.getDates(forLastNDays: 30)
            self.chooseDateDropdown.selectText = self.arr7Days[28] + " - " + Date.getCurrentDate()
        case 4:
            self.chooseDateDropdown.selectText = AppData.sharedInstance.convertDateToString(date: Date().startDateOfMonth) + " - " + Date.getCurrentDate()
        case 5:
            self.chooseDateDropdown.selectText = AppData.sharedInstance.convertDateToString(date: Date().startDateOfPreviousMonth) + " - " + AppData.sharedInstance.convertDateToString(date: Date().endOfPreviousMonth)
        case 6:
            self.chooseDateDropdown.selectText = AppData.sharedInstance.convertDateToString(date: Date().getPreviousYearDate) + " - " + Date.getCurrentDate()
        case 7:
            if isFromPerformanceList {
                vw_mainHeightConstant.constant = 600
            }
            self.chooseDateDropdown.hideList()
            self.vw_popView.isHidden = false
        default:
            print("Default")
        }
    }
    
    func setPaymentfilter () {
        choosePaymentDropdown.optionArray = arrPaymentStatus
        choosePaymentDropdown.optionIds = arrEventStatus.enumerated().map{$0.offset}
        choosePaymentDropdown.didSelect{(selectedText , index ,id) in
            print( "Selected String: \(selectedText) \n index: \(index),id: \(id)")
            self.choosePaymentDropdown.selectedIndex = index
            self.choosePaymentDropdown.selectText = selectedText
            self.choosePaymentCollectionView.isHidden = false
            self.setPaymentStatusData(strText: selectedText,strId: "\(id)")
        
        }
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_mainView.layer.borderWidth = 1.0
        vw_mainView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        vw_bottom.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
        vw_Date.layer.borderWidth = 0.5
        vw_Date.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_chooseUser.layer.borderWidth = 0.5
        vw_chooseUser.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_chooseCustomer.layer.borderWidth = 0.5
        vw_chooseCustomer.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_choosePayment.layer.borderWidth = 0.5
        vw_choosePayment.layer.borderColor = UIColor.init("#15B0DA").cgColor
        
        vw_popView.isHidden = true
        txtStartDate.delegate = self
        txtEndDate.delegate = self
        
        if isFromPaymentHistory {
            
            tapCustomer.numberOfTapsRequired = 1
            tapCustomer.numberOfTouchesRequired = 1
            tapCustomer.delegate = self
            chooseCustomerCollectionView?.addGestureRecognizer(tapCustomer)
            
            tapUser.numberOfTapsRequired = 1
            tapUser.numberOfTouchesRequired = 1
            tapUser.delegate = self
            chooseUserCollectionView?.addGestureRecognizer(tapUser)
            
            tapPaymentStatus.numberOfTapsRequired = 1
            tapPaymentStatus.numberOfTouchesRequired = 1
            tapPaymentStatus.delegate = self
            choosePaymentCollectionView?.addGestureRecognizer(tapPaymentStatus)
            
            if valSelctedPaymentDate != ("",-1) {
                
                chooseDateDropdown.selectedIndex = valSelctedPaymentDate.1
                chooseDateDropdown.selectText = ""
                if valSelctedPaymentDate.1 != 7 {
                    setFilterDate(index: valSelctedPaymentDate.1)
                    chooseDateDropdown.text =  chooseDateDropdown.selectText
                } else {
                    chooseDateDropdown.text = valSelctedPaymentDate.0
                }
            } else {
                chooseDateDropdown.text = ""
                chooseDateDropdown.selectText = ""
                chooseDateDropdown.selectedIndex = -1
            }
            
            if arrSelctedUsers.count > 0 {
                chooseUserCollectionView.isHidden = false
            } else {
                chooseUserCollectionView.isHidden = true
            }
            
            if arrSelctedCustomers.count > 0 {
                chooseCustomerCollectionView.isHidden = false
            } else {
                chooseCustomerCollectionView.isHidden = true
            }
            if arrSelctedPaymnetType.count > 0 {
                choosePaymentCollectionView.isHidden = false
            } else {
                choosePaymentCollectionView.isHidden = true
            }
          
        }
        
        if isFromPerformanceList {
            vw_mainHeightConstant.constant = 200
            vw_chooseUser.isHidden = true
            vw_chooseCustomer.isHidden = true
            vw_choosePayment.isHidden = true
            if valSelctedPaymentDate != ("",-1) {
                
                chooseDateDropdown.selectedIndex = valSelctedPaymentDate.1
                chooseDateDropdown.selectText = ""
                if valSelctedPaymentDate.1 != 7 {
                    setFilterDate(index: valSelctedPaymentDate.1)
                    chooseDateDropdown.text =  chooseDateDropdown.selectText
                } else {
                    chooseDateDropdown.text = valSelctedPaymentDate.0
                }
            } else {
                chooseDateDropdown.text = ""
                chooseDateDropdown.selectText = ""
                chooseDateDropdown.selectedIndex = -1
            }
        }
    }
    
    func getStartEndDate() {
        if chooseDateDropdown.selectText == "" {
            
        } else {
            startdate = chooseDateDropdown.selectText
            enddate = chooseDateDropdown.selectText
            
            if startdate != "" && enddate != "" {
                startdate.removeLast(14)
                enddate.removeFirst(14)
            }
            startdate = AppData.sharedInstance.formattedDateFromString(dateString: startdate, withFormat: "dd-MM-yyyy") ?? ""
            enddate = AppData.sharedInstance.formattedDateFromString(dateString: enddate, withFormat: "dd-MM-yyyy") ?? ""
            
            if startdate != "" && enddate != "" {
                finaldate = startdate + " , " + enddate
                valSelctedPaymentDate = (finaldate,chooseDateDropdown.selectedIndex ?? -1)
            } else {
                finaldate = ""
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
    
    func countFilterBadge() {
        filterBadgeCount = 0
        if chooseDateDropdown.text != "" {
            filterBadgeCount = filterBadgeCount + 1
        }
        if arrSelctedCustomers.count > 0 {
            filterBadgeCount = filterBadgeCount + 1
        }
        if arrSelctedUsers.count > 0 {
            filterBadgeCount = filterBadgeCount + 1
        }
        if choosePaymentDropdown.text != "" {
            filterBadgeCount = filterBadgeCount + 1
        }
    }
    
    func setCustomerData(strText :String,strId :String) {
        if !self.arrSelctedCustomers.map({$0.1}).contains(strId) {
            self.arrSelctedCustomers.append((strText,strId))
        }
        DispatchQueue.main.async {
            self.chooseCustomerCollectionView.reloadData()
        }
    }
    
    func setUserData(strText :String,strId :String) {
        if !self.arrSelctedUsers.map({$0.1}).contains(strId) {
            self.arrSelctedUsers.append((strText,strId))
        }
        DispatchQueue.main.async {
            self.chooseUserCollectionView.reloadData()
        }
    }
    func setPaymentStatusData(strText :String,strId :String) {
        if !self.arrSelctedPaymnetType.map({$0.1}).contains(strId) {
            self.arrSelctedPaymnetType.append((strText,strId))
        }
        DispatchQueue.main.async {
            self.choosePaymentCollectionView.reloadData()
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
                
                self.chooseUserDropdown.optionArray = self.arrChooseUser.map { $0.firstname + " " + $0.lastname }
                self.chooseUserDropdown.optionIds = self.arrChooseUser.map{ $0.id }
                self.chooseUserDropdown.didSelect{(selectedText , index ,id) in
                    print( "Selected String: \(selectedText) \n index: \(index),id: \(id)")
                    self.chooseUserDropdown.selectedIndex = index
                    self.chooseUserCollectionView.isHidden = false
                    self.setUserData(strText: selectedText, strId: "\(id)")
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
                self.chooseCustomerDropdown.optionArray = self.arrChooseCustomer.map { $0.FirstName + " " + $0.LastName }
                self.chooseCustomerDropdown.optionIds = self.arrChooseCustomer.map{ $0.id }
                self.chooseCustomerDropdown.didSelect{(selectedText , index ,id) in
                    print( "Selected String: \(selectedText) \n index: \(index),id: \(id)")
                   self.chooseCustomerDropdown.selectedIndex = index
                    self.chooseCustomerCollectionView.isHidden = false
                    self.setCustomerData(strText: selectedText, strId: "\(id)")
                }
            }
        }
    }
    
    @objc func closeUserCellClick(_ sender: UIButton) {
        arrSelctedUsers.remove(at: sender.tag)
        if arrSelctedUsers.count == 0{
            chooseUserCollectionView.isHidden = true
        }
        chooseUserCollectionView.reloadData()
    }
    @objc func closeCustomerCellClick(_ sender: UIButton) {
        arrSelctedCustomers.remove(at: sender.tag)
        if arrSelctedCustomers.count == 0{
            chooseCustomerCollectionView.isHidden = true
        }
        chooseCustomerCollectionView.reloadData()
    }
    @objc func closePaymentTypeCellClick(_ sender: UIButton) {
        arrSelctedPaymnetType.remove(at: sender.tag)
        if arrSelctedPaymnetType.count == 0{
            choosePaymentCollectionView.isHidden = true
        }
        choosePaymentCollectionView.reloadData()
    }
   
    //MARK:- Actions
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.countFilterBadge()
            self.getStartEndDate()
            
            self.dismiss(animated: true, completion:{
                if self.isFromPaymentHistory {
                    self.delegateOfPaymentHistory?.updatePaymentHistory(PaymentDatas: self.valSelctedPaymentDate, userDatas: self.arrSelctedUsers, CustomerDatas: self.arrSelctedCustomers, PaymentsDatas:self.arrSelctedPaymnetType, filterBadgeCount: self.filterBadgeCount)
                }
                if self.isFromPerformanceList {
                    self.delegateOfPerformanceList?.updatePerformanceList(DateDatas: self.valSelctedPaymentDate, filterBadgeCount: self.filterBadgeCount)
                }
            })
 }
    }
    @IBAction func btnResetClick(_ sender: UIButton) {
        chooseDateDropdown.text = ""
        valSelctedPaymentDate = ("",-1)
        chooseUserDropdown.text = ""
        chooseCustomerDropdown.text = ""
        choosePaymentDropdown.text = ""
        arrSelctedPaymnetType.removeAll()
        arrSelctedUsers.removeAll()
        arrSelctedCustomers.removeAll()
       
        countFilterBadge()
        self.dismiss(animated: true) {
            if self.isFromPaymentHistory {
                self.delegateOfPaymentHistory?.updatePaymentHistory(PaymentDatas: self.valSelctedPaymentDate, userDatas: self.arrSelctedUsers, CustomerDatas: self.arrSelctedCustomers, PaymentsDatas:self.arrSelctedPaymnetType, filterBadgeCount: self.filterBadgeCount)
            }
            if self.isFromPerformanceList {
                self.delegateOfPerformanceList?.updatePerformanceList(DateDatas: self.valSelctedPaymentDate, filterBadgeCount: self.filterBadgeCount)
            }
            UserDefaults.standard.removeObject(forKey: "loginlogdate")
            UserDefaults.standard.removeObject(forKey: "loginloguser")
        }
    }
    
    @IBAction func btnCloseDateRangeClick(_ sender: UIButton) {
        vw_popView.isHidden = true
        if isFromPerformanceList {
            vw_mainHeightConstant.constant = 200
        }
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
            if isFromPerformanceList {
                vw_mainHeightConstant.constant = 200
            }
            chooseDateDropdown.text = (txtStartDate.text ?? "") + " - " + (txtEndDate.text ?? "")
            chooseDateDropdown.selectText = (txtStartDate.text ?? "") + " - " + (txtEndDate.text ?? "")
            vw_popView.isHidden = true
        }
    }
    
    
}

//MARK:- Collection view Delegate Methods
extension PaymentHistoryFilterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case chooseUserCollectionView:
            return arrSelctedUsers.count
        case chooseCustomerCollectionView:
            return arrSelctedCustomers.count
        case choosePaymentCollectionView:
            return arrSelctedPaymnetType.count
         default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.cellView.layer.cornerRadius = 8
        switch collectionView {
        case chooseUserCollectionView:
            cell.lblName.text = arrSelctedUsers[indexPath.item].0
            cell.btnClose.tag = indexPath.item
            cell.btnClose.addTarget(self, action: #selector(closeUserCellClick(_:)), for: .touchUpInside)
        case chooseCustomerCollectionView:
            
            cell.lblName.text = arrSelctedCustomers[indexPath.item].0
            cell.btnClose.tag = indexPath.item
            cell.btnClose.addTarget(self, action: #selector(closeCustomerCellClick(_:)), for: .touchUpInside)
        case choosePaymentCollectionView:
            
            cell.lblName.text = arrSelctedPaymnetType[indexPath.item].0
            cell.btnClose.tag = indexPath.item
            cell.btnClose.addTarget(self, action: #selector(closePaymentTypeCellClick(_:)), for: .touchUpInside)
        
        default:
            cell.lblName.text = ""
        }
        cell.btnClose.tag = indexPath.item
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case chooseUserCollectionView:
            return CGSize(width: arrSelctedUsers[indexPath.item].0.size(withAttributes: nil).width + 100, height: 38)
        case chooseCustomerCollectionView:
            return CGSize(width: arrSelctedCustomers[indexPath.item].0.size(withAttributes: nil).width + 100, height: 38)
        case choosePaymentCollectionView:
            return CGSize(width: arrSelctedPaymnetType[indexPath.item].0.size(withAttributes: nil).width + 100, height: 38)
        
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case chooseUserCollectionView:
            chooseUserDropdown.showList()
        case chooseCustomerCollectionView:
            chooseCustomerDropdown.showList()
        case choosePaymentCollectionView:
            choosePaymentDropdown.showList()
         default:
            print("Default")
        }
    }
}

extension PaymentHistoryFilterVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        switch gestureRecognizer {
        case tapCustomer:
            let point = touch.location(in: chooseCustomerCollectionView)
            if let indexPath = chooseCustomerCollectionView?.indexPathForItem(at: point),
               let cell = chooseCustomerCollectionView?.cellForItem(at: indexPath) {
                return touch.location(in: cell).y > 50
            }
            chooseCustomerDropdown.showList()
        case tapUser:
            let point = touch.location(in: chooseUserCollectionView)
            if let indexPath = chooseUserCollectionView?.indexPathForItem(at: point),
               let cell = chooseUserCollectionView?.cellForItem(at: indexPath) {
                return touch.location(in: cell).y > 50
            }
            chooseUserDropdown.showList()
        case tapPaymentStatus:
            let point = touch.location(in: choosePaymentCollectionView)
            if let indexPath = choosePaymentCollectionView?.indexPathForItem(at: point),
               let cell = choosePaymentCollectionView?.cellForItem(at: indexPath) {
                return touch.location(in: cell).y > 50
            }
            choosePaymentDropdown.showList()
            
        default:
            print("Default")
        }
        return false
    }
}

extension PaymentHistoryFilterVC: UITextFieldDelegate {
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
