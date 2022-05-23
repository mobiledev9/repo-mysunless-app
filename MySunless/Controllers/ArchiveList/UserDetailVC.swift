//
//  UserDetailVC.swift
//  MySunless
//
//  Created by Daydream Soft on 11/03/22.
//

import UIKit
import iOSDropDown
import Alamofire
import Kingfisher

struct overView {
    var title : String = ""
    var color : UIColor = UIColor()
}

protocol ChangeAppointmentStatus {
    func callUpdateAppointmentStatusAPI(id: Int, status: String)
    func callDeleteAppointmentInfo(id: Int)
}

class UserDetailVC: UIViewController {
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var vw_selectDate: UIView!
    @IBOutlet var vw_selectCustomer: UIView!
    @IBOutlet var vw_selectEvent: UIView!
    @IBOutlet var txtSelectCustomer: DropDown!
    @IBOutlet var txtSelectEvent: DropDown!
    @IBOutlet var selectCustomerCollectionView: UICollectionView!
    @IBOutlet var selectEventCollectionView: UICollectionView!
    @IBOutlet weak var heightOverview: NSLayoutConstraint!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblAppointmentList: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var vw_filter: UIView!
    @IBOutlet var vw_overviewData: UIStackView!
    @IBOutlet var vw_main: UIView!
    @IBOutlet var vw_mainHeight: NSLayoutConstraint!
    @IBOutlet var btnOverview: UIButton!
    @IBOutlet var txtDate: DropDown!
    @IBOutlet var vw_popView: UIView!
    @IBOutlet var vw_popTopView: UIView!
    @IBOutlet var vw_popBottomView: UIView!
    @IBOutlet var vw_startDate: UIView!
    @IBOutlet var txtStartDate: UITextField!
    @IBOutlet var vw_endDate: UIView!
    @IBOutlet var txtEndDate: UITextField!
    @IBOutlet var vw_datePicker: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var lblClientCreated: UILabel!
    @IBOutlet var lblTotalAppointment: UILabel!
    @IBOutlet var lblCompleted: UILabel!
    @IBOutlet var lblConfirmed: UILabel!
    @IBOutlet var lblPending: UILabel!
    @IBOutlet var lblPaymentPending: UILabel!
    @IBOutlet var lblCanceled: UILabel!
    @IBOutlet var lblInProgress: UILabel!
    @IBOutlet var vw_salesOverview: UIView!
    @IBOutlet var heightSalesOverview: NSLayoutConstraint!
    @IBOutlet var tblSalesOverview: UITableView!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrUserAppointDetail = [ViewAppointmentUserInfo]()
    var arrFilterUserAppointDetail = [ViewAppointmentUserInfo]()
    var searchingAppoint = false
    var arr7Days = [String]()
    var startdate = String()
    var enddate = String()
    var finaldate = String()
    var isFromStartDate = false
    var isFromEndDate = false
    var arrCustomer = [ChooseCustomer]()
    var selectedCustomer = String()
    var arrCustomerCollection = [String]()
    var arrSelectedCustIds = [String]()
    var tapCustomer = UITapGestureRecognizer()
    var tapEvent = UITapGestureRecognizer()
    var selectedEventStatus = String()
    var arrEventStatusCollection = [String]()
    var userID = Int()
    
