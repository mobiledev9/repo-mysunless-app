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
    @IBOutlet var chooseCustomerCollectionView: UICollectionView!
    @IBOutlet var chooseUserCollectionView: UICollectionView!
    @IBOutlet weak var tblFilter: UITableView!
   
    
    var arrChooseUser = [ChooseUser]()
    var arrChooseUserFromPending = [SubscriberAdminFilter]()
    var token = String()
    var delegate: UpdateLoginLog?
    var delegateOfCompletedOrder: CompletedOrderProtocol?
    var delegateOfPendingOrder: PendingOrderProtocol?
    var delegateOfPaymentHistory: FilterPaymentHistoryProtocol?
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
    var isFromPendingOrder = false
    var arrChooseCustomer = [ChooseCustomerList]()
   
    var arrPaymentStatus = ["Cash", "Cheque", "Card"]
    var arrCustomerIds = [Int]()
    var selectedCustomerId = Int()
    var tapCustomer = UITapGestureRecognizer()
    var tapUser = UITapGestureRecognizer()
    var tapPaymentStatus =  UITapGestureRecognizer()
    var arrCustomerCollection = [String]()
    var arrUserCollection = [String]()
    var selectedCustomer = String()
    var arrSelectedCustIds = [(String,String)]()
    var selectedUser = String()
    var arrSelectedUserIds = [(String,String)]()
    var selectedPaymentStatusIndex : Int = -1
    var selectedDatefilterIndex : Int = -1
    var arrCollectionUsersForPending = [String]()
    var arrCollectionIdsForPending = [String]()
    var valSelectedUserAndId : (String,Int) = ("",-1)//value and id
    var valSelectedDate : (String,Int) = ("",-1)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        dateDropdown(selectedIndex: selectedDatefilterIndex)
        if isFromLoginLog {
            callFilterListUserAPI()
            if valSelectedUserAndId != ("",-1) {
                txtChooseUser.text = valSelectedUserAndId.0
                didSelectUser()
            }
            if valSelectedDate != ("",-1) {
                txtDate.text =   txtDate.selectText
            }
        }
        
        if isFromCompletedOrder {
            callFilterListUserAPI()
            callFilterListCustomerAPI()
            txtPaymentStatus.optionArray = arrPaymentStatus
            txtPaymentStatus.didSelect{(selectedText , index ,id) in
                self.txtPaymentStatus.selectText = selectedText
                self.txtPaymentStatus.text = selectedText
                self.selectedPaymentStatusIndex = index
            }
            if selectedDatefilterIndex != -1 {
                txtDate.selectedIndex = selectedDatefilterIndex
                setFilterDate(index: selectedDatefilterIndex)
                self.txtDate.text = txtDate.selectText
            }
            
            if arrSelectedUserIds.count != 0 {
                chooseUserCollectionView.isHidden = false
                arrUserCollection = arrSelectedUserIds.map{$0.0}
                didSelectUser()
            } else {
                chooseUserCollectionView.isHidden = true
            }
            
            if arrSelectedCustIds.count != 0 {
                chooseCustomerCollectionView.isHidden = false
                arrCustomerCollection = arrSelectedCustIds.map{$0.0}
            } else {
                chooseCustomerCollectionView.isHidden = true
            }
            
            if selectedPaymentStatusIndex != -1 {
                self.txtPaymentStatus.selectedIndex = selectedPaymentStatusIndex
                txtPaymentStatus.text = arrPaymentStatus[selectedPaymentStatusIndex]
                self.txtPaymentStatus.text = arrPaymentStatus[selectedPaymentStatusIndex]
            }
           
        }
        
        if isFromPendingOrder {
            callGetUserForFilterAPIFromPending()
            callFilterListCustomerAPI()
            vw_paymentStatus.isHidden = true
            if selectedDatefilterIndex != -1 {
                txtDate.selectedIndex = selectedDatefilterIndex
                setFilterDate(index: selectedDatefilterIndex)
                self.txtDate.text = txtDate.selectText
            }
            
            if arrSelectedUserIds.count != 0 {
                chooseUserCollectionView.isHidden = false
                arrUserCollection = arrSelectedUserIds.map{$0.0}
                didSelectUser()
            } else {
                chooseUserCollectionView.isHidden = true
            }
            
            if arrSelectedCustIds.count != 0 {
                chooseCustomerCollectionView.isHidden = false
                arrCustomerCollection = arrSelectedCustIds.map{$0.0}
            } else {
                chooseCustomerCollectionView.isHidden = true
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
        tblFilter.layer.borderWidth = 0.5
        tblFilter.layer.borderColor = UIColor.init("#15B0DA").cgColor
        tblFilter.layer.cornerRadius = 12
        tblFilter.isHidden = true
        tblFilter.tableFooterView = UIView()
        
        vw_popView.isHidden = true
        txtStartDate.delegate = self
        txtEndDate.delegate = self
      
        if isFromLoginLog {
            vw_mainHeightConstant.constant = 280
            vw_chooseCustomer.isHidden = true
            vw_paymentStatus.isHidden = true
            chooseUserCollectionView.isHidden = true
            selectedDatefilterIndex = valSelectedDate.1

        } else if isFromCompletedOrder {
            vw_mainHeightConstant.constant = 400
            vw_chooseCustomer.isHidden = false
            vw_paymentStatus.isHidden = false
            
            tapCustomer.numberOfTapsRequired = 1
            tapCustomer.numberOfTouchesRequired = 1
            tapCustomer.delegate = self
            chooseCustomerCollectionView?.addGestureRecognizer(tapCustomer)
            
            tapUser.numberOfTapsRequired = 1
            tapUser.numberOfTouchesRequired = 1
            tapUser.delegate = self
            chooseUserCollectionView?.addGestureRecognizer(tapUser)
            
        }  else if isFromPendingOrder {
            vw_mainHeightConstant.constant = 320
            vw_chooseCustomer.isHidden = false
            vw_paymentStatus.isHidden = true
            
            let textViewRecognizer = UITapGestureRecognizer()
            textViewRecognizer.addTarget(self, action: #selector(detectTextfieldClick(_:)))
            txtChooseUser.addGestureRecognizer(textViewRecognizer)
            
            tapCustomer.numberOfTapsRequired = 1
            tapCustomer.numberOfTouchesRequired = 1
            tapCustomer.delegate = self
            chooseCustomerCollectionView?.addGestureRecognizer(tapCustomer)
            
            tapUser.numberOfTapsRequired = 1
            tapUser.numberOfTouchesRequired = 1
            tapUser.delegate = self
            chooseUserCollectionView?.addGestureRecognizer(tapUser)
            
            let tap = UITapGestureRecognizer(target: self, action: nil)
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            tap.delegate = self
            chooseUserCollectionView?.addGestureRecognizer(tap)
            chooseUserCollectionView.isHidden = true
            
            tblFilter.register(UINib(nibName: "CustomFilterHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomFilterHeaderView")
            tblFilter.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
            
            let dummyViewHeight = CGFloat(40)
            tblFilter.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tblFilter.bounds.size.width, height: dummyViewHeight))
            tblFilter.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        }
        
        txtDate.text = UserDefaults.standard.value(forKey: "loginlogdate") as? String ?? ""
        txtChooseUser.text = UserDefaults.standard.value(forKey: "loginloguser") as? String ?? ""
    }
    
    func dateDropdown(selectedIndex : Int) {
        txtDate.optionArray = filterDays
        self.txtDate.didSelect{(selectedText, index, id) in
           // print("Selected String: \(selectedText) \n index: \(index), id: \(id)")
            self.txtDate.isFromLoginLogFilterVC = true
            self.txtDate.selectText = "good"
            self.selectedDatefilterIndex = index
            self.setFilterDate(index: index)

        }
        if selectedIndex != -1 {
            self.selectedDatefilterIndex = selectedIndex
            self.setFilterDate(index: selectedIndex)
        }
    }
    
    func setFilterDate(index: Int) {
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
    
    func setCustomerData(strText :String,strId :String) {
        if !self.arrCustomerCollection.contains(strText) {
            self.arrCustomerCollection.append(strText)
            let data = (strText,strId)
            self.arrSelectedCustIds.append(data)
        }
        DispatchQueue.main.async {
            self.chooseCustomerCollectionView.reloadData()
        }
    }
    
    func setUserData(strText :String,strId :String) {
        if !self.arrUserCollection.contains(strText) {
            self.arrUserCollection.append(strText)
            let data = (strText,strId)
            self.arrSelectedUserIds.append(data)
        }
        DispatchQueue.main.async {
            self.chooseUserCollectionView.reloadData()
        }
    }
    
    func didSelectCustomer() {
        self.txtChooseCustomer.optionArray = self.arrChooseCustomer.map{ $0.FirstName.capitalized + " " + $0.LastName.capitalized}
        self.txtChooseCustomer.optionIds = self.arrChooseCustomer.map{ $0.id }
        self.txtChooseCustomer.didSelect{(selectedText, index, id) in
            self.txtChooseCustomer.selectedIndex = index
            self.chooseCustomerCollectionView.isHidden = false
            self.selectedCustomer = selectedText
            self.setCustomerData(strText:selectedText,strId:"\(id)")
        }
    }
   
    func didSelectUser() {
        self.txtChooseUser.optionArray = self.arrChooseUser.map{ $0.firstname + " " + $0.lastname.capitalized}
        self.txtChooseUser.optionIds = self.arrChooseUser.map{ $0.id }
        
        self.txtChooseUser.didSelect{(selectedText, index, id) in
            self.txtChooseUser.selectedIndex = index
            self.chooseUserCollectionView.isHidden = false
            self.selectedUser = selectedText
            
            if self.isFromLoginLog {
                self.chooseUserCollectionView.isHidden = true
                self.txtChooseUser.text = selectedText
                self.txtChooseUser.selectText = selectedText
                self.txtChooseUser.selectedIndex = index
                self.valSelectedUserAndId = (selectedText,id)
            }
            self.setUserData(strText:selectedText,strId:"\(id)")
        }
    }
    
    @objc func detectTextfieldClick(_ sender: UITapGestureRecognizer) {
        if tblFilter.isHidden {
            tblFilter.isHidden = false
        } else {
            tblFilter.isHidden = true
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
            finaldate = startdate + " , " + enddate
        } else {
            finaldate = ""
        }
    }
    
    func countFilterBadge() {
        filterBadgeCount = 0
        if txtDate.text != "" {
            filterBadgeCount = filterBadgeCount + 1
        }
        if txtPaymentStatus.text != "" {
            filterBadgeCount = filterBadgeCount + 1
        }
        if arrSelectedCustIds.count > 0 {
            filterBadgeCount = filterBadgeCount + 1
        }
        if arrSelectedUserIds.count > 0 {
            filterBadgeCount = filterBadgeCount + 1
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
                self.didSelectUser()
            }
        }
    }
    
    func callGetUserForFilterAPIFromPending() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SUBSCRIBER_ADMINFILTER, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrChooseUserFromPending.removeAll()
                            for dict in response {
                                self.arrChooseUserFromPending.append(SubscriberAdminFilter(dict: dict))
                            }
                            DispatchQueue.main.async {
                                self.tblFilter.reloadData()
                            }
                        }
                    }
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
                self.didSelectCustomer()
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
            valSelectedDate = (finaldate,txtDate.selectedIndex ?? -1)
            delegate?.updateLoginLogList(dateDats:valSelectedDate, userDatas: valSelectedUserAndId, filterBadgeCount: filterBadgeCount)
        }
        if isFromCompletedOrder {
            delegateOfCompletedOrder?.updatedCompletedOrderList(date:finaldate,
                                                                selectedDateIndex :selectedDatefilterIndex,
                                                                userIds: arrSelectedUserIds,
                                                                customerIds: arrSelectedCustIds,
                                                                filterBadgeCount: filterBadgeCount,
                                                                paymentStatus:txtPaymentStatus.text,
                                                                selectedPaymentIndex:selectedPaymentStatusIndex)
         self.dismiss(animated: true, completion: nil)
    }
        if isFromPendingOrder {
            delegateOfPendingOrder?.updatedPendingOrderList(date: finaldate,
                                                            selectedDateIndex: selectedDatefilterIndex,
                                                            userIds: arrSelectedUserIds,
                                                            customerIds:  arrSelectedCustIds,
                                                            filterBadgeCount: filterBadgeCount)
           
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeCustomerCellClick(_ sender: UIButton) {
        arrCustomerCollection.remove(at: sender.tag)
        arrSelectedCustIds.remove(at: sender.tag)
        if arrSelectedCustIds.count == 0{
            chooseCustomerCollectionView.isHidden = true
        }
        chooseCustomerCollectionView.reloadData()
    }
    
    @objc func closeUserCellClick(_ sender: UIButton) {
        arrUserCollection.remove(at: sender.tag)
        arrSelectedUserIds.remove(at: sender.tag)
        if arrSelectedUserIds.count == 0{
            chooseUserCollectionView.isHidden = true
        }
        chooseUserCollectionView.reloadData()
    }
    
    @IBAction func btnResetClick(_ sender: UIButton) {
        txtDate.text = ""
        txtDate.selectedIndex = -1
        valSelectedDate = ("",-1)
        valSelectedUserAndId = ("",-1)
        txtChooseUser.text = ""
        finaldate = ""
        userID = 0
        getStartEndDate()
        countFilterBadge()
        UserDefaults.standard.removeObject(forKey: "loginlogdate")
        UserDefaults.standard.removeObject(forKey: "loginloguser")
       
        if isFromLoginLog {
            
            delegate?.updateLoginLogList(dateDats: (finaldate,txtDate.selectedIndex ?? -1), userDatas: valSelectedUserAndId, filterBadgeCount: filterBadgeCount)
        }
        if isFromCompletedOrder {
            delegateOfCompletedOrder?.updatedCompletedOrderList(date: txtDate.text,
                                                                selectedDateIndex: -1,
                                                                userIds: [],
                                                                customerIds: [],
                                                                filterBadgeCount: 0,
                                                                paymentStatus:"",
                                                                selectedPaymentIndex: -1)

        self.dismiss(animated: true, completion: nil)
    }
        if isFromCompletedOrder {
            delegateOfPendingOrder?.updatedPendingOrderList(date: txtDate.text,
                                                            selectedDateIndex: -1,
                                                            userIds: [],
                                                            customerIds: [],
                                                            filterBadgeCount: 0)

        self.dismiss(animated: true, completion: nil)
    }
        
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

//MARK:- Collection view Delegate Methods
extension LoginLogFilterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case chooseCustomerCollectionView:
                return arrCustomerCollection.count
            case chooseUserCollectionView:
            if  isFromPendingOrder {
                return arrUserCollection.count
            }
            if isFromCompletedOrder {
                return arrUserCollection.count
            }
              return 0
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.cellView.layer.cornerRadius = 8
        switch collectionView {
            case chooseCustomerCollectionView:
                cell.lblName.text = arrCustomerCollection[indexPath.item]
                cell.btnClose.tag = indexPath.item
                cell.btnClose.addTarget(self, action: #selector(closeCustomerCellClick(_:)), for: .touchUpInside)
            case chooseUserCollectionView:
            if isFromCompletedOrder {
                cell.lblName.text = arrUserCollection[indexPath.item]
                cell.btnClose.tag = indexPath.item
                cell.btnClose.addTarget(self, action: #selector(closeUserCellClick(_:)), for: .touchUpInside)
            }
            
            if isFromPendingOrder {
                cell.lblName.text = arrUserCollection[indexPath.item]
                cell.btnClose.tag = indexPath.item
                cell.btnClose.addTarget(self, action: #selector(closeUserCellClick(_:)), for: .touchUpInside)
            }
             default:
                cell.lblName.text = ""
        }
        cell.btnClose.tag = indexPath.item
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            case chooseCustomerCollectionView:
                return CGSize(width: arrCustomerCollection[indexPath.item].size(withAttributes: nil).width + 100, height: 38)
            case chooseUserCollectionView:
                return CGSize(width: arrUserCollection[indexPath.item].size(withAttributes: nil).width + 100, height: 38)
            default:
                return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            case chooseCustomerCollectionView:
                txtChooseCustomer.showList()
            case chooseUserCollectionView:
              
            if isFromPendingOrder {
                tblFilter.isHidden = false
                tblFilter.reloadData()
            }
            if isFromCompletedOrder {
                txtChooseUser.showList()
            }
            default:
                print("Default")
        }
    }
}

extension LoginLogFilterVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        switch gestureRecognizer {
            case tapCustomer:
                let point = touch.location(in: chooseCustomerCollectionView)
                if let indexPath = chooseCustomerCollectionView?.indexPathForItem(at: point),
                   let cell = chooseCustomerCollectionView?.cellForItem(at: indexPath) {
                    return touch.location(in: cell).y > 50
                }
                txtChooseCustomer.showList()
            case tapUser:
                let point = touch.location(in: chooseUserCollectionView)
                if let indexPath = chooseUserCollectionView?.indexPathForItem(at: point),
                   let cell = chooseUserCollectionView?.cellForItem(at: indexPath) {
                    return touch.location(in: cell).y > 50
                }
            if isFromPendingOrder {
                if tblFilter.isHidden {
                    tblFilter.isHidden = false
                } else {
                    tblFilter.isHidden = true
                }
            }
            if isFromCompletedOrder {
                txtChooseUser.showList()
            }
            if isFromLoginLog {
                txtChooseUser.showList()
            }
                
            default:
                print("Default")
        }
        return false
    }
}

