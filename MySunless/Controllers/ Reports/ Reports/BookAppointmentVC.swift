//
//  BookAppointmentVC.swift
//  MySunless
//
//  Created by iMac on 25/01/22.
//

import UIKit
import Alamofire
import Kingfisher
import iOSDropDown
//import CoreLocation

class BookAppointmentVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var vw_mainHeight: NSLayoutConstraint!
    @IBOutlet var vw_chooseService: UIView!
    @IBOutlet var txtChooseService: UITextField!
    @IBOutlet var imgServiceDropdown: UIImageView!
    @IBOutlet var vw_serviceDropdown: UIView!
    @IBOutlet var vw_serviceDropdownHeight: NSLayoutConstraint!
    @IBOutlet var vw_serviceSearchbar: UIView!
    @IBOutlet var searchBarService: UISearchBar!
    @IBOutlet var tblService: UITableView!
    @IBOutlet var lblServiceProvider: UILabel!
    @IBOutlet var vw_serviceprovider: UIView!
    @IBOutlet var txtServiceProvider: UITextField!
    @IBOutlet var btnServiceProvider: UIButton!
    @IBOutlet var imgServiceProviderDropdown: UIImageView!
    @IBOutlet var vw_serviceProviderDropdown: UIView!
    @IBOutlet var vw_serviceProviderDropdownHeight: NSLayoutConstraint!
    @IBOutlet var vw_serviceProviderSearchbar: UIView!
    @IBOutlet var searchBarServiceProvider: UISearchBar!
    @IBOutlet var tblServiceProvider: UITableView!
    @IBOutlet var lblAppointmentDateTime: UILabel!
    @IBOutlet var vw_startDate: UIView!
    @IBOutlet var txtStartDate: UITextField!
    @IBOutlet var vw_selectTime: UIView!
    @IBOutlet var txtSelectTime: UITextField!
    @IBOutlet var vw_availableTime: UIView!
    @IBOutlet var vw_availableTimeHeight: NSLayoutConstraint!
    @IBOutlet var segmentRepeat: UISegmentedControl!
    @IBOutlet var vw_repeatSegViews: UIView!
    @IBOutlet var vw_repeatSegHeight: NSLayoutConstraint!
    @IBOutlet var lblEvery: UILabel!
    @IBOutlet var lblEveryHeight: NSLayoutConstraint!
    @IBOutlet var vw_every: UIView!
    @IBOutlet var txtEvery: DropDown!
    @IBOutlet var vw_everyHeight: NSLayoutConstraint!
    @IBOutlet var lblMonth: UILabel!
    @IBOutlet var lblMonthHeight: NSLayoutConstraint!
    @IBOutlet var lblMonthTop: NSLayoutConstraint!
    @IBOutlet var vw_month: UIView!
    @IBOutlet var txtMonth: DropDown!
    @IBOutlet var vw_monthHeight: NSLayoutConstraint!
    @IBOutlet var lblDay: UILabel!
    @IBOutlet var lblDayHeight: NSLayoutConstraint!
    @IBOutlet var lblDayTop: NSLayoutConstraint!
    @IBOutlet var vw_day: UIView!
    @IBOutlet var txtDay: DropDown!
    @IBOutlet var vw_dayHeight: NSLayoutConstraint!
    @IBOutlet var lblEndDate: UILabel!
    @IBOutlet var lblEndDateHeight: NSLayoutConstraint!
    @IBOutlet var lblEndDateTop: NSLayoutConstraint!
    @IBOutlet var vw_endDate: UIView!
    @IBOutlet var txtEndDate: UITextField!
    @IBOutlet var vw_endDateHeight: NSLayoutConstraint!
    @IBOutlet var lblDays: UILabel!
    @IBOutlet var lblDaysHeight: NSLayoutConstraint!
    @IBOutlet var vw_Days: UIView!
    @IBOutlet var vw_DaysHeight: NSLayoutConstraint!
    @IBOutlet var btnRadioSalonLocation: UIButton!
    @IBOutlet var btnRadioCustomerLocation: UIButton!
    @IBOutlet var vw_mainCostOfService: UIView!
    @IBOutlet var vw_leadingCostOfService: UIView!
    @IBOutlet var vw_trailingCostOfService: UIView!
    @IBOutlet var txtCostOfService: UITextField!
    @IBOutlet var vw_mainDuration: UIView!
//    @IBOutlet var vw_leadingDuration: UIView!
    @IBOutlet var txtDuration: UITextField!