    var arrSalesInfo = [ViewSalesUserInfo]()
    var arrFilterSalesInfo = [ViewSalesUserInfo]()
    var searchingSales = false
    var arrSalesOverview = [SalesOverview]()
    var arrSelectedSalesIds = [String]()
   
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        userID = UserDefaults.standard.value(forKey: "userid") as? Int ?? 0
        tblAppointmentList.refreshControl = UIRefreshControl()
        tblAppointmentList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        tblSalesOverview.refreshControl = UIRefreshControl()
        tblSalesOverview.refreshControl?.addTarget(self, action: #selector(callPullToRefresh2), for: .valueChanged)
        dateDropdown()
        callAppOverviewAPI()
        callChooseCustomerAPI()
        callViewAppointUserDetail(filter: false)
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_selectDate.layer.borderWidth = 0.5
        vw_selectDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_selectCustomer.layer.borderWidth = 0.5
        vw_selectCustomer.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_selectEvent.layer.borderWidth = 0.5
        vw_selectEvent.layer.borderColor = UIColor.init("#15B0DA").cgColor
        tblAppointmentList.tableFooterView = UIView()
        btnOverview.layer.cornerRadius = 8
        vw_overviewData.layer.borderWidth = 0.5
        vw_overviewData.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_overviewData.layer.cornerRadius = 8
        vw_salesOverview.layer.borderWidth = 0.5
        vw_salesOverview.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_salesOverview.layer.cornerRadius = 8
        vw_filter.layer.borderWidth = 1.0
        vw_filter.layer.borderColor = UIColor.lightGray.cgColor
        vw_filter.layer.cornerRadius = 8
        vw_mainHeight.constant = 925
        vw_overviewData.isHidden = true
        heightOverview.constant = 0
        
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
        
      //  let tap = UITapGestureRecognizer(target: self, action: nil)
        tapCustomer.numberOfTapsRequired = 1
        tapCustomer.numberOfTouchesRequired = 1
        tapCustomer.delegate = self
        selectCustomerCollectionView?.addGestureRecognizer(tapCustomer)
        
     //   let tap1 = UITapGestureRecognizer(target: self, action: nil)
        tapEvent.numberOfTapsRequired = 1
        tapEvent.numberOfTouchesRequired = 1
        tapEvent.delegate = self
        selectEventCollectionView?.addGestureRecognizer(tapEvent)
        
        selectEventCollectionView.isHidden = true
        selectCustomerCollectionView.isHidden = true
        
        searchBar.delegate = self
        setSegmentController()
        register()
        vw_salesOverview.isHidden = true
        vw_overviewData.isHidden = false
        
        txtSelectEvent.optionArray = ["Completed","Pending","Confirmed","Canceled","Pending-Payment","In-progress"]
        didSelectEventStatus()
    }
    
