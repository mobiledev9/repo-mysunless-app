//
//  WebSiteVC.swift
//  MySunless
//
//  Created by Daydream Soft on 04/03/22.
//

import UIKit
import Alamofire
import Kingfisher
import DKImagePickerController

protocol UpdateBannerAndGallary {
    func updateBannerAndGallaryList(bannerImageList: Bool, galleryImageList: Bool)
}

class WebSiteVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblImageList: UITableView!
    @IBOutlet var txtVwBooking: UITextView!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrBannerImageList = [ShowBannerImageList]()
    var arrGallaryImageList = [ShowGallaryImageList]()
    var arrFilterBannerImageList = [ShowBannerImageList]()
    var arrFilterGallaryImageList = [ShowGallaryImageList]()
    var searchingBanner = false
    var searchingGallary = false
    var modelBanner = ShowBannerImageList(dict: [:])
    var modelGallary = ShowGallaryImageList(dict: [:])
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        
        tblImageList.tableFooterView = UIView()
        tblImageList.estimatedRowHeight = 120
        tblImageList.rowHeight = UITableView.automaticDimension
        tblImageList.refreshControl = UIRefreshControl()
        tblImageList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        tblImageList.reloadData()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowBannerImageListAPI()
        callShowGallaryImageListAPI()
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .clear
        segment.tintColor = .clear
        segment.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 17)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ], for: .normal)
        segment.backgroundColor = UIColor.clear
        segment.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size:17)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)
        
        let attributedString = NSMutableAttributedString.init(string: txtVwBooking.text)
        let range = (txtVwBooking.text as NSString).range(of: "Booking")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init("#15B0DA"), range: range)
        txtVwBooking.attributedText = attributedString
        txtVwBooking.font = UIFont(name: "Roboto-Regular", size: 17)
        txtVwBooking.textAlignment = .justified
        txtVwBooking.isUserInteractionEnabled = true
        txtVwBooking.isEditable = false
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapResponse(recognizer:)))
        tapGesture.numberOfTapsRequired = 1
        txtVwBooking.addGestureRecognizer(tapGesture)
        
    }
    
    func callShowBannerImageListAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]

        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_BANNER_IMAGE_LIST, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
                AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                    AppData.sharedInstance.dismissLoader()
                }
                return
            }
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrBannerImageList.removeAll()
                            for dict in response {
                                self.arrBannerImageList.append(ShowBannerImageList(dict: dict))
                            }
                            self.arrFilterBannerImageList = self.arrBannerImageList
                            DispatchQueue.main.async {
                                self.tblImageList.reloadData()
                            }
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            self.arrBannerImageList.removeAll()
                            self.arrFilterBannerImageList.removeAll()
                            self.tblImageList.reloadData()
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callShowGallaryImageListAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_GALLARY_IMAGE_LIST, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
                AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                    AppData.sharedInstance.dismissLoader()
                }
                return
            }
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrGallaryImageList.removeAll()
                            for dict in response {
                                self.arrGallaryImageList.append(ShowGallaryImageList(dict: dict))
                            }
                            self.arrFilterGallaryImageList = self.arrGallaryImageList
                            DispatchQueue.main.async {
                                self.tblImageList.reloadData()
                            }
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            self.arrGallaryImageList.removeAll()
                            self.arrFilterGallaryImageList.removeAll()
                            self.tblImageList.reloadData()
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callDeleteBannerListAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["delbannerid": id]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_BANNER_IMAGE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.callShowBannerImageListAPI()
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
    
    func callDeleteGallaryListAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["delgallaryid": id]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_GALLARY_IMAGE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.callShowGallaryImageListAPI()
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
    
    func filterContentForSearchText(_ searchText: String) {
        switch segment.selectedSegmentIndex {
            case 0:
                arrFilterBannerImageList = arrBannerImageList.filter({ (bannerImage: ShowBannerImageList) -> Bool in
                    let date = bannerImage.created_at
                    let Date = date.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                  
                    return Date != nil
                })
            case 1:
                arrFilterGallaryImageList = arrGallaryImageList.filter({ (gallaryImage: ShowGallaryImageList) -> Bool in
                    let title = gallaryImage.title
                    let Title = title.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                    let desc = gallaryImage.description
                    let Desc = desc.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                    let date = gallaryImage.created_at
                    let Date = date.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
                    
                    return Title != nil || Desc != nil || Date != nil
                })
            default:
                print("Default")
        }
        
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowBannerImageListAPI()
            self.callShowGallaryImageListAPI()
            self.tblImageList.refreshControl?.endRefreshing()
            self.tblImageList.reloadData()
        }
    }
    
    //MARK:- Actions
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        tblImageList.reloadData()
    }
    
    @IBAction func btnAddImageClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookingPageImageVC") as! BookingPageImageVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        
        let pickerController = DKImagePickerController()
        pickerController.assetType = .allPhotos
        VC.pickerController = pickerController
        
        switch segment.selectedSegmentIndex {
            case 0:
                VC.isForBanner = true
            case 1:
                VC.isForGallary = true
            default:
                print("Default")
        }
        VC.delegate = self
        self.present(VC, animated: true, completion: nil)
        
    }
    
    @IBAction func btnDeleteBannerImageClick(_ sender: UIButton) {
        if searchingBanner {
            callDeleteBannerListAPI(id: arrFilterBannerImageList[sender.tag].id)
            arrFilterBannerImageList.remove(at: sender.tag)
        } else {
            callDeleteBannerListAPI(id: arrBannerImageList[sender.tag].id)
            arrBannerImageList.remove(at: sender.tag)
        }
        tblImageList.reloadData()
    }
    
    @IBAction func btnDeleteGallaryImageClick(_ sender: UIButton) {
        if searchingGallary {
            callDeleteGallaryListAPI(id: arrFilterGallaryImageList[sender.tag].id)
            arrFilterGallaryImageList.remove(at: sender.tag)
        } else {
            callDeleteGallaryListAPI(id: arrGallaryImageList[sender.tag].id)
            arrGallaryImageList.remove(at: sender.tag)
        }
        tblImageList.reloadData()
    }
    
    @IBAction func btnEditGallaryImageClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ImageTitleAndDescVC") as! ImageTitleAndDescVC
        if searchingGallary {
            VC.gallaryImageList = arrFilterGallaryImageList[sender.tag]
            VC.selectedID = arrFilterGallaryImageList[sender.tag].id
        } else {
            VC.gallaryImageList = arrGallaryImageList[sender.tag]
            VC.selectedID = arrGallaryImageList[sender.tag].id
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func tapResponse(recognizer: UITapGestureRecognizer) {
        let location: CGPoint = recognizer.location(in: txtVwBooking)
        let position: CGPoint = CGPoint(x: location.x, y: location.y)
        let tapPosition: UITextPosition? = txtVwBooking.closestPosition(to: position)
        if tapPosition != nil {
            let textRange: UITextRange? = txtVwBooking.tokenizer.rangeEnclosingPosition(tapPosition!, with: UITextGranularity.word, inDirection: UITextDirection(rawValue: 1))
            if textRange != nil {
                let tappedWord: String? = txtVwBooking.text(in: textRange!)
                if (tappedWord == "Booking") {
                      print("tapped word : ", tappedWord ?? "")
//                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ManageEmployeeVC") as! ManageEmployeeVC
//                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
        }
    }
}

//MARK:- UITableView Datasource Methods
extension WebSiteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segment.selectedSegmentIndex {
            case 0:
                if searchingBanner {
                    return arrFilterBannerImageList.count
                } else {
                    return arrBannerImageList.count
                }
            case 1:
                if searchingBanner {
                    return arrFilterGallaryImageList.count
                } else {
                    return arrGallaryImageList.count
                }
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segment.selectedSegmentIndex {
            case 0:
                let cell = tblImageList.dequeueReusableCell(withIdentifier: "BannerImagesCell", for: indexPath) as! BannerImagesCell
                if searchingBanner {
                    modelBanner = arrFilterBannerImageList[indexPath.row]
                } else {
                    modelBanner = arrBannerImageList[indexPath.row]
                }
                cell.lblBannerDate.text = modelBanner.created_at
                let imgUrl = URL(string: modelBanner.banner_img)
                cell.imgProfile.kf.setImage(with: imgUrl)
                cell.btnDeleteBanner.tag = indexPath.row
                return cell
            case 1:
                let cell = tblImageList.dequeueReusableCell(withIdentifier: "GallaryImagesCell", for: indexPath) as! GallaryImagesCell
                if searchingGallary {
                    modelGallary = arrFilterGallaryImageList[indexPath.row]
                } else {
                    modelGallary = arrGallaryImageList[indexPath.row]
                }
                let imgUrl = URL(string: modelGallary.image)
                cell.imgProfile.kf.setImage(with: imgUrl)
                cell.lblTitle.text = modelGallary.title
                cell.lblDesc.text = modelGallary.description
                cell.lblGallaryDate.text = modelGallary.created_at
                cell.btnEditGallary.tag = indexPath.row
                cell.btnDeleteGallary.tag = indexPath.row
                return cell
            default:
                return UITableViewCell()
        }
       
    }
    
}

//MARK:- UISearchBar Delegate Methods
extension WebSiteVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch segment.selectedSegmentIndex {
            case 0:
                if let searchText = searchBar.text {
                    filterContentForSearchText(searchText)
                    searchingBanner = true
                    if searchText == "" {
                        arrFilterBannerImageList = arrBannerImageList
                    }
                    tblImageList.reloadData()
                }
            case 1:
                if let searchText = searchBar.text {
                    filterContentForSearchText(searchText)
                    searchingGallary = true
                    if searchText == "" {
                        arrFilterGallaryImageList = arrGallaryImageList
                    }
                    tblImageList.reloadData()
                }
            default:
                print("Default")
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        switch segment.selectedSegmentIndex {
            case 0:
                searchingBanner = false
            case 1:
                searchingGallary = false
            default:
                print("Default")
        }
        
        searchBar.text = ""
        tblImageList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension WebSiteVC: UpdateBannerAndGallary {
    func updateBannerAndGallaryList(bannerImageList: Bool, galleryImageList: Bool) {
        if bannerImageList {
            callShowBannerImageListAPI()
        } else if galleryImageList {
            callShowGallaryImageListAPI()
        }
    }
}