//    @IBOutlet var vw_trailingDuration: UIView!
    @IBOutlet var vw_publicAppointmentNote: UIView!
    @IBOutlet var txtVwPublicAppointmentNote: UITextView!
    @IBOutlet var vw_customer: UIView!
    @IBOutlet var txtChooseCustomer: UITextField!
    @IBOutlet var imgCustomerDropdown: UIImageView!
    @IBOutlet var btnCloseCustomerDropdown: UIButton!
    @IBOutlet var vw_customerDetails: UIView!
    @IBOutlet var vw_customerDetailsHeight: NSLayoutConstraint!
    @IBOutlet var imgCustomerProfile: UIImageView!
    @IBOutlet var lblCustomerDetailName: UILabel!
    @IBOutlet var lblCustomerDetailEmail: UILabel!
    @IBOutlet var lblCustomerDetailPhone: UILabel!
    @IBOutlet var btnAddNote: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnEditHeight: NSLayoutConstraint!
    @IBOutlet var lblPrivateClientNotes: UILabel!
    @IBOutlet var lblPrivateClientNotesHeight: NSLayoutConstraint!
    @IBOutlet var vw_privateClientNotes: UIView!
    @IBOutlet var vw_privateClientNotesHeight: NSLayoutConstraint!
    @IBOutlet var tblPrivateClientNotes: UITableView!
    @IBOutlet var vw_customerListDropdown: UIView!
    @IBOutlet var vw_customerListDropdownHeight: NSLayoutConstraint!
    @IBOutlet var vw_searchCustomerlistName: UIView!
    @IBOutlet var searchBarCustomerListName: UISearchBar!
    @IBOutlet var tblCustomerListName: UITableView!
    @IBOutlet var colviewAvailableTime: UICollectionView!
    @IBOutlet var btnSunday: UIButton!
    @IBOutlet var btnMonday: UIButton!
    @IBOutlet var btnTuesday: UIButton!
    @IBOutlet var btnWednesday: UIButton!
    @IBOutlet var btnThursday: UIButton!
    @IBOutlet var btnFriday: UIButton!
    @IBOutlet var btnSaturday: UIButton!
    
    //MARK:- Variable Declarations
    var token = String()
    var serviceDropdownOpen = true
    var searchingService = false
    var arrService = [SelectServiceAppointment]()
    var arrServiceName = [String]()
    var searchedService = [String]()
  //  var datePicker = UIDatePicker()
    var customerListDropdownOpen = true
    var arrCustomer = [ChooseCustomer]()
    var searchedCustomer = [ChooseCustomer]()
    var searchingCustomer = false
    var selectedCustomerId = Int()
    var arrClientData = [ClientData]()
    var arrNotesData = [NotesData]()
    var serviceId = Int()
    var arrServiceProvider = [ProviderData]()
    var serviceProviderDropdownOpen = true
    var searchingServiceProvider = false
    var searchedServiceProvider = [ProviderData]()
    var selectedServiceProviderID = Int()
    var arrAvailableTime = [String]()
    let textFieldRecognizer = UITapGestureRecognizer()
    var getCustomerDetails = false
    var salonAddress = String()
    var availableTimeOpen = false
    var showClientNotesOpen = false
    var selectedStartTime = String()
    var selectedEndTime = String()
    var arrEvery = [Int]()
    var arrDay = [Int]()
    var arrMonth = [String]()
    var sun = String()
    var mon = String()
    var tue = String()
    var wed = String()
    var thu = String()
    var fri = String()
    var sat = String()
    var selectedMonth = Int()
    var arrDates = [String]()
    var clientFirstName = String()
    var clientLastName = String()
    var zip = String()
    var address = String()
    var city = String()
    var state = String()
    var country = String()
    var location = "Customer Location"
    var isFromViewWillAppear = false
    var isEditEventList = false
    var editEventList = EventList(dict: [:])
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        setDropdown()
        self.hideKeyboardWhenTappedAround()
        tblService.tableFooterView = UIView()
        tblPrivateClientNotes.tableFooterView = UIView()
        tblServiceProvider.tableFooterView = UIView()
        
        vw_mainHeight.constant = 1450
        vw_availableTime.isHidden = true
        vw_availableTimeHeight.constant = 0
        
        vw_serviceDropdown.isHidden = true
        vw_serviceProviderDropdown.isHidden = true
        searchBarService.delegate = self
        searchBarCustomerListName.delegate = self
        searchBarServiceProvider.delegate = self
        
        vw_repeatSegViews.isHidden = true
        vw_repeatSegHeight.constant = 0
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        salonAddress = UserDefaults.standard.value(forKey: "companyAddress") as? String ?? ""
        