    func setSegmentController () {
        let textAttributes = [NSAttributedString.Key.font : UIFont(name: "Roboto-Bold",size:17)!,
                              NSAttributedString.Key.foregroundColor:UIColor.init("#6D778E")
                             ]
        let selectedTextAttributes = [NSAttributedString.Key.font : UIFont(name:"Roboto-Bold",size:17)!,
                                      NSAttributedString.Key.foregroundColor:UIColor.white
                                     ]
        segmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    func register() {
        tblAppointmentList.register(UINib(nibName: "AppointmentCell", bundle: nil), forCellReuseIdentifier: "AppointmentCell")
        tblAppointmentList.register(UINib(nibName: "SalesInfoCell", bundle: nil), forCellReuseIdentifier: "SalesInfoCell")
        tblAppointmentList.reloadData()
        tblSalesOverview.register(UINib(nibName: "SalesOverviewCell", bundle: nil), forCellReuseIdentifier: "SalesOverviewCell")
        tblSalesOverview.tableFooterView = UIView()
        tblSalesOverview.reloadData()
    }
    
    func dateDropdown() {
        txtDate.optionArray = filterDays
        self.txtDate.didSelect{(selectedText, index, id) in
//            print("Selected String: \(selectedText) \n index: \(index), id: \(id)")
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
    
    func didSelectCustomer() {
        self.txtSelectCustomer.optionArray = self.arrCustomer.map{ $0.FirstName.capitalized + " " + $0.LastName.capitalized}
        self.txtSelectCustomer.optionIds = self.arrCustomer.map{ $0.id }
        self.txtSelectCustomer.didSelect{(selectedText, index, id) in
            self.txtSelectCustomer.selectedIndex = index
            self.selectCustomerCollectionView.isHidden = false
            self.selectedCustomer = selectedText
            if !self.arrCustomerCollection.contains(self.selectedCustomer) {
                self.arrCustomerCollection.append(self.selectedCustomer)
                self.arrSelectedCustIds.append("\(id)")
            }
            DispatchQueue.main.async {
                self.selectCustomerCollectionView.reloadData()
            }
        }
    }
    
    func didSelectEventStatus() {
        txtSelectEvent.didSelect{(selectedText, index, id) in
         //   print( "Selected String: \(selectedText) \n index: \(index),id: \(id)")
            self.txtSelectEvent.selectedIndex = index
            self.selectEventCollectionView.isHidden = false
            self.selectedEventStatus = selectedText
            if !self.arrEventStatusCollection.contains(self.selectedEventStatus) {
                self.arrEventStatusCollection.append(self.selectedEventStatus)
              //  self.arrSelectedCustIds.append("\(id)")
            }
            
            DispatchQueue.main.async {
                self.selectEventCollectionView.reloadData()
            }
        }
    }
    
    func callChooseCustomerAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["id": userID]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + GET_CUSTOMER_LIST, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrCustomer.removeAll()
                            for dict in response {
                                self.arrCustomer.append(ChooseCustomer(dict: dict))
                            }
                            self.didSelectCustomer()
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callViewAppointUserDetail(filter: Bool) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        if filter {
            params = ["date": finaldate,
                      "customer_id": arrSelectedCustIds.joined(separator: ","),
                      "eventstatus": arrEventStatusCollection.joined(separator: ",")
            ]
        } else {
            params = [:]
        }
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + VIEW_APPOINTMENT_USERINFO, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrUserAppointDetail.removeAll()
                            self.arrFilterUserAppointDetail.removeAll()
                            for dict in response {
                                self.arrUserAppointDetail.append(ViewAppointmentUserInfo(dict: dict))
                            }
                            self.arrFilterUserAppointDetail = self.arrUserAppointDetail
                            DispatchQueue.main.async {
                                self.tblAppointmentList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrFilterUserAppointDetail.removeAll()
                            self.arrUserAppointDetail.removeAll()
                            self.tblAppointmentList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callAppOverviewAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + APP_OVERVIEW, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let client = res.value(forKey: "TotalC") as? NSDictionary {
                    if let totalClient = client.value(forKey: "TotalClient") as? Int {
                        self.lblClientCreated.text = "\(totalClient)"
                    }
                }
                if let result = res.value(forKey: "Result") as? NSDictionary {
                    if let totalAppointment = result.value(forKey: "totalappointment") as? Int {
                        self.lblTotalAppointment.text = "\(totalAppointment)"
                    }
                    if let completed = result.value(forKey: "completed") as? Int {
                        self.lblCompleted.text = "\(completed)"
                    }
                    if let confirmed = result.value(forKey: "confirmed") as? Int {
                        self.lblConfirmed.text = "\(confirmed)"
                    }
                    if let pending = result.value(forKey: "pending") as? Int {
                        self.lblPending.text = "\(pending)"
                    }
                    if let paymentpending = result.value(forKey: "payment-pending") as? Int {
                        self.lblPaymentPending.text = "\(paymentpending)"
                    }
                    if let canceled = result.value(forKey: "canceled") as? Int {
                        self.lblCanceled.text = "\(canceled)"
                    }
                    if let inprogress = result.value(forKey: "in-progress") as? Int {
                        self.lblInProgress.text = "\(inprogress)"
                    }
                }
            }
        }
    }
    
    func callViewSalesUserInfo(filter: Bool) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        if filter {
            params = ["date": finaldate,
                      "customer_id": arrSelectedCustIds.joined(separator: ","),
                      "Payment": arrEventStatusCollection.joined(separator: ",")
            ]
        } else {
            params = [:]
        }
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + VIEW_SALES_USERINFO, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrSalesInfo.removeAll()
                            self.arrFilterSalesInfo.removeAll()
                            for dict in response {
                                self.arrSalesInfo.append(ViewSalesUserInfo(dictionary: dict)!)
                            }
                            self.arrFilterSalesInfo = self.arrSalesInfo
                            DispatchQueue.main.async {
                                self.tblAppointmentList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrFilterSalesInfo.removeAll()
                            self.arrSalesInfo.removeAll()
                            self.tblAppointmentList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callSalesOverviewAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SALES_OVERVIEW, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrSalesOverview.removeAll()
                            for dict in response {
                                self.arrSalesOverview.append(SalesOverview(dict: dict))
                            }
                            DispatchQueue.main.async {
                                self.tblSalesOverview.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrSalesOverview.removeAll()
                            self.tblSalesOverview.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func filterAppointContentForSearchText(_ searchText: String) {
        arrFilterUserAppointDetail = arrUserAppointDetail.filter({ (userdetail: ViewAppointmentUserInfo) -> Bool in
            let eid = "\(userdetail.id)"
            let Eid = eid.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let name = userdetail.FirstName + " " + userdetail.LastName
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let tittle = userdetail.title
            let Tittle = tittle.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let serviceDate = userdetail.EventDate
            let ServiceDate = serviceDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let serviceStatus = userdetail.eventstatus
            let ServiceStatus = serviceStatus.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let bookedDate = userdetail.datelastupdated
            let BookedDate = bookedDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Eid != nil || Name != nil || Tittle != nil || ServiceDate != nil || ServiceStatus != nil || BookedDate != nil
        })
    }
    
    func filterSalesContentForSearchText(_ searchText: String) {
        arrFilterSalesInfo = arrSalesInfo.filter({ (salesinfo: ViewSalesUserInfo) -> Bool in
            let name = salesinfo.client_Fullname
            let Name = name?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let invoice = salesinfo.invoiceNumber
            let Invoice = invoice?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let type = salesinfo.paymentType
            let Type = type?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            var orderdate = salesinfo.orderdate
            orderdate?.removeLast(9)
            let OrderDate = orderdate?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let amount = "$" + (salesinfo.paymentAmount ?? "")
            let Amount = amount.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || Invoice != nil || Type != nil || OrderDate != nil || Amount != nil
        })
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callViewAppointUserDetail(filter: false)
            self.tblAppointmentList.refreshControl?.endRefreshing()
            self.tblAppointmentList.reloadData()
        }
    }
    
    @objc func callPullToRefresh2(){
        DispatchQueue.main.async {
            self.callViewSalesUserInfo(filter: false)
            self.tblSalesOverview.refreshControl?.endRefreshing()
            self.tblSalesOverview.reloadData()
        }
    }
    
    //MARK:- Button Action
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                callViewAppointUserDetail(filter: false)
                txtSelectEvent.placeholder = "Choose Event Status"
                txtSelectEvent.optionArray = ["Completed","Pending","Confirmed","Canceled","Pending-Payment","In-progress"]
                txtDate.text = ""
                txtSelectCustomer.text = ""
                txtSelectEvent.text = ""
                selectCustomerCollectionView.isHidden = true
                selectEventCollectionView.isHidden = true
                vw_salesOverview.isHidden = true
                vw_overviewData.isHidden = false
            case 1:
                callViewSalesUserInfo(filter: false)
                callSalesOverviewAPI()
                txtSelectEvent.placeholder = "Payment Type"
                txtSelectEvent.optionArray = ["Card","Cash","Split-Cash","Split-Card","Cheque"]
                txtDate.text = ""
                txtSelectCustomer.text = ""
                txtSelectEvent.text = ""
                selectCustomerCollectionView.isHidden = true
                selectEventCollectionView.isHidden = true
                vw_salesOverview.isHidden = false
                vw_overviewData.isHidden = true
                tblSalesOverview.reloadData()
            default:
                print("Default")
        }
        tblAppointmentList.reloadData()
    }
    