extension LoginLogFilterVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrChooseUserFromPending.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrChooseUserFromPending[section].employee.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tblFilter.dequeueReusableHeaderFooterView(withIdentifier: "CustomFilterHeaderView") as! CustomFilterHeaderView
        headerView.lblTitle.text = arrChooseUserFromPending[section].user_name
        headerView.lblTitle.textColor = UIColor.init("#005CC8")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFilter.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as! SideMenuCell
        let model: NSDictionary = arrChooseUserFromPending[indexPath.section].employee[indexPath.row] as NSDictionary
        cell.titleLabel.text = model.value(forKey: "username") as? String ?? ""
        cell.adminFilterId = model.value(forKey: "id") as? Int ?? 0
        
        cell.iconImageLeadingConstraint.constant = 0
        cell.iconImageView.isHidden = true
        cell.expandImageView.isHidden = true
        cell.vw_lock.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tblFilter.cellForRow(at: indexPath) as! SideMenuCell
        let user = cell.titleLabel.text ?? ""
        let id = cell.adminFilterId
        
        if !arrUserCollection.contains(user) {
            arrUserCollection.append(user)
           // arrUserCollection.append("\(id)")
            arrSelectedUserIds.append((user,"\(id)"))
            chooseUserCollectionView.isHidden = false
            //userFilterColview.reloadData()
            chooseUserCollectionView.reloadData()
        }
        tblFilter.isHidden = true
//        if arrCollectionUsers.count != 0 {
//            userFilterColview.isHidden = false
//            userFilterColview.reloadData()
//        }
    }
    
}