//        callSelectServiceAppointAPI()
//        callChooseCustomerAPI()
        
        textFieldRecognizer.addTarget(self, action: #selector(tappedTextField(_:)))
        txtSelectTime.addGestureRecognizer(textFieldRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // callSelectServiceAppointAPI()
        callChooseCustomerAPI()
        
        getCustomerDetails = false
        setInitially()
        
        if isEditEventList {
            callSelectServiceAppointAPI(id: editEventList.ServiceName)
            serviceId = editEventList.ServiceName
            callServiceProviderAPI()
            txtCostOfService.text = editEventList.CostOfService
            var date = editEventList.EventDate
            date.removeLast(8)
            txtStartDate.text = date
            var time = editEventList.EventDate
            time.removeFirst(11)
            txtSelectTime.text = time
            if editEventList.Location_radio == "Customer Location" {
                btnRadioCustomerLocation.setImage(UIImage(named: "radio-on-button"), for: .normal)
                btnRadioSalonLocation.setImage(UIImage(named: "radio-off-button"), for: .normal)
                location = "Customer Location"
            } else if editEventList.Location_radio == "Salon Location" {
                btnRadioSalonLocation.setImage(UIImage(named: "radio-on-button"), for: .normal)
                btnRadioCustomerLocation.setImage(UIImage(named: "radio-off-button"), for: .normal)
                location = "Salon Location"
            }
            txtChooseCustomer.text = editEventList.client_firstname + " " + editEventList.client_Lastname
            
            vw_customerDetails.isHidden = false
            vw_customerDetailsHeight.constant = 90
            btnAddNote.isHidden = false
            btnAddNote.isUserInteractionEnabled = true
            btnEdit.isHidden = false
            
            let imgUrl = URL(string: editEventList.ProfileImg)
            imgCustomerProfile.kf.setImage(with: imgUrl)
            lblCustomerDetailName.text = editEventList.client_firstname + " " + editEventList.client_Lastname
            lblCustomerDetailEmail.text = editEventList.client_email
            lblCustomerDetailPhone.text = editEventList.client_phone
            
            selectedCustomerId = editEventList.clientid
            callShowClientNoteAPI(isFromView: false)
            
        } else {
            callSelectServiceAppointAPI()
            callShowClientNoteAPI(isFromView: true)
        }
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_chooseService.layer.borderWidth = 0.5
        vw_chooseService.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_serviceprovider.layer.borderWidth = 0.5
        vw_serviceprovider.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_startDate.layer.borderWidth = 0.5
        vw_startDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_selectTime.layer.borderWidth = 0.5
        vw_selectTime.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_mainCostOfService.layer.borderWidth = 0.5
        vw_mainCostOfService.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_mainDuration.layer.borderWidth = 0.5
        vw_mainDuration.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_publicAppointmentNote.layer.borderWidth = 0.5
        vw_publicAppointmentNote.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_customer.layer.borderWidth = 0.5
        vw_customer.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_endDate.layer.borderWidth = 0.5
        vw_endDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_every.layer.borderWidth = 0.5
        vw_every.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_day.layer.borderWidth = 0.5
        vw_day.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_month.layer.borderWidth = 0.5
        vw_month.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_Days.layer.borderWidth = 0.5
        vw_Days.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_serviceDropdown.layer.borderWidth = 0.5
        vw_serviceDropdown.layer.borderColor = UIColor.gray.cgColor
        vw_serviceProviderDropdown.layer.borderWidth = 0.5
        vw_serviceProviderDropdown.layer.borderColor = UIColor.gray.cgColor
        vw_serviceSearchbar.layer.borderWidth = 0.5
        vw_serviceSearchbar.layer.borderColor = UIColor.gray.cgColor
        vw_serviceSearchbar.layer.cornerRadius = 8
        vw_serviceProviderSearchbar.layer.borderWidth = 0.5
        vw_serviceProviderSearchbar.layer.borderColor = UIColor.gray.cgColor
        vw_serviceProviderSearchbar.layer.cornerRadius = 8
        vw_customerListDropdown.layer.borderWidth = 0.5
        vw_customerListDropdown.layer.borderColor = UIColor.gray.cgColor
        vw_searchCustomerlistName.layer.borderWidth = 0.5
        vw_searchCustomerlistName.layer.borderColor = UIColor.gray.cgColor
        vw_searchCustomerlistName.layer.cornerRadius = 8
        vw_availableTime.layer.borderWidth = 0.5
        vw_availableTime.layer.borderColor = UIColor.gray.cgColor
        
        imgCustomerProfile.layer.cornerRadius = imgCustomerProfile.frame.size.height / 2
        imgCustomerProfile.clipsToBounds = true
        
        self.vw_customerListDropdown.isHidden = true
        self.vw_customerListDropdownHeight.constant = 0
        btnCloseCustomerDropdown.isHidden = true
        self.vw_customerDetails.isHidden = true
        self.vw_customerDetailsHeight.constant = 0
        btnAddNote.isHidden = true
        btnAddNote.isUserInteractionEnabled = false
        lblPrivateClientNotes.isHidden = true
        lblPrivateClientNotesHeight.constant = 0
        vw_privateClientNotes.isHidden = true
        vw_privateClientNotesHeight.constant = 0
        txtChooseCustomer.text = ""
        
        setMainViewHeight()
        
        if isEditEventList {
            btnEdit.isHidden = false
        } else {
            btnEdit.isHidden = true
        }
        txtStartDate.delegate = self
        txtEndDate.delegate = self
    }
    
    func bookValidation() -> Bool {
        if txtChooseService.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Service", viewController: self)
        } else if txtCostOfService.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter cost of service", viewController: self)
        } else if txtChooseCustomer.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Customer", viewController: self)
        } else if txtStartDate.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select start date", viewController: self)
        } else if txtSelectTime.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select start time", viewController: self)
        } else if txtEndDate.text == "" {
            if segmentRepeat.selectedSegmentIndex != 0 {
                AppData.sharedInstance.showAlert(title: "Alert", message: "Please select End Date", viewController: self)
            } else {
                return true
            }
        } else {
            return true
        }
        return false
    }
    
    func setDropdown() {
        for i in 1...100 {
            arrEvery.append(i)
        }
        txtEvery.optionArray = arrEvery.map{ String($0) }
        txtEvery.didSelect { (selectedText, index, id) in
            self.txtEvery.selectText = selectedText
            self.txtEvery.text = selectedText
            self.txtEvery.selectedIndex = index
        }
        
        for i in 1...31 {
            arrDay.append(i)
        }
        txtDay.optionArray = arrDay.map{ String($0) }
        txtDay.didSelect { (selectedText, index, id) in
            self.txtDay.selectText = selectedText
            self.txtDay.text = selectedText
            self.txtDay.selectedIndex = index

        }
        
        txtMonth.optionArray = monthArr
        txtMonth.didSelect { (selectedText, index, id) in
            switch selectedText {
                case "Jan":
                    self.selectedMonth = 01
                case "Feb":
                    self.selectedMonth = 02
                case "Mar":
                    self.selectedMonth = 03
                case "Apr":
                    self.selectedMonth = 04
                case "May":
                    self.selectedMonth = 05
                case "Jun":
                    self.selectedMonth = 06
                case "Jul":
                    self.selectedMonth = 07
                case "Aug":
                    self.selectedMonth = 08
                case "Sep":
                    self.selectedMonth = 09
                case "Oct":
                    self.selectedMonth = 10
                case "Nov":
                    self.selectedMonth = 11
                case "Dec":
                    self.selectedMonth = 12
                default:
                    print("Default")
            }
        }
    }
    
    func callSelectServiceAppointAPI(id: Int?=nil) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        APIUtilities.sharedInstance.PpOSTArrayAPICallWith(url: BASE_URL + SELECT_SERVICE_APPOINTMENT, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? [[String:Any]] {
                self.arrService.removeAll()
                self.arrServiceName.removeAll()
                for dict in res {
                    self.arrService.append(SelectServiceAppointment(dict: dict))
                }
                for item in self.arrService {
                    self.arrServiceName.append(item.serviceName)
                  //  self.arrServiceIds.append(item.id)
                }
                if self.isEditEventList {
                    for dic in self.arrService {
                        if dic.id == id {
                            self.txtChooseService.text = dic.serviceName
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tblService.reloadData()
                }
            }
        }
    }
    
    func callChooseCustomerAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CHOOSE_CUSTOMER, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "resonse") as? [[String:Any]] {
                            self.arrCustomer.removeAll()
                            for dict in response {
                                let dic = ChooseCustomer(dict: dict)
                                  if dic.FirstName != "" || dic.LastName != "" {
                                      self.arrCustomer.append(ChooseCustomer(dict: dict))
                                  }
                            }
                            DispatchQueue.main.async {
                                self.tblCustomerListName.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "resonse") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrCustomer.removeAll()
                            self.tblCustomerListName.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callShowClientNoteAPI(isFromView: Bool) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["id": selectedCustomerId]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_CLIENT_PRIVATE_NOTE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let client = res.value(forKey: "client") as? [[String:Any]] {
                            isFromView ? (self.btnEdit.isHidden = true) : (self.btnEdit.isHidden = false)
                            self.arrClientData.removeAll()
                            for dict in client {
                                self.arrClientData.append(ClientData(dict: dict))
                            }
                            for dic in self.arrClientData {
                                self.lblCustomerDetailName.text = dic.FirstName + " " + dic.LastName
                                self.lblCustomerDetailEmail.text = dic.email
                                self.lblCustomerDetailPhone.text = dic.Phone
                                let url = URL(string: dic.ProfileImg)
                                self.imgCustomerProfile.kf.setImage(with: url)
                                
                                if !isFromView {
                                    self.vw_customerListDropdown.isHidden = true
                                    self.vw_customerListDropdownHeight.constant = 0
                                    self.vw_customerDetails.isHidden = false
                                    self.vw_customerDetailsHeight.constant = 90
                                    self.getCustomerDetails = true
                                }
                                self.clientFirstName = dic.FirstName
                                self.clientLastName = dic.LastName
                                self.zip = dic.Zip
                                self.address = dic.Address
                                self.city = dic.City
                                self.state = dic.State
                                self.country = dic.Country
                            }
                        }
                        if let note = res.value(forKey: "notes") as? [[String:Any]] {
                            isFromView ? (self.showClientNotesOpen = false) : (self.showClientNotesOpen = true)
                            self.arrNotesData.removeAll()
                            for dict in note {
                                self.arrNotesData.append(NotesData(dict: dict))
                            }
                            self.tblPrivateClientNotes.reloadData()
                            if !isFromView {
                                self.btnAddNote.isHidden = false
                                self.btnAddNote.isUserInteractionEnabled = true
                                self.lblPrivateClientNotes.isHidden = false
                                self.lblPrivateClientNotesHeight.constant = 21
                                self.vw_privateClientNotes.isHidden = false
                                self.vw_privateClientNotesHeight.constant = 160
                            }
                        }
                        self.setMainViewHeight()
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
//                            self.arrFilterService.removeAll()
//                            self.arrService.removeAll()
//                            self.tblArchiveList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callServiceProviderAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["service_id": serviceId]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + GET_SERVICE_PROVIDER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let provider = res.value(forKey: "Provider") as? [[String:Any]] {
                    self.arrServiceProvider.removeAll()
                    
                    for dict in provider {
                        self.arrServiceProvider.append(ProviderData(dict: dict))
                    }
                    
                    self.searchedServiceProvider = self.arrServiceProvider
                    self.txtServiceProvider.text = self.arrServiceProvider[0].firstname + " " + self.arrServiceProvider[0].lastname
                    
                    self.selectedServiceProviderID = self.arrServiceProvider[0].id
                    DispatchQueue.main.async {
                        self.tblServiceProvider.reloadData()
                    }
                }
                
                if let info = res.value(forKey: "Info") as? NSDictionary {
                    if let price = info.value(forKey: "Price") as? String {
                        self.txtCostOfService.text = price
                    }
                    if let duration = info.value(forKey: "Duration") as? String {
                        self.txtDuration.text = duration
                    }
                }
            }
        }
    }
    
    func callAvailableTimeSlotsAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["service_provider": selectedServiceProviderID,
                  "service_date": txtStartDate.text ?? "" ,
                  "duration": txtDuration.text ?? ""
        ]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + AVAILABLE_TIMESLOT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let response = res.value(forKey: "response") as? [String] {
                    self.arrAvailableTime.removeAll()
                    for i in response {
                        self.arrAvailableTime.append(i)
                    }
                    self.vw_availableTime.isHidden = false
                    self.vw_availableTimeHeight.constant = 180
                  //  self.vw_mainHeight.constant = 1630
                    self.availableTimeOpen = true
                    
                    self.setMainViewHeight()
                    
                    DispatchQueue.main.async {
                        self.colviewAvailableTime.reloadData()
                    }
                } else if let error = res.value(forKey: "error") as? String {
                    AppData.sharedInstance.showAlert(title: "", message: error, viewController: self)
                }
            }
        }
    }
    
    func callDailyAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        switch segmentRepeat.selectedSegmentIndex {
            case 1:
                params = ["select_for_book": "daily",
                          "startdate": txtStartDate.text ?? "",
                          "enddate": txtEndDate.text ?? ""
                ]
            case 2:
                params = ["select_for_book": "weekly",
                          "startdate": txtStartDate.text ?? "",
                          "enddate": txtEndDate.text ?? "",
                          "day": mon + "," + tue + "," + wed + "," + thu + "," + fri + "," + sat + "," + sun,
                          "every": txtEvery.text ?? ""
                ]
            case 3:
                params = ["select_for_book": "monthly",
                          "startdate": txtStartDate.text ?? "",
                          "enddate": txtEndDate.text ?? "",
                          "dateofmonth": txtDay.text ?? ""
                ]
            case 4:
                params = ["select_for_book": "monthly",
                          "startdate": txtStartDate.text ?? "",
                          "enddate": txtEndDate.text ?? "",
                          "dateofmonth": txtDay.text ?? "",
                          "month": selectedMonth
                ]
            default:
                print("Default")
        }
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DAILY, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [String] {
                            self.arrDates = response
                            self.callBookAppointmentAPI()
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
    
    func callBookAppointmentAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        if segmentRepeat.selectedSegmentIndex == 0 {
            params = ["dates": txtStartDate.text ?? "",
                      "start_date": txtStartDate.text ?? "",
                      "end_date": txtStartDate.text ?? "",
                      "start_time": txtSelectTime.text ?? "",
                      "end_time": selectedEndTime,
                      "FirstName": clientFirstName,
                      "LastName": clientLastName,
                      "Phone": lblCustomerDetailPhone.text ?? "",
                      "Email": lblCustomerDetailEmail.text ?? "",
                      "Zip": zip,
                      "Address": address,
                      "City": city,
                      "State": state,
                      "country": country,
                      "CostOfService": txtCostOfService.text ?? "",
                      "EmailInstruction": txtVwPublicAppointmentNote.text ?? "",
                      "service": txtChooseService.text ?? "",
                      "ServiceName": serviceId,
                      "ServiceProvider": selectedServiceProviderID,
                      "cid": selectedCustomerId,
                      "Location_radio": location,
                      "Accepted": "1",
                      "sync": 0
            ]
        } else {
            params = ["dates": arrDates.joined(separator: ","),
                      "start_date": txtStartDate.text ?? "",
                      "end_date": txtEndDate.text ?? "",
                      "start_time": txtSelectTime.text ?? "",
                      "end_time": selectedEndTime,
                      "FirstName": clientFirstName,
                      "LastName": clientLastName,
                      "Phone": lblCustomerDetailPhone.text ?? "",
                      "Email": lblCustomerDetailEmail.text ?? "",
                      "Zip": zip,
                      "Address": address,
                      "City": city,
                      "State": state,
                      "country": country,
                      "CostOfService": txtCostOfService.text ?? "",
                      "EmailInstruction": txtVwPublicAppointmentNote.text ?? "",
                      "service": txtChooseService.text ?? "",
                      "ServiceName": serviceId,
                      "ServiceProvider": selectedServiceProviderID,
                      "cid": selectedCustomerId,
                      "Location_radio": location,
                      "Accepted": "1",
                      "sync": 0
            ]
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + BOOK_APPOINTMENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.alert(message: response, viewController: self) { action in
                                self.navigationController?.popViewController(animated: true)
                            }
                           // AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                           
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
        
    func setMainViewHeight() {
        switch segmentRepeat.selectedSegmentIndex {
            case 0:
                if availableTimeOpen && showClientNotesOpen {
                    //considered notesview-270
                    vw_mainHeight.constant = 1900
                } else if !availableTimeOpen && showClientNotesOpen {
                    vw_mainHeight.constant = 1720
                } else if availableTimeOpen && !showClientNotesOpen {
                    vw_mainHeight.constant = 1630
                } else if !availableTimeOpen && !showClientNotesOpen {
                    vw_mainHeight.constant = 1450
                }
            case 1:
                if availableTimeOpen && showClientNotesOpen {
                    vw_mainHeight.constant = 1900 + 68
                } else if !availableTimeOpen && showClientNotesOpen {
                    vw_mainHeight.constant = 1720 + 68
                } else if availableTimeOpen && !showClientNotesOpen {
                    vw_mainHeight.constant = 1630 + 68
                } else if !availableTimeOpen && !showClientNotesOpen {
                    vw_mainHeight.constant = 1450 + 68
                }
            case 2:
                if availableTimeOpen && showClientNotesOpen {
                    vw_mainHeight.constant = 1900 + 242
                } else if !availableTimeOpen && showClientNotesOpen {
                    vw_mainHeight.constant = 1720 + 242
                } else if availableTimeOpen && !showClientNotesOpen {
                    vw_mainHeight.constant = 1630 + 242
                } else if !availableTimeOpen && !showClientNotesOpen {
                    vw_mainHeight.constant = 1450 + 242
                }
            case 3:
                if availableTimeOpen && showClientNotesOpen {
                    vw_mainHeight.constant = 1900 + 151
                } else if !availableTimeOpen && showClientNotesOpen {
                    vw_mainHeight.constant = 1720 + 151
                } else if availableTimeOpen && !showClientNotesOpen {
                    vw_mainHeight.constant = 1630 + 151
                } else if !availableTimeOpen && !showClientNotesOpen {
                    vw_mainHeight.constant = 1450 + 151
                }
            case 4:
                if availableTimeOpen && showClientNotesOpen {
                    vw_mainHeight.constant = 1900 + 224
                } else if !availableTimeOpen && showClientNotesOpen {
                    vw_mainHeight.constant = 1720 + 224
                } else if availableTimeOpen && !showClientNotesOpen {
                    vw_mainHeight.constant = 1630 + 224
                } else if !availableTimeOpen && !showClientNotesOpen {
                    vw_mainHeight.constant = 1450 + 224
                }
            default:
                print("Default")
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchedCustomer = arrCustomer.filter({ (customer:ChooseCustomer) -> Bool in
            let name = customer.FirstName + " " + customer.LastName
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            return Name != nil
        })
    }
    
    func filterProviderContentForSearchText(_ searchText: String) {
        searchedServiceProvider = arrServiceProvider.filter({ (provider:ProviderData) -> Bool in
            let name = provider.firstname + " " + provider.lastname
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            return Name != nil
        })
    }
    
    func showHideChooseServiceDropDown () {
        if (serviceDropdownOpen == true) {
            self.vw_serviceDropdown.isHidden = false
            imgServiceDropdown.image = UIImage(named: "up-arrow")
            vw_serviceDropdownHeight.constant = 160
            
            lblServiceProvider.isHidden = true
            vw_serviceprovider.isHidden = true
            imgServiceProviderDropdown.isHidden = true
            btnServiceProvider.isHidden = true
            lblAppointmentDateTime.isHidden = true
            vw_startDate.isHidden = true
            
            vw_serviceProviderDropdown.isHidden = true
            vw_serviceProviderDropdownHeight.constant = 0
            imgServiceProviderDropdown.image = UIImage(named: "down-arrow-1")
            vw_selectTime.isHidden = false
            serviceProviderDropdownOpen = true
            
            serviceDropdownOpen = false
        } else {
            self.vw_serviceDropdown.isHidden = true
            imgServiceDropdown.image = UIImage(named: "down-arrow-1")
            vw_serviceDropdownHeight.constant = 0
            
            lblServiceProvider.isHidden = false
            vw_serviceprovider.isHidden = false
            imgServiceProviderDropdown.isHidden = false
            btnServiceProvider.isHidden = false
            lblAppointmentDateTime.isHidden = false
            vw_startDate.isHidden = false
            
//            vw_serviceProviderDropdown.isHidden = false
//            vw_serviceProviderDropdownHeight.constant = 160
            
            serviceDropdownOpen = true
        }
        tblServiceProvider.reloadData()
    }
    
    func showHideServiceProviderDropDown() {
        if (serviceProviderDropdownOpen == true) {
            self.vw_serviceProviderDropdown.isHidden = false
            imgServiceProviderDropdown.image = UIImage(named: "up-arrow")
            vw_serviceProviderDropdownHeight.constant = 160
            
            lblAppointmentDateTime.isHidden = true
            vw_startDate.isHidden = true
            vw_selectTime.isHidden = true
            
            serviceProviderDropdownOpen = false
        } else {
            self.vw_serviceProviderDropdown.isHidden = true
            imgServiceProviderDropdown.image = UIImage(named: "down-arrow-1")
            vw_serviceProviderDropdownHeight.constant = 0
            
            lblAppointmentDateTime.isHidden = false
            vw_startDate.isHidden = false
            vw_selectTime.isHidden = false
            serviceProviderDropdownOpen = true
        }
    }
    
   func showHideCustomerListDropDown(){
        if (customerListDropdownOpen == true) {
            self.vw_customerListDropdown.isHidden = false
            imgCustomerDropdown.setImage(UIImage(named: "up-arrow")!)
            vw_customerListDropdownHeight.constant = 170
            
            vw_customerDetails.isHidden = true
            vw_customerDetailsHeight.constant = 0
            btnAddNote.isHidden = true
            btnAddNote.isUserInteractionEnabled = false
            
            customerListDropdownOpen = false
        } else {
            self.vw_customerListDropdown.isHidden = true
            imgCustomerDropdown.image = UIImage(named: "down-arrow-1")
            vw_customerListDropdownHeight.constant = 0
            
            if getCustomerDetails == true {
                vw_customerDetails.isHidden = false
                vw_customerDetailsHeight.constant = 90
                btnAddNote.isHidden = false
                btnAddNote.isUserInteractionEnabled = true
            }
            
            customerListDropdownOpen = true
        }
    }
    
    @objc func tappedTextField(_ sender: UITapGestureRecognizer) {
        callAvailableTimeSlotsAPI()
    }

    //MARK:- Actions
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChooseServiceClick(_ sender: UIButton) {
        showHideChooseServiceDropDown ()
    }
    
    @IBAction func btnServiceProviderClick(_ sender: UIButton) {
        showHideServiceProviderDropDown ()
    }
    
    @IBAction func segRepeatValueChanged(_ sender: UISegmentedControl) {
        switch segmentRepeat.selectedSegmentIndex {
            case 0:
                //Off
              //  vw_mainHeight.constant = 1210
                vw_repeatSegViews.isHidden = true
                vw_repeatSegHeight.constant = 0
                setMainViewHeight()
                
            case 1:
                //Daily
              //  vw_mainHeight.constant = 1278
                vw_repeatSegViews.isHidden = false
                vw_repeatSegHeight.constant = 68
                lblEveryHeight.constant = 0
                vw_everyHeight.constant = 0
                lblMonthHeight.constant = 0
                vw_monthHeight.constant = 0
                lblDayHeight.constant = 0
                vw_dayHeight.constant = 0
                lblDaysHeight.constant = 0
                vw_DaysHeight.constant = 0
                lblEndDateTop.constant = 0
                
                lblEvery.isHidden = true
                vw_every.isHidden = true
                lblMonth.isHidden = true
                vw_month.isHidden = true
                lblDay.isHidden = true
                vw_day.isHidden = true
                lblDays.isHidden = true
                vw_Days.isHidden = true
                
                setMainViewHeight()
            case 2:
                //Weekly
               // vw_mainHeight.constant = 1457
                vw_repeatSegViews.isHidden = false
                vw_repeatSegHeight.constant = 247
                lblEveryHeight.constant = 21
                vw_everyHeight.constant = 42
                lblMonthHeight.constant = 0
                vw_monthHeight.constant = 0
                lblDayHeight.constant = 0
                vw_dayHeight.constant = 0
                lblEndDateTop.constant = 83
                lblEndDateHeight.constant = 21
                vw_endDateHeight.constant = 42
                lblDaysHeight.constant = 21
                vw_DaysHeight.constant = 50
                
                lblMonth.isHidden = true
                vw_month.isHidden = true
                lblDay.isHidden = true
                vw_day.isHidden = true
                lblEvery.isHidden = false
                vw_every.isHidden = false
                lblDays.isHidden = false
                vw_Days.isHidden = false
                
                setMainViewHeight()
            case 3:
                //Monthly
               // vw_mainHeight.constant = 1361
                vw_repeatSegViews.isHidden = false
                vw_repeatSegHeight.constant = 151
                lblEveryHeight.constant = 0
                vw_everyHeight.constant = 0
                lblMonthHeight.constant = 0
                vw_monthHeight.constant = 0
                lblDayHeight.constant = 21
                vw_dayHeight.constant = 42
                lblDayTop.constant = 0
                lblEndDateTop.constant = 83
                lblEndDateHeight.constant = 21
                vw_endDateHeight.constant = 42
                lblDaysHeight.constant = 0
                vw_DaysHeight.constant = 0
                
                lblEvery.isHidden = true
                vw_every.isHidden = true
                lblMonth.isHidden = true
                vw_month.isHidden = true
                lblDay.isHidden = false
                vw_day.isHidden = false
                lblEndDate.isHidden = false
                vw_endDate.isHidden = false
                lblDays.isHidden = true
                vw_Days.isHidden = true
                
                setMainViewHeight()
            case 4:
                //Yearly
               // vw_mainHeight.constant = 1444
                vw_repeatSegViews.isHidden = false
                vw_repeatSegHeight.constant = 234
                lblEveryHeight.constant = 0
                vw_everyHeight.constant = 0
                lblMonthHeight.constant = 21
                vw_monthHeight.constant = 42
                lblDayHeight.constant = 21
                vw_dayHeight.constant = 42
                lblEndDateHeight.constant = 21
                vw_endDateHeight.constant = 42
                lblDaysHeight.constant = 0
                vw_DaysHeight.constant = 0
                lblMonthTop.constant = 0
                lblDayTop.constant = 83
                lblEndDateTop.constant = 166
                
                lblEvery.isHidden = true
                vw_every.isHidden = true
                lblMonth.isHidden = false
                vw_month.isHidden = false
                lblDay.isHidden = false
                vw_day.isHidden = false
                lblEndDate.isHidden = false
                vw_endDate.isHidden = false
                lblDays.isHidden = true
                vw_Days.isHidden = true
                
                setMainViewHeight()
            default:
                print("Default Segment")
        }
    }
    
    @IBAction func btnAllDaysClick(_ sender: UIButton) {
        switch sender.tag {
            case 1:
                if sender.isSelected {
                    mon = "0"
                    btnMonday.backgroundColor = UIColor.white
                    btnMonday.setTitleColor(UIColor.init("#15B0DA"), for: .normal)
                    sender.isSelected.toggle()
                } else {
                    mon = "1"
                    btnMonday.backgroundColor = UIColor.init("#15B0DA")
                    btnMonday.setTitleColor(UIColor.white, for: .selected)
                    sender.isSelected.toggle()
                }
            case 2:
                if sender.isSelected {
                    tue = "0"
                    btnTuesday.backgroundColor = UIColor.white
                    btnTuesday.setTitleColor(UIColor.init("#15B0DA"), for: .normal)
                    sender.isSelected.toggle()
                } else {
                    tue = "2"
                    btnTuesday.backgroundColor = UIColor.init("#15B0DA")
                    btnTuesday.setTitleColor(UIColor.white, for: .selected)
                    sender.isSelected.toggle()
                }
            case 3:
                if sender.isSelected {
                    wed = "0"
                    btnWednesday.backgroundColor = UIColor.white
                    btnWednesday.setTitleColor(UIColor.init("#15B0DA"), for: .normal)
                    sender.isSelected.toggle()
                } else {
                    wed = "3"
                    btnWednesday.backgroundColor = UIColor.init("#15B0DA")
                    btnWednesday.setTitleColor(UIColor.white, for: .selected)
                    sender.isSelected.toggle()
                }
            case 4:
                if sender.isSelected {
                    thu = "0"
                    btnThursday.backgroundColor = UIColor.white
                    btnThursday.setTitleColor(UIColor.init("#15B0DA"), for: .normal)
                    sender.isSelected.toggle()
                } else {
                    thu = "4"
                    btnThursday.backgroundColor = UIColor.init("#15B0DA")
                    btnThursday.setTitleColor(UIColor.white, for: .selected)
                    sender.isSelected.toggle()
                }
            case 5:
                if sender.isSelected {
                    fri = "0"
                    btnFriday.backgroundColor = UIColor.white
                    btnFriday.setTitleColor(UIColor.init("#15B0DA"), for: .normal)
                    sender.isSelected.toggle()
                } else {
                    fri = "5"
                    btnFriday.backgroundColor = UIColor.init("#15B0DA")
                    btnFriday.setTitleColor(UIColor.white, for: .selected)
                    sender.isSelected.toggle()
                }
            case 6:
                if sender.isSelected {
                    sat = "0"
                    btnSaturday.backgroundColor = UIColor.white
                    btnSaturday.setTitleColor(UIColor.init("#15B0DA"), for: .normal)
                    sender.isSelected.toggle()
                } else {
                    sat = "6"
                    btnSaturday.backgroundColor = UIColor.init("#15B0DA")
                    btnSaturday.setTitleColor(UIColor.white, for: .selected)
                    sender.isSelected.toggle()
                }
            case 7:
                if sender.isSelected {
                    sun = "0"
                    btnSunday.backgroundColor = UIColor.white
                    btnSunday.setTitleColor(UIColor.init("#15B0DA"), for: .normal)
                    sender.isSelected.toggle()
                } else {
                    sun = "7"
                    btnSunday.backgroundColor = UIColor.init("#15B0DA")
                    btnSunday.setTitleColor(UIColor.white, for: .selected)
                    sender.isSelected.toggle()
                }
            default:
                print("Default")
        }
    }
    
    @IBAction func btnCloseAvailableSlots(_ sender: UIButton) {
        vw_availableTime.isHidden = true
        vw_availableTimeHeight.constant = 0
      //  vw_mainHeight.constant = 1450
        availableTimeOpen = false
        
        setMainViewHeight()
    }
    
    @IBAction func btnRadioLocationSelection(_ sender: UIButton) {
        switch sender.tag {
            case 0:
                if btnRadioSalonLocation.currentImage?.description.contains("radio-off-button") == true {
                    btnRadioSalonLocation.setImage(UIImage(named: "radio-on-button"), for: .normal)
                    btnRadioCustomerLocation.setImage(UIImage(named: "radio-off-button"), for: .normal)
                    location = "Salon Location"
                }
            case 1:
                if btnRadioCustomerLocation.currentImage?.description.contains("radio-off-button") == true {
                    btnRadioCustomerLocation.setImage(UIImage(named: "radio-on-button"), for: .normal)
                    btnRadioSalonLocation.setImage(UIImage(named: "radio-off-button"), for: .normal)
                    location = "Customer Location"
                }
            default:
                print("Default")
        }
    }
    
    @IBAction func btnChooseCustomerClick(_ sender: UIButton) {
      showHideCustomerListDropDown()
    }
    
    @IBAction func btnCloseCustomerDropdownClick(_ sender: UIButton) {
       // txtChooseCustomer.text = ""
    }
    
    @IBAction func btnAddClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerDetailsVC") as! CustomerDetailsVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerDetailsVC") as! CustomerDetailsVC
        VC.isFromClientDetail = true
        VC.selectedClientDetailID = selectedCustomerId
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnAddNoteClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "NotesListVC") as! NotesListVC
        VC.selectedCustomerID = selectedCustomerId
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnBookClick(_ sender: UIButton) {
        if bookValidation() {
            if segmentRepeat.selectedSegmentIndex == 0 {
                callBookAppointmentAPI()
            } else {
                callDailyAPI()
            }
            
        }
    }
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResetClick(_ sender: UIButton) {
        txtChooseService.text = ""
        txtServiceProvider.text = ""
        txtCostOfService.text = ""
        txtDuration.text = ""
        txtStartDate.text = ""
        txtSelectTime.text = ""
        
        txtEndDate.text = ""
        txtEvery.text = "1"
        txtDay.text = "1"
        txtMonth.text = "Jan"
        
        txtChooseCustomer.text = ""
        txtVwPublicAppointmentNote.text = ""
        btnRadioSalonLocation.setImage(UIImage(named: "radio-off-button"), for: .normal)
        btnRadioCustomerLocation.setImage(UIImage(named: "radio-on-button"), for: .normal)
        btnEdit.isHidden = true
        vw_availableTime.isHidden = true
        vw_availableTimeHeight.constant = 0
        vw_customerDetails.isHidden = true
        vw_customerDetailsHeight.constant = 0
        btnAddNote.isHidden = true
        lblPrivateClientNotes.isHidden = true
        lblPrivateClientNotesHeight.constant = 0
        vw_privateClientNotes.isHidden = true
        vw_privateClientNotesHeight.constant = 0
        
    }
    
    @objc func handleStartDate() {
        if let datePicker = self.txtStartDate.inputView as? UIDatePicker {
            datePicker.minimumDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            txtStartDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtStartDate.resignFirstResponder()
    }
    
    @objc func handleEndDate() {
        if let datePicker = self.txtEndDate.inputView as? UIDatePicker {
            datePicker.minimumDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            txtEndDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtEndDate.resignFirstResponder()
    }
    
}

//MARK:- UITableview Datasource Methods
extension BookAppointmentVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
            case tblService:
                if searchingService {
                    return searchedService.count
                } else {
                    return arrService.count
                }
                
            case tblServiceProvider:
                if searchingServiceProvider {
                    return searchedServiceProvider.count
                } else {
                    return arrServiceProvider.count
                }
                
            case tblPrivateClientNotes:
                return arrNotesData.count
                
            case tblCustomerListName:
                if searchingCustomer {
                    return searchedCustomer.count
                } else {
                    return arrCustomer.count
                }
                
            default:
                return 0
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
            case tblService:
                let cell = tblService.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
                if searchingService {
                    cell.lblName.text = searchedService[indexPath.row]
                } else {
                    cell.lblName.text = arrService[indexPath.row].serviceName
                }
                return cell
                
            case tblServiceProvider:
                let cell = tblServiceProvider.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
                if searchingServiceProvider {
                    cell.lblName.text = searchedServiceProvider[indexPath.row].firstname + " " + searchedServiceProvider[indexPath.row].lastname
                  } else {
                    cell.lblName.text = arrServiceProvider[indexPath.row].firstname + " " + arrServiceProvider[indexPath.row].lastname
                }
                
                return cell
                
            case tblPrivateClientNotes:
                let cell = tblPrivateClientNotes.dequeueReusableCell(withIdentifier: "PrivateClientNotesCell", for: indexPath) as! PrivateClientNotesCell
                cell.lblName.text = arrNotesData[indexPath.row].noteTitle
                return cell
                
            case tblCustomerListName:
                let cell = tblCustomerListName.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
                if searchingCustomer {
                    cell.lblName.text = "\(searchedCustomer[indexPath.row].FirstName)" + " " + "\(searchedCustomer[indexPath.row].LastName)"
                } else {
                cell.lblName.text = "\(arrCustomer[indexPath.row].FirstName)" + " " + "\(arrCustomer[indexPath.row].LastName)"
                }
                return cell
            default:
                return UITableViewCell()
        }
    }

}