    @IBAction func btnOverViewClick(_ sender: UIButton) {
//        switch segmentedControl.selectedSegmentIndex {
//            case 0:
                if sender.isSelected {
                    vw_overviewData.isHidden = true
                    heightOverview.constant = 0
                    vw_mainHeight.constant = 925
                    sender.isSelected.toggle()
                } else {
                    vw_overviewData.isHidden = false
                    heightOverview.constant = 485
                    vw_mainHeight.constant = 1410
                    sender.isSelected.toggle()
                }
//            case 1:
//                if sender.isSelected {
//                    vw_salesOverview.isHidden = true
//                    heightSalesOverview.constant = 0
//                    vw_mainHeight.constant = 925
//                    sender.isSelected.toggle()
//                } else {
//                    vw_salesOverview.isHidden = false
//                    heightSalesOverview.constant = 485
//                    vw_mainHeight.constant = 1410
//                    sender.isSelected.toggle()
//                }
                tblSalesOverview.reloadData()
//            default:
//                print("Default")
//        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDateClick(_ sender: UIButton) {
        txtDate.showList()
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        getStartEndDate()
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                callViewAppointUserDetail(filter: true)
            case 1:
                callViewSalesUserInfo(filter: true)
            default:
                print("Default")
        }
    }
    
    @IBAction func btnResetClick(_ sender: UIButton) {
        txtDate.text = ""
        txtSelectCustomer.text = ""
        selectCustomerCollectionView.isHidden = true
        selectEventCollectionView.isHidden = true
        arrEventStatusCollection.removeAll()
        arrCustomerCollection.removeAll()
        arrSelectedCustIds.removeAll()
        txtSelectEvent.text = ""
        finaldate = ""
        getStartEndDate()
        callViewAppointUserDetail(filter: false)
        callViewSalesUserInfo(filter: false)
    }
    
    @IBAction func btnCloseDatePopView(_ sender: UIButton) {
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
    
    @IBAction func btnSubmitCustomDateRange(_ sender: UIButton) {
        if dateValidation() {
            txtDate.text = (txtStartDate.text ?? "") + " - " + (txtEndDate.text ?? "")
            vw_popView.isHidden = true
        }
    }
    
    @IBAction func btnCloseCustomerCellClick(_ sender: UIButton) {
        arrCustomerCollection.remove(at: sender.tag)
        arrSelectedCustIds.remove(at: sender.tag)
        selectCustomerCollectionView.reloadData()
        if arrCustomerCollection.isEmpty {
            txtSelectCustomer.text = ""
            selectCustomerCollectionView.isHidden = true
        }
    }
    
    @IBAction func btnCloseEventCellClick(_ sender: UIButton) {
//        arrSelectedIds.remove(at: sender.tag)
        arrEventStatusCollection.remove(at: sender.tag)
        selectEventCollectionView.reloadData()
        if arrEventStatusCollection.isEmpty {
            txtSelectEvent.text = ""
            selectEventCollectionView.isHidden = true
        }
        
    }
}

