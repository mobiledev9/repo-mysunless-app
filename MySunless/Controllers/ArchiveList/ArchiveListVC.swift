//
//  ArchiveListVC.swift
//  MySunless
//
//  Created by Daydream Soft on 07/03/22.
//

import UIKit
import Alamofire
import ScrollableSegmentedControl
import Kingfisher
import SCLAlertView

protocol RestoreServiceDelegate {
    func callRestoreServiceAPI(id: [String])
}

protocol RestoreMemPacDelegate {
    func callRestoreMemPacAPI(id: [String])
    func showUserDetail()
}

protocol RestoreProductDelegate {
    func callRestoreProductAPI(id: [String])
}

protocol RestoreProductCatDelegate {
    func callRestoreProductCatAPI(id: [String])
}

protocol RestoreClientDelegate {
    func callRestoreClientAPI(id: [String])
    func deleteClient(id: Int)
    func showUserDetail()
}

protocol RestoreEventDelegate {
    func callRestoreEventAPI(id: [String])
}

class ArchiveListVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblArchiveList: UITableView!
    @IBOutlet weak var archive_segmentedControl: ScrollableSegmentedControl!
   
    //MARK:- Variable Declarations
    var token = String()
    var tittle = String()
    var arrOfArchiveList = ["Service","Users","Membership Package","Product","Product Category","Clients","Event"]
    var arrService = [ShowServiceList]()
    var arrFilterService = [ShowServiceList]()
    var modelService = ShowServiceList(dict: [:])
    var searchingService = false
    var alertTitle = "Are you sure?"
    var alertSubtitle = "All: 'Restore all items' Selected: 'Restore selected item.'"
    var arrServiceIds = [String]()
    var arrServiceSelectedIds = [String]()
    
    var arrMemPackage = [ShowMembershipPackage]()
    var arrFilterMemPackage = [ShowMembershipPackage]()
    var modelMemPackage = ShowMembershipPackage(dict: [:])
    var searchingMemPackage = false
    var arrMemPackageIds = [String]()
    var arrMemPackageSelectedIds = [String]()
    
    var arrProduct = [ShowProductList]()
    var arrFilterProduct = [ShowProductList]()
    var modelProduct = ShowProductList(dict: [:])
    var searchingProduct = false
    var arrProductIds = [String]()
    var arrProductSelectedIds = [String]()
    
    var arrProductCat = [ShowProductCategory]()
    var arrFilterProductCat = [ShowProductCategory]()
    var modelProductCat = ShowProductCategory(dict: [:])
    var searchingProductCat = false
    var arrProductCatIds = [String]()
    var arrProductCatSelectedIds = [String]()
    
    var arrClient = [ShowClient]()
    var arrFilterClient = [ShowClient]()
    var modelClient = ShowClient(dict: [:])
    var searchingClient = false
    var arrClientIds = [String]()
    var arrClientSelectedIds = [String]()
    
    var arrEvent = [ShowEventList]()
    var arrFilterEvent = [ShowEventList]()
    var modelEvent = ShowEventList(dict: [:])
    var searchingEvent = false
    var arrEventIds = [String]()
    var arrEventSelectedIds = [String]()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        tblArchiveList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        
        tblArchiveList.rowHeight = UITableView.automaticDimension
        tblArchiveList.refreshControl = UIRefreshControl()
        tblArchiveList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        tblArchiveList.reloadData()
        
        callShowServiceListAPI()
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        self.registerCell()
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        searchBar.delegate = self
        setSegmentController()
    }
    
    func setSegmentController() {
        archive_segmentedControl.segmentStyle = .textOnly
        for i in 0..<arrOfArchiveList.count {
            archive_segmentedControl.insertSegment(withTitle: arrOfArchiveList[i], at: i)
        }
        archive_segmentedControl.underlineHeight = 2.0
        archive_segmentedControl.underlineSelected = true
        archive_segmentedControl.selectedSegmentIndex = 0
        tittle = archive_segmentedControl.titleForSegment(at: archive_segmentedControl.selectedSegmentIndex)!
        archive_segmentedControl.fixedSegmentWidth = false
        archive_segmentedControl.backgroundColor = UIColor.init("#E5E4E2")
        let largerBlueTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Roboto-Bold",size:17)!,
                                        NSAttributedString.Key.foregroundColor:UIColor.init("#6D778E")
        ]
        let SelectedTextAttributes = [NSAttributedString.Key.font : UIFont(name:"Roboto-Bold",size:17)!,
                                      NSAttributedString.Key.foregroundColor:UIColor.init("#15B0DA")
        ]
        archive_segmentedControl.setTitleTextAttributes(largerBlueTextAttributes, for: .normal)
        archive_segmentedControl.setTitleTextAttributes(largerBlueTextAttributes, for: .highlighted)
        archive_segmentedControl.setTitleTextAttributes(SelectedTextAttributes, for: .selected)
        archive_segmentedControl.addTarget(self, action: #selector(segmentSelected(_:)), for: .valueChanged)
    }
    
    @objc func segmentSelected(_ sender: ScrollableSegmentedControl) {
        print(arrOfArchiveList[archive_segmentedControl.selectedSegmentIndex])
        switch archive_segmentedControl.selectedSegmentIndex {
            case 0:
                callShowServiceListAPI()
                
            case 2:
                callShowMemPackageListAPI()
            case 3:
                callShowProductListAPI()
            case 4:
                callShowProductCatListAPI()
            case 5:
                callShowClientListAPI()
            case 6:
                callShowEventListAPI()
            default:
                print("Default")
        }
        tblArchiveList.reloadData()
    }
    
    func registerCell() {
        tblArchiveList.register(UINib(nibName: "Archive_ServiceCell", bundle: nil), forCellReuseIdentifier: "Archive_ServiceCell")
        tblArchiveList.register(UINib(nibName: "Archive_UserCell", bundle: nil), forCellReuseIdentifier: "Archive_UserCell")
        tblArchiveList.register(UINib(nibName: "Archive_MembershipPackageCell", bundle: nil), forCellReuseIdentifier: "Archive_MembershipPackageCell")
        tblArchiveList.register(UINib(nibName: "Archive_ProductCell", bundle: nil), forCellReuseIdentifier: "Archive_ProductCell")
        tblArchiveList.register(UINib(nibName: "Archive_ProductCategoryCell", bundle: nil), forCellReuseIdentifier: "Archive_ProductCategoryCell")
        tblArchiveList.register(UINib(nibName: "Archive_ClientsCell", bundle: nil), forCellReuseIdentifier: "Archive_ClientsCell")
        tblArchiveList.register(UINib(nibName: "Archive_EventCell", bundle: nil), forCellReuseIdentifier: "Archive_EventCell")
    }
    
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("Restore All", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(restoreAll(_:)))
        alert.addButton("Selected", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(restoreSelected(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    func callShowServiceListAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_SERVICE_LIST, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrService.removeAll()
                            self.arrServiceIds.removeAll()
                            for dict in response {
                                self.arrService.append(ShowServiceList(dict: dict))
                            }
                            for dic in self.arrService {
                                self.arrServiceIds.append("\(dic.id)")
                            }
                            self.arrFilterService = self.arrService
                            DispatchQueue.main.async {
                                self.tblArchiveList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrFilterService.removeAll()
                            self.arrService.removeAll()
                            self.tblArchiveList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callShowMemPackageListAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_MEMBERSHIP_PACKAGE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrMemPackage.removeAll()
                            self.arrMemPackageIds.removeAll()
                            for dict in response {
                                self.arrMemPackage.append(ShowMembershipPackage(dict: dict))
                            }
                            for dic in self.arrMemPackage {
                                self.arrMemPackageIds.append("\(dic.id)")
                            }
                            self.arrFilterMemPackage = self.arrMemPackage
                            DispatchQueue.main.async {
                                self.tblArchiveList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrFilterMemPackage.removeAll()
                            self.arrMemPackage.removeAll()
                            self.tblArchiveList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    func callShowProductListAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_PRODUCT_LIST, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrProduct.removeAll()
                            self.arrProductIds.removeAll()
                            for dict in response {
                                self.arrProduct.append(ShowProductList(dict: dict))
                            }
                            for dic in self.arrProduct {
                                self.arrProductIds.append("\(dic.id)")
                            }
                            self.arrFilterProduct = self.arrProduct
                            DispatchQueue.main.async {
                                self.tblArchiveList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrFilterProduct.removeAll()
                            self.arrProduct.removeAll()
                            self.tblArchiveList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callShowProductCatListAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_PRODUCT_CATEGORY, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrProductCat.removeAll()
                            self.arrProductCatIds.removeAll()
                            for dict in response {
                                self.arrProductCat.append(ShowProductCategory(dict: dict))
                            }
                            for dic in self.arrProductCat {
                                self.arrProductCatIds.append("\(dic.id)")
                            }
                            self.arrFilterProductCat = self.arrProductCat
                            DispatchQueue.main.async {
                                self.tblArchiveList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrFilterProductCat.removeAll()
                            self.arrProductCat.removeAll()
                            self.tblArchiveList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callShowClientListAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_CLIENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrClient.removeAll()
                            self.arrClientIds.removeAll()
                            for dict in response {
                                self.arrClient.append(ShowClient(dict: dict))
                            }
                            for dic in self.arrClient {
                                self.arrClientIds.append("\(dic.id)")
                            }
                            self.arrFilterClient = self.arrClient
                            
                            DispatchQueue.main.async {
                                self.tblArchiveList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrFilterClient.removeAll()
                            self.arrClient.removeAll()
                            self.tblArchiveList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callDeleteClientAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["delclientid": id]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_CLIENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let succcess = res.value(forKey: "succcess") as? String {
                    if succcess == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.alert(message: response, viewController: self) { (action) in
                                self.callShowClientListAPI()
                            }
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
    
    func callShowEventListAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_EVENT_LIST, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrEvent.removeAll()
                            self.arrEventIds.removeAll()
                            for dict in response {
                                self.arrEvent.append(ShowEventList(dict: dict))
                            }
                            for dic in self.arrEvent {
                                self.arrEventIds.append("\(dic.id)")
                            }
                            self.arrFilterEvent = self.arrEvent
                            
                            DispatchQueue.main.async {
                                self.tblArchiveList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrFilterEvent.removeAll()
                            self.arrEvent.removeAll()
                            self.tblArchiveList.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func filterServiceContentForSearchText(_ searchText: String) {
        arrFilterService = arrService.filter({ (servicelist: ShowServiceList) -> Bool in
            let serviceName = servicelist.ServiceName
            let ServiceName = serviceName.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let price = "$" + servicelist.Price
            let Price = price.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let duration = servicelist.Duration
            let Duration = duration.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let user = servicelist.userbane
            let User = user.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let createdBy = servicelist.Fullname
            let CreatedBy = createdBy.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let deletedDate = AppData.sharedInstance.convertToUTC(dateToConvert: servicelist.datelastupdated)
            let DeletedDate = deletedDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return ServiceName != nil || Price != nil || Duration != nil || User != nil || CreatedBy != nil || DeletedDate != nil
        })
    }
    
    func filterMemPackageContentForSearchText(_ searchText: String) {
        arrFilterMemPackage = arrMemPackage.filter({ (memPackagelist: ShowMembershipPackage) -> Bool in
            let name = memPackagelist.Name
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let price = "$" + memPackagelist.Price
            let Price = price.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let tracking = memPackagelist.Tracking
            let Tracking = tracking.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let desc = memPackagelist.Description
            let Desc = desc.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let createdBy = memPackagelist.Fullname
            let CreatedBy = createdBy.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let deletedDate = AppData.sharedInstance.convertToUTC(dateToConvert: memPackagelist.datelastupdated)
            let DeletedDate = deletedDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || Price != nil || Tracking != nil || Desc != nil || CreatedBy != nil || DeletedDate != nil
        })
    }
    
    func filterProductContentForSearchText(_ searchText: String) {
        arrFilterProduct = arrProduct.filter({ (productlist: ShowProductList) -> Bool in
            let name = productlist.ProductTitle
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let price = "$" + "\(productlist.CompanyCost)"
            let Price = price.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let sellingprice = "$" + "\(productlist.SellingPrice)"
            let SellingPrice = sellingprice.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let quantity = "$" + "\(productlist.NoofPorduct)"
            let Quantity = quantity.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let fullname = productlist.Fullname
            let Fullname = fullname.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let deletedDate = AppData.sharedInstance.convertToUTC(dateToConvert: productlist.datelastupdated)
            let DeletedDate = deletedDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)

            return Name != nil || Price != nil || SellingPrice != nil || Quantity != nil || Fullname != nil || DeletedDate != nil
        })
    }
    
    func filterProductCatContentForSearchText(_ searchText: String) {
        arrFilterProductCat = arrProductCat.filter({ (productcatlist: ShowProductCategory) -> Bool in
            let name = productcatlist.Category
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let fullname = productcatlist.Fullname
            let Fullname = fullname.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let deletedDate = AppData.sharedInstance.convertToUTC(dateToConvert: productcatlist.datelastupdated)
            let DeletedDate = deletedDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Name != nil || Fullname != nil || DeletedDate != nil
        })
    }
    
    func filterClientContentForSearchText(_ searchText: String) {
        arrFilterClient = arrClient.filter({ (clientlist: ShowClient) -> Bool in
            let name = clientlist.FirstName + " " + clientlist.LastName
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let email = clientlist.email
            let Email = email.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let phone = clientlist.Phone
            let Phone = phone.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let address = clientlist.Address + ", " + clientlist.City + ", " + clientlist.State + ", " + clientlist.Zip + ", " + clientlist.Country
            let Address = address.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let fullname = clientlist.Fullname
            let Fullname = fullname.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let deletedDate = AppData.sharedInstance.convertToUTC(dateToConvert: clientlist.datelastupdated)
            let DeletedDate = deletedDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)

            return Name != nil || Email != nil || Phone != nil || Address != nil || Fullname != nil || DeletedDate != nil
        })
    }
    
    func filterEventContentForSearchText(_ searchText: String) {
        arrFilterEvent = arrEvent.filter({ (eventlist: ShowEventList) -> Bool in
            let id = "\(eventlist.id)"
            let ID = id.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let name = eventlist.FirstName + " " + eventlist.LastName
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let title = eventlist.title
            let Title = title.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let date = eventlist.EventDate
            let Date = date.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let status = eventlist.eventstatus
            let Status = status.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let fullname = eventlist.Fullname
            let Fullname = fullname.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let deletedDate = AppData.sharedInstance.convertToUTC(dateToConvert: eventlist.datelastupdated)
            let DeletedDate = deletedDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return ID != nil || Name != nil || Title != nil || Date != nil || Status != nil || Fullname != nil || DeletedDate != nil
        })
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            switch self.archive_segmentedControl.selectedSegmentIndex {
                case 0:
                    self.callShowServiceListAPI()
                case 2:
                    self.callShowMemPackageListAPI()
                case 3:
                    self.callShowProductListAPI()
                case 4:
                    self.callShowProductCatListAPI()
                case 5:
                    self.callShowClientListAPI()
                case 6:
                    self.callShowEventListAPI()
                default:
                    print("Default")
            }
            self.tblArchiveList.refreshControl?.endRefreshing()
            self.tblArchiveList.reloadData()
        }
    }
    
    @IBAction func btnRestoreClick(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func btnRedirectToClick(_ sender: UIButton) {
        switch archive_segmentedControl.selectedSegmentIndex {
            case 0:
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ServicesListVC") as! ServicesListVC
                self.navigationController?.pushViewController(VC, animated: true)
            case 1:
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                self.navigationController?.pushViewController(VC, animated: true)
            case 2:
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "PackagesListVC") as! PackagesListVC
                self.navigationController?.pushViewController(VC, animated: true)
//            case 3:
//                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ServicesListVC") as! ServicesListVC
//                self.navigationController?.pushViewController(VC, animated: true)
//            case 4:
//                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ServicesListVC") as! ServicesListVC
//                self.navigationController?.pushViewController(VC, animated: true)
            case 5:
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ClientsVC") as! ClientsVC
                self.navigationController?.pushViewController(VC, animated: true)
//            case 6:
//                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ServicesListVC") as! ServicesListVC
//                self.navigationController?.pushViewController(VC, animated: true)
            default:
                print("Default")
        }
    }
    
    @objc func restoreAll(_ sender: UIButton) {
        switch archive_segmentedControl.selectedSegmentIndex {
            case 0:
                callRestoreServiceAPI(id: arrServiceIds)
              
            case 2:
                callRestoreMemPacAPI(id: arrMemPackageIds)
            case 3:
                callRestoreProductAPI(id: arrProductIds)
            case 4:
                callRestoreProductCatAPI(id: arrProductCatIds)
            case 5:
                callRestoreClientAPI(id: arrClientIds)
            case 6:
                callRestoreEventAPI(id: arrEventIds)
            default:
                print("Default")
        }
    }
    
    @objc func restoreSelected(_ sender: UIButton) {
        switch archive_segmentedControl.selectedSegmentIndex {
            case 0:
                if arrServiceSelectedIds.count != 0 {
                    callRestoreServiceAPI(id: arrServiceSelectedIds)
                } else {
                    AppData.sharedInstance.showAlert(title: "", message: "No item was selected", viewController: self)
                }
            case 2:
                if arrMemPackageSelectedIds.count != 0 {
                    callRestoreMemPacAPI(id: arrMemPackageSelectedIds)
                } else {
                    AppData.sharedInstance.showAlert(title: "", message: "No item was selected", viewController: self)
                }
            case 3:
                if arrProductSelectedIds.count != 0 {
                    callRestoreProductAPI(id: arrProductSelectedIds)
                } else {
                    AppData.sharedInstance.showAlert(title: "", message: "No item was selected", viewController: self)
                }
            case 4:
                if arrProductCatSelectedIds.count != 0 {
                    callRestoreProductCatAPI(id: arrProductCatSelectedIds)
                } else {
                    AppData.sharedInstance.showAlert(title: "", message: "No item was selected", viewController: self)
                }
            case 5:
                if arrClientSelectedIds.count != 0 {
                    callRestoreClientAPI(id: arrClientSelectedIds)
                } else {
                    AppData.sharedInstance.showAlert(title: "", message: "No item was selected", viewController: self)
                }
            case 6:
                if arrEventSelectedIds.count != 0 {
                    callRestoreEventAPI(id: arrEventSelectedIds)
                } else {
                    AppData.sharedInstance.showAlert(title: "", message: "No item was selected", viewController: self)
                }
            default:
                print("Default")
        }
    }
    
}

//MARK:- UITableView Datasource Methods
extension ArchiveListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch archive_segmentedControl.selectedSegmentIndex {
            case 0:
                if searchingService {
                    return arrFilterService.count
                } else {
                    return arrService.count
                }
                
            case 2:
                if searchingMemPackage {
                    return arrFilterMemPackage.count
                } else {
                    return arrMemPackage.count
                }
            case 3:
                if searchingProduct {
                    return arrFilterProduct.count
                } else {
                    return arrProduct.count
                }
            case 4:
                if searchingProductCat {
                    return arrFilterProductCat.count
                } else {
                    return arrProductCat.count
                }
            case 5:
                if searchingClient {
                    return arrFilterClient.count
                } else {
                    return arrClient.count
                }
            case 6:
                if searchingEvent {
                    return arrFilterEvent.count
                } else {
                    return arrEvent.count
                }
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch archive_segmentedControl.selectedSegmentIndex {
            case 0:
                let cell = tblArchiveList.dequeueReusableCell(withIdentifier: "Archive_ServiceCell", for: indexPath) as! Archive_ServiceCell
                if searchingService {
                    cell.modelService = arrFilterService[indexPath.row]
                } else {
                    cell.modelService = arrService[indexPath.row]
                }
                cell.setCell(index: indexPath.row)
                cell.parent = self
                cell.delegate = self
                return cell
            case 1:
                let cell = tblArchiveList.dequeueReusableCell(withIdentifier: "Archive_UserCell", for: indexPath) as! Archive_UserCell
                return cell
            case 2:
                let cell = tblArchiveList.dequeueReusableCell(withIdentifier: "Archive_MembershipPackageCell", for: indexPath) as! Archive_MembershipPackageCell
                if searchingMemPackage {
                    cell.modelMemPackage = arrFilterMemPackage[indexPath.row]
                } else {
                    cell.modelMemPackage = arrMemPackage[indexPath.row]
                }
                cell.setCell(index: indexPath.row)
                cell.parent = self
                cell.delegate = self
                return cell
            case 3:
                let cell = tblArchiveList.dequeueReusableCell(withIdentifier: "Archive_ProductCell", for: indexPath) as! Archive_ProductCell
                if searchingProduct {
                    cell.modelProduct = arrFilterProduct[indexPath.row]
                } else {
                    cell.modelProduct = arrProduct[indexPath.row]
                }
                cell.setCell(index: indexPath.row)
                cell.parent = self
                cell.delegate = self
                return cell
            case 4:
                let cell = tblArchiveList.dequeueReusableCell(withIdentifier: "Archive_ProductCategoryCell", for: indexPath) as! Archive_ProductCategoryCell
                if searchingProductCat {
                    cell.modelProductCat = arrFilterProductCat[indexPath.row]
                } else {
                    cell.modelProductCat = arrProductCat[indexPath.row]
                }
                cell.setCell(index: indexPath.row)
                cell.parent = self
                cell.delegate = self
                return cell
            case 5:
                let cell = tblArchiveList.dequeueReusableCell(withIdentifier: "Archive_ClientsCell", for: indexPath) as! Archive_ClientsCell
                if searchingClient {
                    cell.modelClient = arrFilterClient[indexPath.row]
                } else {
                    cell.modelClient = arrClient[indexPath.row]
                }
                cell.setCell(index: indexPath.row)
                cell.parent = self
                cell.delegate = self
                return cell
            case 6:
                let cell = tblArchiveList.dequeueReusableCell(withIdentifier: "Archive_EventCell", for: indexPath) as! Archive_EventCell
                if searchingEvent {
                    cell.modelEvent = arrFilterEvent[indexPath.row]
                } else {
                    cell.modelEvent = arrEvent[indexPath.row]
                }
                cell.setCell(index: indexPath.row)
                cell.parent = self
                cell.delegate = self
                return cell
            default:
                return UITableViewCell()
        }
    }
}
//MARK:- UITableView Delegate Methods
extension ArchiveListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension ArchiveListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch archive_segmentedControl.selectedSegmentIndex {
            case 0:
                if let searchText = searchBar.text {
                    filterServiceContentForSearchText(searchText)
                    searchingService = true
                    if searchText == "" {
                        arrFilterService = arrService
                    }
                }
                
            case 2:
                if let searchText = searchBar.text {
                    filterMemPackageContentForSearchText(searchText)
                    searchingMemPackage = true
                    if searchText == "" {
                        arrFilterMemPackage = arrMemPackage
                    }
                }
            case 3:
                if let searchText = searchBar.text {
                    filterProductContentForSearchText(searchText)
                    searchingProduct = true
                    if searchText == "" {
                        arrFilterProduct = arrProduct
                    }
                }
            case 4:
                if let searchText = searchBar.text {
                    filterProductCatContentForSearchText(searchText)
                    searchingProductCat = true
                    if searchText == "" {
                        arrFilterProductCat = arrProductCat
                    }
                }
            case 5:
                if let searchText = searchBar.text {
                    filterClientContentForSearchText(searchText)
                    searchingClient = true
                    if searchText == "" {
                        arrFilterClient = arrClient
                    }
                }
            case 6:
                if let searchText = searchBar.text {
                    filterEventContentForSearchText(searchText)
                    searchingEvent = true
                    if searchText == "" {
                        arrFilterEvent = arrEvent
                    }
                }
            default:
                print("Default")
        }
            tblArchiveList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        switch archive_segmentedControl.selectedSegmentIndex {
            case 0:
                searchingService = false
                
            case 2:
                searchingMemPackage = false
            case 3:
                searchingProduct = false
            case 4:
                searchingProductCat = false
            case 5:
                searchingClient = false
            case 6:
                searchingEvent = false
            default:
                print("Default")
        }
        searchBar.text = ""
        tblArchiveList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension ArchiveListVC: RestoreServiceDelegate, RestoreMemPacDelegate, RestoreProductDelegate, RestoreProductCatDelegate, RestoreClientDelegate, RestoreEventDelegate {
    func callRestoreServiceAPI(id: [String]) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id.joined(separator: ",")]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + RESTORE_SERVICE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.alert(message: response, viewController: self) { (action) in
                                self.callShowServiceListAPI()
                            }
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
    
    func callRestoreMemPacAPI(id: [String]) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id.joined(separator: ",")]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + RESTORE_MEMBERSHIP_PACKAGE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.alert(message: response, viewController: self) { (action) in
                                self.callShowMemPackageListAPI()
                            }
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
    
    func callRestoreProductAPI(id: [String]) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id.joined(separator: ",")]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + RESTORE_PRODUCT, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.alert(message: response, viewController: self) { (action) in
                                self.callShowProductListAPI()
                            }
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
    
    func callRestoreProductCatAPI(id: [String]) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id.joined(separator: ",")]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + RESTORE_PRODUCT_CATEGORY, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.alert(message: response, viewController: self) { (action) in
                                self.callShowProductCatListAPI()
                            }
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
    
    func deleteClient(id: Int) {
        callDeleteClientAPI(id: id)
//        if searchingClient {
//            callDeleteClientAPI(id: arrFilterClient[index].id)
//            arrFilterClient.remove(at: index)
//        } else {
//            callDeleteClientAPI(id: arrClient[index].id)
//            arrClient.remove(at: index)
//        }
        tblArchiveList.reloadData()
    }
    
    func callRestoreClientAPI(id: [String]) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id.joined(separator: ",")]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + RESTORE_CLIENT, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.alert(message: response, viewController: self) { (action) in
                                self.callShowClientListAPI()
                            }
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
    
    func callRestoreEventAPI(id: [String]) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id.joined(separator: ",")]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + RESTORE_EVENT, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.alert(message: response, viewController: self) { (action) in
                                self.callShowEventListAPI()
                            }
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
    
    func showUserDetail() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
