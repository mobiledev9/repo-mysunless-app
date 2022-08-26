//
//  EventFilterVC.swift
//  MySunless
//
//  Created by iMac on 04/02/22.
//

import UIKit
import iOSDropDown
import Alamofire


//MARK:- Main Class
class EventFilterVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_eventDate: UIView!
    @IBOutlet var eventDateDropdown: DropDown!
    @IBOutlet var vw_chooseUser: UIView!
    @IBOutlet var chooseUserDropdown: DropDown!
    @IBOutlet var vw_chooseCustomer: UIView!
    @IBOutlet var chooseCustomerDropdown: DropDown!
    @IBOutlet var vw_filterStatus: UIView!
    @IBOutlet var filterStatusDropdown: DropDown!
    @IBOutlet var chooseUserCollectionView: UICollectionView!
    @IBOutlet var chooseCustomerCollectionView: UICollectionView!
    @IBOutlet var chooseStatusCollectionView: UICollectionView!
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
    var delegateFilterEventsProtocol : FilterEventsProtocol?
    var arr7Days = [String]()
    var valSelctedEventDates : (String,Int) = ("",-1)
    var arrSelctedCustomers = [(String,String)]()
    var arrSelctedUsers = [(String,String)]()
    var arrSelctedStatus = [(String,String)]()
    var isFromFilterList : Bool = false
    var finaldate = String()
    var startdate = String()
    var enddate = String()
    var userID = Int()
    var filterBadgeCount = Int()
    var tapCustomer = UITapGestureRecognizer()
    var tapUser = UITapGestureRecognizer()
    var tapEventStatus = UITapGestureRecognizer()
    var isFromStartDate = false
    var isFromEndDate = false
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        dateDropdown(selectedIndex: valSelctedEventDates.1)
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        setEventStatusfilter()
        callFilterListUserAPI()
        callFilterListCustomerAPI()
    }
    
    func dateDropdown(selectedIndex : Int) {
        eventDateDropdown.optionArray = filterDays
        self.eventDateDropdown.didSelect{(selectedText, index, id) in
            self.eventDateDropdown.isFromLoginLogFilterVC = true
            self.eventDateDropdown.selectText = selectedText
            self.setFilterDate(index: index)

        }
//        if selectedIndex != -1 {
//            self.setFilterDate(index: selectedIndex)
//            valSelctedEventDates = (eventDateDropdown.selectText,selectedIndex)
//        }
    }
    
    func setFilterDate(index: Int) {
        switch index {
            case 0:
                self.eventDateDropdown.selectText = Date.getCurrentDate() + " - " + Date.getCurrentDate()
            case 1:
                self.eventDateDropdown.selectText = AppData.sharedInstance.convertDateToString(date: Date.yesterday) + " - " + AppData.sharedInstance.convertDateToString(date: Date.yesterday)
            case 2:
                self.arr7Days = Date.getDates(forLastNDays: 7)
                self.eventDateDropdown.selectText = self.arr7Days[5] + " - " + Date.getCurrentDate()
            case 3:
                self.arr7Days = Date.getDates(forLastNDays: 30)
                self.eventDateDropdown.selectText = self.arr7Days[28] + " - " + Date.getCurrentDate()
            case 4:
                self.eventDateDropdown.selectText = AppData.sharedInstance.convertDateToString(date: Date().startDateOfMonth) + " - " + Date.getCurrentDate()
            case 5:
                self.eventDateDropdown.selectText = AppData.sharedInstance.convertDateToString(date: Date().startDateOfPreviousMonth) + " - " + AppData.sharedInstance.convertDateToString(date: Date().endOfPreviousMonth)
            case 6:
                self.eventDateDropdown.selectText = AppData.sharedInstance.convertDateToString(date: Date().getPreviousYearDate) + " - " + Date.getCurrentDate()
            case 7:
                self.eventDateDropdown.hideList()
                self.vw_popView.isHidden = false
            default:
                print("Default")
        }
    }
    
    func setEventStatusfilter () {
        filterStatusDropdown.optionArray = arrEventStatus
        filterStatusDropdown.optionIds = arrEventStatus.enumerated().map{$0.offset}
        filterStatusDropdown.didSelect{(selectedText , index ,id) in
            print( "Selected String: \(selectedText) \n index: \(index),id: \(id)")
            self.filterStatusDropdown.selectedIndex = index
            self.chooseStatusCollectionView.isHidden = false
            self.setStatusData(strText: selectedText, strId: "\(id)")
          }
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_mainView.layer.borderWidth = 1.0
        vw_mainView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        vw_bottom.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
        vw_eventDate.layer.borderWidth = 0.5
        vw_eventDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_chooseUser.layer.borderWidth = 0.5
        vw_chooseUser.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_chooseCustomer.layer.borderWidth = 0.5
        vw_chooseCustomer.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_filterStatus.layer.borderWidth = 0.5
        vw_filterStatus.layer.borderColor = UIColor.init("#15B0DA").cgColor
        
        vw_popView.isHidden = true
        txtStartDate.delegate = self
        txtEndDate.delegate = self
        
        if isFromFilterList {
           
           tapCustomer.numberOfTapsRequired = 1
           tapCustomer.numberOfTouchesRequired = 1
           tapCustomer.delegate = self
           chooseCustomerCollectionView?.addGestureRecognizer(tapCustomer)
           
           tapUser.numberOfTapsRequired = 1
           tapUser.numberOfTouchesRequired = 1
           tapUser.delegate = self
           chooseUserCollectionView?.addGestureRecognizer(tapUser)
            
            
            tapEventStatus.numberOfTapsRequired = 1
            tapEventStatus.numberOfTouchesRequired = 1
            tapEventStatus.delegate = self
            chooseStatusCollectionView?.addGestureRecognizer(tapEventStatus)
            
            if valSelctedEventDates != ("",-1) {
               
                eventDateDropdown.selectedIndex = valSelctedEventDates.1
                eventDateDropdown.selectText = ""
                if valSelctedEventDates.1 != 7 {
                   setFilterDate(index: valSelctedEventDates.1)
                    eventDateDropdown.text =  eventDateDropdown.selectText
                } else {
                    eventDateDropdown.text = valSelctedEventDates.0
                }
            } else {
                eventDateDropdown.text = ""
                eventDateDropdown.selectText = ""
                eventDateDropdown.selectedIndex = -1
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
            
            if arrSelctedStatus.count > 0 {
                chooseStatusCollectionView.isHidden = false
            } else {
                chooseStatusCollectionView.isHidden = true
            }
            
           
       }
    }
    
    func getStartEndDate() {
        if eventDateDropdown.selectText == "" {
            
        } else {
            startdate = eventDateDropdown.selectText
            enddate = eventDateDropdown.selectText
            
            if startdate != "" && enddate != "" {
                startdate.removeLast(14)
                enddate.removeFirst(14)
            }
            startdate = AppData.sharedInstance.formattedDateFromString(dateString: startdate, withFormat: "dd-MM-yyyy") ?? ""
            enddate = AppData.sharedInstance.formattedDateFromString(dateString: enddate, withFormat: "dd-MM-yyyy") ?? ""
            
            if startdate != "" && enddate != "" {
                finaldate = startdate + " , " + enddate
                valSelctedEventDates = (finaldate,eventDateDropdown.selectedIndex ?? -1)
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
        if eventDateDropdown.text != "" {
            filterBadgeCount = filterBadgeCount + 1
        }
        if arrSelctedCustomers.count > 0 {
            filterBadgeCount = filterBadgeCount + 1
        }
        if arrSelctedUsers.count > 0 {
            filterBadgeCount = filterBadgeCount + 1
        }
        if arrSelctedStatus.count > 0 {
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
    func setStatusData(strText :String,strId :String) {
        if !self.arrSelctedStatus.map({$0.1}).contains(strId) {
            self.arrSelctedStatus.append((strText,strId))
        }
        DispatchQueue.main.async {
            self.chooseStatusCollectionView.reloadData()
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
    @objc func closeStatusCellClick(_ sender: UIButton) {
        arrSelctedStatus.remove(at: sender.tag)
        if arrSelctedStatus.count == 0{
            chooseStatusCollectionView.isHidden = true
        }
        chooseStatusCollectionView.reloadData()
    }
    
    //MARK:- Actions
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.countFilterBadge()
            self.getStartEndDate()
            
            if self.isFromFilterList {
                self.delegateFilterEventsProtocol?.updatedEventList(eventDatas:self.valSelctedEventDates,userDatas: self.arrSelctedUsers,CustomerDatas: self.arrSelctedCustomers,eventStatusDatas: self.arrSelctedStatus, filterBadgeCount: self.filterBadgeCount)
          }
    }
    }
    @IBAction func btnResetClick(_ sender: UIButton) {
        eventDateDropdown.text = ""
        valSelctedEventDates = ("",-1)
        chooseUserDropdown.text = ""
        chooseCustomerDropdown.text = ""
        filterStatusDropdown.text = ""
        valSelctedEventDates = ("",-1)
        arrSelctedUsers.removeAll()
        arrSelctedCustomers.removeAll()
        arrSelctedStatus.removeAll()
        countFilterBadge()
        self.dismiss(animated: true) {
            if self.isFromFilterList {
                self.delegateFilterEventsProtocol?.updatedEventList(eventDatas:self.valSelctedEventDates,userDatas: self.arrSelctedUsers,CustomerDatas: self.arrSelctedCustomers,eventStatusDatas: self.arrSelctedStatus, filterBadgeCount: self.filterBadgeCount)
          }
            UserDefaults.standard.removeObject(forKey: "loginlogdate")
            UserDefaults.standard.removeObject(forKey: "loginloguser")
        }
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
            eventDateDropdown.text = (txtStartDate.text ?? "") + " - " + (txtEndDate.text ?? "")
            eventDateDropdown.selectText = (txtStartDate.text ?? "") + " - " + (txtEndDate.text ?? "")
            vw_popView.isHidden = true
        }
    }
    
    
}

//MARK:- Collection view Delegate Methods
extension EventFilterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case chooseUserCollectionView:
            return arrSelctedUsers.count
            case chooseCustomerCollectionView:
            return arrSelctedCustomers.count
        case chooseStatusCollectionView:
           return arrSelctedStatus.count
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
            
        case chooseStatusCollectionView:
            
        cell.lblName.text = arrSelctedStatus[indexPath.item].0
            cell.btnClose.tag = indexPath.item
            cell.btnClose.addTarget(self, action: #selector(closeStatusCellClick(_:)), for: .touchUpInside)
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
        case chooseStatusCollectionView:
            return CGSize(width: arrSelctedStatus[indexPath.item].0.size(withAttributes: nil).width + 100, height: 38)
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
            case chooseStatusCollectionView:
            filterStatusDropdown.showList()
            default:
                print("Default")
        }
    }
}

extension EventFilterVC: UIGestureRecognizerDelegate {
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
            
            case tapEventStatus:
            let point = touch.location(in: chooseStatusCollectionView)
            if let indexPath = chooseStatusCollectionView?.indexPathForItem(at: point),
               let cell = chooseStatusCollectionView?.cellForItem(at: indexPath) {
                return touch.location(in: cell).y > 50
            }
            filterStatusDropdown.showList()
                
            default:
                print("Default")
        }
        return false
    }
}

extension EventFilterVC: UITextFieldDelegate {
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