//MARK:- UITextfield Delegate Methods
extension UserDetailVC: UITextFieldDelegate {
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

extension UserDetailVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        switch gestureRecognizer {
            case tapCustomer:
                let point = touch.location(in: selectCustomerCollectionView)
                if let indexPath = selectCustomerCollectionView?.indexPathForItem(at: point),
                   let cell = selectCustomerCollectionView?.cellForItem(at: indexPath) {
                    return touch.location(in: cell).y > 50
                }
                txtSelectCustomer.showList()
            case tapEvent:
                let point = touch.location(in: selectEventCollectionView)
                if let indexPath = selectEventCollectionView?.indexPathForItem(at: point),
                   let cell = selectEventCollectionView?.cellForItem(at: indexPath) {
                    return touch.location(in: cell).y > 50
                }
                txtSelectEvent.showList()
            default:
                print("Default")
        }
        return false
    }
}

//MARK:- UITableView Datasource Methods
extension UserDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                if searchingAppoint {
                    return arrFilterUserAppointDetail.count
                } else {
                    return arrUserAppointDetail.count
                }
            case 1:
                switch tableView {
                    case tblAppointmentList:
                        if searchingSales {
                            return arrFilterSalesInfo.count
                        } else {
                            return arrSalesInfo.count
                        }
                    case tblSalesOverview:
                            return arrSalesOverview.count
                    default:
                        return 0
                }
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                let cell = tblAppointmentList.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
                if searchingAppoint {
                    cell.modelUserDetail = arrFilterUserAppointDetail[indexPath.row]
                } else {
                    cell.modelUserDetail = arrUserAppointDetail[indexPath.row]
                }
                cell.setCell(index: indexPath.row)
                cell.delegate = self
                return cell
            case 1:
                switch tableView {
                    case tblAppointmentList:
                        let cell = tblAppointmentList.dequeueReusableCell(withIdentifier: "SalesInfoCell", for: indexPath) as! SalesInfoCell
                        if searchingSales {
                            cell.modelSales = arrFilterSalesInfo[indexPath.row]
                        } else {
                            cell.modelSales = arrSalesInfo[indexPath.row]
                        }
                        cell.setCell(index: indexPath.row)
                        //  cell.delegate = self
                        return cell
                    case tblSalesOverview:
                        let cell = tblSalesOverview.dequeueReusableCell(withIdentifier: "SalesOverviewCell", for: indexPath) as! SalesOverviewCell
                        cell.modelSalesOverview = arrSalesOverview[indexPath.row]
                        cell.setCell(index: indexPath.row)
                        //  cell.delegate = self
                        return cell
                    default:
                        return UITableViewCell()
                }
            default:
                return UITableViewCell()
        }
    }
}