//MARK:- UITableView Delegate Methods
extension BookAppointmentVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
            case tblService:
                return 40
            case tblServiceProvider:
                return 40
            case tblPrivateClientNotes:
                return 40
            case tblCustomerListName:
                return 40
            default:
                return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
            case tblService:
                let cell = tblService.cellForRow(at: indexPath) as! DropdownCell
                txtChooseService.text = cell.lblName.text
                
                serviceId = arrService[indexPath.row].id
                callServiceProviderAPI()
               
                vw_serviceDropdown.isHidden = true
                vw_serviceDropdownHeight.constant = 0
                lblServiceProvider.isHidden = false
                vw_serviceprovider.isHidden = false
                imgServiceProviderDropdown.isHidden = false
                btnServiceProvider.isHidden = false
                lblAppointmentDateTime.isHidden = false
                vw_startDate.isHidden = false
                 //serviceDropdownOpen = true
                 showHideChooseServiceDropDown()
                self.searchBarService.searchTextField.endEditing(true)
              case tblServiceProvider:
                let cell = tblServiceProvider.cellForRow(at: indexPath) as! DropdownCell
                txtServiceProvider.text = cell.lblName.text
                
                selectedServiceProviderID = arrServiceProvider[indexPath.row].id
                
                self.searchBarService.searchTextField.endEditing(true)
                showHideServiceProviderDropDown()
                
            case tblPrivateClientNotes:
                print("didselect")
                
            case tblCustomerListName:
                let cell = tblCustomerListName.cellForRow(at: indexPath) as! DropdownCell
                txtChooseCustomer.text = cell.lblName.text
                selectedCustomerId = arrCustomer[indexPath.row].id
             //   btnCloseCustomerDropdown.isHidden = false
                customerListDropdownOpen = true
                callShowClientNoteAPI(isFromView: false)
                
                self.searchBarCustomerListName.searchTextField.endEditing(true)
                showHideCustomerListDropDown()
            default:
                print("default didselect")
        }
        
    }
}