//MARK:- UITableView Delegate Methods
extension UserDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
            case tblAppointmentList:
                return UITableView.automaticDimension
            case tblSalesOverview:
                return 90
            default:
                return UITableView.automaticDimension
        }
    }
}

//MARK:- SearchBar Delegate Methods
extension UserDetailVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                if let searchText = searchBar.text {
                    filterAppointContentForSearchText(searchText)
                    searchingAppoint = true
                    if searchText == "" {
                        arrFilterUserAppointDetail = arrUserAppointDetail
                    }
                }
            case 1:
                if let searchText = searchBar.text {
                    filterSalesContentForSearchText(searchText)
                    searchingSales = true
                    if searchText == "" {
                        arrFilterSalesInfo = arrSalesInfo
                    }
                }
            default:
                print("Default")
        }
        tblAppointmentList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                searchingAppoint = false
            case 1:
                searchingSales = false
            default:
                print("Default")
        }
        searchBar.text = ""
        tblAppointmentList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

//MARK:- Collection view Delegate Methods
extension UserDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case selectCustomerCollectionView:
                return arrCustomerCollection.count
            case selectEventCollectionView:
                return arrEventStatusCollection.count
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.cellView.layer.cornerRadius = 8
        switch collectionView {
            case selectCustomerCollectionView:
                cell.lblName.text = arrCustomerCollection[indexPath.item]
            case selectEventCollectionView:
                cell.lblName.text = arrEventStatusCollection[indexPath.item]
            default:
                cell.lblName.text = ""
        }
        cell.btnClose.tag = indexPath.item
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            case selectCustomerCollectionView:
                return CGSize(width: arrCustomerCollection[indexPath.item].size(withAttributes: nil).width + 100, height: 38)
            case selectEventCollectionView:
                return CGSize(width: arrEventStatusCollection[indexPath.item].size(withAttributes: nil).width + 100, height: 38)
            default:
                return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            case selectCustomerCollectionView:
                txtSelectCustomer.showList()
            case selectEventCollectionView:
                txtSelectEvent.showList()
            default:
                print("Default")
        }
    }
}

extension UserDetailVC: ChangeAppointmentStatus {
    func callUpdateAppointmentStatusAPI(id: Int, status: String) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id,
                  "status": status
        ]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CHANGE_APPOINTMENT_STATUS, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.callViewAppointUserDetail(filter: false)
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
    
    func callDeleteAppointmentInfo(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["delappoid": id]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_APPOINTMENT_INFO, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            self.callViewAppointUserDetail(filter: false)
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
}