//MARK:- UICollectionview DataSource Methods
extension BookAppointmentVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAvailableTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colviewAvailableTime.dequeueReusableCell(withReuseIdentifier: "AvailableTimeSlotsCell", for: indexPath) as! AvailableTimeSlotsCell
        cell.cellView.layer.cornerRadius = 20
        cell.lblTime.text = arrAvailableTime[indexPath.item]
        cell.lblTime.text?.removeLast(8)
        return cell
    }
}

//MARK:- UICollectionview Delegate Methods
extension BookAppointmentVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
}

extension BookAppointmentVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var starttime = arrAvailableTime[indexPath.item]
        starttime.removeLast(8)
        selectedEndTime = starttime
        var endtime = arrAvailableTime[indexPath.item]
        endtime.removeFirst(8)
        selectedEndTime = endtime
        txtSelectTime.text = starttime
    }
}

//MARK:- UISearchbar Delegate Methods
extension BookAppointmentVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch searchBar {
            case searchBarService:
                searchedService = arrServiceName.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
                searchingService = true
                tblService.reloadData()
                
            case searchBarServiceProvider:
                if let searchText = searchBar.text {
                    filterProviderContentForSearchText(searchText)
                    searchingServiceProvider = true
                    if searchText == "" {
                        searchedServiceProvider = arrServiceProvider
                    }
                    tblServiceProvider.reloadData()
                }
                
            case searchBarCustomerListName:
                if let searchText = searchBar.text {
                    filterContentForSearchText(searchText)
                    searchingCustomer = true
                    if searchText == "" {
                        searchedCustomer = arrCustomer
                    }
                    tblCustomerListName.reloadData()
                }
            default:
                print("Default")
        }
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        switch searchBar {
            case searchBarService:
                searchingService = false
                searchBarService.text = ""
                tblService.reloadData()
                searchBarService.resignFirstResponder()
                
            case searchBarServiceProvider:
                searchingServiceProvider = false
                searchBarServiceProvider.text = ""
                tblServiceProvider.reloadData()
                searchBarServiceProvider.resignFirstResponder()
                
            case searchBarCustomerListName:
                searchingCustomer = false
                searchBarCustomerListName.text = ""
                tblCustomerListName.reloadData()
                searchBarCustomerListName.resignFirstResponder()
            default:
                print("Default")
        }
        
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        switch searchBar {
            case searchBarService:
                self.searchBarService.endEditing(true)
                searchBarService.resignFirstResponder()
                
            case searchBarServiceProvider:
                self.searchBarServiceProvider.endEditing(true)
                searchBarServiceProvider.resignFirstResponder()
                
            case searchBarCustomerListName:
                self.searchBarCustomerListName.endEditing(true)
                searchBarCustomerListName.resignFirstResponder()
            default:
                print("Default")
        }
        
    }
}

//MARK:- Textfield Delegate Methods
extension BookAppointmentVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtStartDate {
            self.txtStartDate.setInputViewDatePicker(target: self, selector: #selector(handleStartDate))
        } else if textField == txtEndDate {
            self.txtEndDate.setInputViewDatePicker(target: self, selector: #selector(handleEndDate))
        }
        
    }
}
